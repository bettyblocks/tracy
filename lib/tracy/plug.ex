defmodule Tracy.Plug do
  import Plug.Conn
  require Logger

  @trigger_header "x-tracy-definition"

  def init(options) do
    options
  end

  def call(conn, _opts) do
    case get_req_header(conn, @trigger_header) do
      nil ->
        :ok
      [definition_id] ->
        Tracy.check_start_trace(definition_id, Logger.metadata()[:request_id], fn() -> trace_metadata(conn) end)
    end
    conn
  end

  @conn_fields ~w(host method script_name request_path port query_string)a
  defp trace_metadata(conn) do
    env =
      @conn_fields
      |> Enum.map(fn(k) -> {k, Map.get(conn, k)} end)
      |> Enum.into(%{})
      |> Map.put(:request_uri, url(conn))
      |> Map.put(:peer, peer(conn))
    # add all request headers
    Enum.reduce(conn.req_headers || [], env,
      fn({header, value}, env) ->
        Map.put(env, "req_header.#{header}", value)
      end)
    |> make_title()
  end

  defp url(%Plug.Conn{scheme: scheme, host: host, port: port} = conn) do
    "#{scheme}://#{host}:#{port}#{conn.request_path}"
  end

  defp peer(%Plug.Conn{peer: {host, port}}) do
    "#{:inet_parse.ntoa host}:#{port}"
  end

  defp make_title(metadata) do
    Map.put(metadata, :title, "#{String.upcase(metadata.method)} #{metadata.request_path}")
  end
end

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
        Tracy.check_start_trace(definition_id, Logger.metadata()[:request_id])
    end
    conn
  end

end

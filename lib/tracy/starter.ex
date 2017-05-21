defmodule Tracy.Starter do

  alias Tracy.TraceSupervisor

  def check_start_trace(definition_id, session_id \\ nil, metadata_fn \\ nil) do
    case :global.whereis_name(TracyWeb.Coordinator) do
      coordinator when is_pid(coordinator) ->
        start_trace(coordinator, definition_id, session_id, metadata_fn)
      :undefined ->
        :not_started
    end
  end

  defp start_trace(coordinator, definition_id, session_id, metadata_fn) do
    process = self()
    try do
      metadata = resolve_metadata(metadata_fn)
      case GenServer.call(coordinator, {:check_start_trace, definition_id, session_id, metadata}) do
        {:ok, {id, config}} ->
          {:ok, tracer} = TraceSupervisor.start_tracer(process, config)
          Tracy.Util.start_trace(config, process, tracer)
          send(process, {:trace_started, id})
          :started
        {:error, :not_found} ->
          :not_started
      end
    catch
      _, e ->
        {:error, e}
    end
  end

  defp resolve_metadata(nil), do: %{}
  defp resolve_metadata(fun) when is_function(fun), do: fun.()

end

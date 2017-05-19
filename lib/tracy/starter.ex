defmodule Tracy.Starter do
  use GenServer

  alias Tracy.TraceSupervisor

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def check_start_trace(definition_id, session_id \\ nil) do
    GenServer.cast(__MODULE__, {:check_start_trace, definition_id, session_id, self()})
  end

  ## server

  def handle_cast({:check_start_trace, definition_id, session_id, process}, state) do
    case :global.whereis_name(TracyWeb.Coordinator) do
      pid when is_pid(pid) ->
        try do
          case GenServer.call(pid, {:check_start_trace, definition_id, session_id}) do
            {:ok, {id, definition, upstream}} ->
              {:ok, tracer} = TraceSupervisor.start_tracer(process, definition, upstream)
              Tracy.Util.start_trace(definition, process, tracer)
              send(process, {:trace_started, id})
              :started
            {:error, :not_found} ->
              :not_started
          end
        catch
          _, e ->
            {:error, e}
        end
      nil ->
        :not_started
    end
    {:noreply, state}
  end

end

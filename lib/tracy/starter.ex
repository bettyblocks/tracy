defmodule Tracy.Starter do
  use GenServer

  alias Tracy.TraceSupervisor

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def check_start_trace(identifier) do
    GenServer.cast(__MODULE__, {:check_start_trace, identifier, self()})
  end

  ## server

  def handle_cast({:check_start_trace, identifier, process}, state) do
    pid = :global.whereis_name(TracyWeb.Coordinator)
    case is_pid(pid) and Process.alive?(pid) do
      true ->
        case GenServer.call(pid, {:check_start_trace, identifier}) do
          {:ok, {id, definition, upstream}} ->
            {:ok, tracer} = TraceSupervisor.start_tracer(process, definition, upstream)
            Tracy.Util.start_trace(definition, process, tracer)
            send(process, {:trace_started, id})
            :started
          {:error, :not_found} ->
            :not_started
        end
      false ->
        :not_started
    end

    {:noreply, state}
  end

end

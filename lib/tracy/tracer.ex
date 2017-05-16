defmodule Tracy.Tracer do
  @moduledoc """
  Tracer process.

  For every active trace, a tracer process is started which receives
  all tracing information from the process being traced.

  This Tracer genserver is responsible for shutting down after the
  max_calls limit has been reached. Furthermore, it passes along all
  incoming traces to an "upstream" process. This construction is
  needed because the upstream process might reside on a different
  node. (as part of the tracy_web app).

  """

  use GenServer

  # Client API
  def start_link(pid, definition, upstream) do
    GenServer.start_link(__MODULE__, {pid, definition, upstream}, name: __MODULE__)
  end

  def stats(pid) do
    GenServer.call(pid, :stats)
  end

  # Server callbacks

  defmodule State do
    defstruct definition: nil, pid: nil, count: 0, upstream: nil
  end

  def init({pid, definition, upstream}) do
    Process.monitor(pid)
    state = %State{
      pid: pid,
      definition: definition,
      upstream: upstream
    }
    {:ok, state}
  end

  def handle_call(:stats, _from, state) do
    {:reply, %{count: state.count}, state}
  end

  def handle_info({:trace, pid, type, payload}, state = %{pid: pid}) do
    state = %State{state | count: state.count + 1}
    send_upstream(type, payload, state.upstream)
    # incoming trace
    if shutdown?(state) do
      {:stop, :normal, state}
    else
      {:noreply, state}
    end
  end

  def handle_info({:DOWN, _, :process, pid, _reason}, state = %{pid: pid}) do
    # traced process exists; stop ourselves
    {:stop, :normal, state}
  end

  defp shutdown?(%{count: count, definition: definition}) do
    count >= definition.max_calls
  end

  defp send_upstream(type, payload, nil), do: :ok
  defp send_upstream(type, payload, pid) do
    send pid, {:trace, type, payload}
  end

end

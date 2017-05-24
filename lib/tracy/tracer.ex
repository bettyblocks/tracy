defmodule Tracy.Tracer do
  @moduledoc """
  Tracer process.

  For every active trace, a tracer process is started which receives
  all tracing information from the process being traced.

  This Tracer genserver is responsible for shutting down after the
  max_entries limit has been reached. Furthermore, it passes along all
  incoming traces to an "upstream" process. This construction is
  needed because the upstream process might reside on a different
  node. (as part of the tracy_web app).

  """

  use GenServer

  # Client API
  def start_link(pid, trace_config) do
    GenServer.start_link(__MODULE__, {pid, trace_config})
  end

  def stats(pid) do
    GenServer.call(pid, :stats)
  end

  # Server callbacks

  defmodule State do
    defstruct trace_config: nil, pid: nil, count: 0
  end

  def init({pid, trace_config}) do
    Process.monitor(pid)
    state = %State{
      pid: pid,
      trace_config: trace_config
    }
    send_upstream({:tracer_started, self()}, state.trace_config.upstream)
    {:ok, state}
  end

  def handle_call(:stats, _from, state) do
    {:reply, %{count: state.count}, state}
  end

  def handle_info({:trace, pid, type, payload}, state = %{pid: pid}) do
    state = %State{state | count: state.count + 1}
    send_upstream({:trace, type, payload}, state.trace_config.upstream)
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

  defp shutdown?(%{count: count, trace_config: trace_config}) do
    count >= trace_config.max_entries
  end

  defp send_upstream(message, nil), do: :ok
  defp send_upstream(message, pid) do
    send pid, message
  end

end

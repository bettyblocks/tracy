defmodule Tracy.Tracer do
  use GenServer

  # Client API
  def start_link(pid, definition) do
    GenServer.start_link(__MODULE__, {pid, definition}, name: __MODULE__)
  end

  # Server callbacks

  defmodule State do
    defstruct definition: nil, pid: nil
  end

  def init({pid, definition}) do
    state = %State{
      pid: pid,
      definition: definition
    }
    {:ok, state}
  end

end

defmodule Tracy do
  @moduledoc """
  Documentation for Tracy.
  """

  @doc """

  Check to start a trace with the given identifier.

  """
  @spec check_start_trace(binary()) :: :started | :not_started
  def check_start_trace(identifier) do
    pid = :global.whereis_name(TracyWeb.Registry)
    GenServer.call(__MODULE__, :command)
  end

end

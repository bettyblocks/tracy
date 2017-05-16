defmodule Tracy do
  @moduledoc """
  Documentation for Tracy.
  """

  alias Tracy.Starter

  @doc """
  Check to start a trace with the given identifier.
  """
  @spec check_start_trace(binary()) :: :ok
  defdelegate check_start_trace(identifier), to: Starter

end

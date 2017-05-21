defmodule Tracy do
  @moduledoc """
  Documentation for Tracy.
  """

  alias Tracy.Starter

  @doc """
  Check to start a trace with the given identifier.
  """
  @spec check_start_trace(binary(), binary() | nil, fun() :: map() | nil) :: :started | :not_started | {:error, term()}
  defdelegate check_start_trace(definition_id, session_id \\ nil, metadata_fn \\ nil), to: Starter

end

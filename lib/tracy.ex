defmodule Tracy do
  @moduledoc """
  Documentation for Tracy.
  """

  alias Tracy.Starter

  @doc """
  Check to start a trace with the given identifier.

  This does a lookup in the background to the global
  TracyWeb.Coordinator process, to see whether the given definition id
  exists. When it does, it will start tracing the current process.

  Optionally, a session id can be passed in to override the otherwise
  auto-generated session id.

  `metadata` can be a function which will be called when the tracing
  is started. It needs to return a map which will contain the trace
  metadata.

  """
  @spec check_start_trace(definition_id:: binary(), session_id :: binary() | nil, metadata :: fun() :: map() | nil) :: :started | :not_started | {:error, term()}
  defdelegate check_start_trace(definition_id, session_id \\ nil, metadata_fn \\ nil), to: Starter

end

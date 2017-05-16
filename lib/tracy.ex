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
    case is_pid(pid) and Process.alive?(pid) do
      true ->
        case GenServer.call(pid, {:check_start_trace, identifier}) do
          {:ok, {definition, tracer}} ->
            Tracy.Util.start_trace(definition, self(), tracer)
            :started
          {:error, :not_found} ->
            :not_started
        end
      false ->
        :not_started
    end
  end

end

defmodule Tracy.TraceConfig do
  defstruct modules: [], id: nil, max_calls: 20000, upstream: nil

  alias __MODULE__, as: TraceConfig

  def new(modules) do
    %TraceConfig{modules: modules, id: Tracy.Util.id()}
  end

end

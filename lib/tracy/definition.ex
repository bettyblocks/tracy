defmodule Tracy.Definition do
  defstruct modules: [], id: nil, max_calls: 2000

  alias __MODULE__, as: Definition

  def new(modules) do
    %Definition{modules: modules, id: Tracy.Util.id()}
  end

end

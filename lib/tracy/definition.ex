defmodule Tracy.Definition do
  defstruct modules: [], id: nil, max_calls: 2000

  alias __MODULE__, as: Definition

  def id() do
    :crypto.strong_rand_bytes(20) |> Base.encode64
  end

  def new(modules) do
    %Definition{modules: modules, id: id()}
  end

end

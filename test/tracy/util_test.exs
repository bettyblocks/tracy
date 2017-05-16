defmodule Tracy.UtilTest do
  use ExUnit.Case

  alias Tracy.{Util, Definition}

  def test_string do
    String.upcase("a")
    String.downcase("B")
    :ok
  end

  test "tracing calls in modules" do

    pid = spawn(fn ->
      :timer.sleep 100
      test_string()
    end)

    definition = Definition.new([String])
    :ok = Util.start_trace(definition, pid, self())

    assert_receive {:trace, _, :call, {String, :upcase, ["a"]}}
    assert_receive {:trace, _, :return_to, {__MODULE__, :test_string, 0}}
    assert_receive {:trace, _, :call, {String, :downcase, ["B"]}}
    assert_receive {:trace, _, :return_to, {__MODULE__, :test_string, 0}}

  end

end

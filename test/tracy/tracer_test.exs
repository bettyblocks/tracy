defmodule Tracy.TracerTest do
  use ExUnit.Case

  alias Tracy.{Definition, Tracer}

  test "message limit of tracer server" do
    definition = Definition.new([String])

    definition = %Definition{definition | max_calls: 10}
    {:ok, pid} = Tracer.start_link(self(), definition, nil)

    for n <- 1..10 do
      assert %{count: n - 1} == Tracer.stats(pid)
      send pid, {:trace, self(), :call, {String, :upcase, ["a"]}}
    end

    :timer.sleep 50

    # tracer process is shut down now
    refute Process.alive?(pid)
  end

  test "tracer process stops when source proces exits" do
    definition = Definition.new([String])
    definition = %Definition{definition | max_calls: 10}
    {:ok, pid} = Tracer.start_link(
      spawn(fn -> :timer.sleep(50) end),
      definition, nil)

    assert Process.alive?(pid)
    :timer.sleep 100
    # tracer process is shut down now
    refute Process.alive?(pid)
  end

  test "messages get passed on to upstream process" do
    parent = self()
    upstream = spawn(fn ->
      assert_receive {:trace, :call, _}
      send parent, :ok
    end)

    definition = Definition.new([String])
    {:ok, pid} = Tracer.start_link(self(), definition, upstream)

    send pid, {:trace, self(), :call, :bla}


    assert_receive :ok
  end

end

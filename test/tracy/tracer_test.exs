defmodule Tracy.TracerTest do
  use ExUnit.Case

  alias Tracy.{TraceConfig, Tracer}

  test "message limit of tracer server" do
    definition = TraceConfig.new([String])

    definition = %TraceConfig{definition | max_entries: 10}
    {:ok, pid} = Tracer.start_link(self(), definition)

    for n <- 1..10 do
      assert %{count: n - 1} == Tracer.stats(pid)
      send pid, {:trace, self(), :call, {String, :upcase, ["a"]}}
    end

    :timer.sleep 50

    # tracer process is shut down now
    refute Process.alive?(pid)
  end

  test "tracer process stops when source proces exits" do
    definition = TraceConfig.new([String])
    definition = %TraceConfig{definition | max_entries: 10}
    {:ok, pid} = Tracer.start_link(
      spawn(fn -> :timer.sleep(50) end),
      definition)

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

    definition = TraceConfig.new([String])
    |> Map.put(:upstream, upstream)
    {:ok, pid} = Tracer.start_link(self(), definition)

    send pid, {:trace, self(), :call, :bla}


    assert_receive :ok
  end

end

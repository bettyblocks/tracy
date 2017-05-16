defmodule Tracy.StarterTest do
  use ExUnit.Case

  test "starter has started" do
    assert is_pid(Process.whereis(Tracy.Starter))

    Tracy.Starter.check_start_trace "bla"
  end
end

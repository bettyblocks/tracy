defmodule Tracy.StarterTest do
  use ExUnit.Case

  test "check_start_trace" do
    assert :not_started = Tracy.Starter.check_start_trace "bla"
  end

end

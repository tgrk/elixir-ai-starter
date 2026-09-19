defmodule ElixirAiStarterTest do
  use ExUnit.Case, async: true

  test "the application starts its registered supervisor" do
    assert is_pid(Process.whereis(ElixirAiStarter.Supervisor))
    assert Supervisor.which_children(ElixirAiStarter.Supervisor) == []
  end

  test "the standalone Tidewave server refuses the test environment" do
    assert_raise RuntimeError, "Tidewave is only available in the development environment", fn ->
      Code.eval_file("scripts/tidewave.exs")
    end
  end
end

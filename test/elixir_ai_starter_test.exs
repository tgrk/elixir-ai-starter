defmodule ElixirAiStarterTest do
  use ExUnit.Case, async: true

  # Application startup is observed through OTP rather than a direct application-module call.
  # credo:disable-for-next-line Jump.CredoChecks.VacuousTest
  test "the application starts its registered supervisor" do
    assert is_pid(Process.whereis(ElixirAiStarter.Supervisor))
    assert Supervisor.which_children(ElixirAiStarter.Supervisor) == []
  end

  # Code.eval_file executes the real script boundary, which this check cannot follow.
  # credo:disable-for-next-line Jump.CredoChecks.VacuousTest
  test "the standalone Tidewave server refuses the test environment" do
    assert_raise RuntimeError, "Tidewave is only available in the development environment", fn ->
      Code.eval_file("scripts/tidewave.exs")
    end
  end
end

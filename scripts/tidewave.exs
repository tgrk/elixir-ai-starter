if Mix.env() != :dev do
  raise "Tidewave is only available in the development environment"
end

port = String.to_integer(System.get_env("TIDEWAVE_PORT", "4000"))
# Keep Bandit's parent alive after Mix finishes evaluating this script.
{:ok, _pid} =
  Agent.start(fn ->
    {:ok, server} = Bandit.start_link(plug: Tidewave, ip: {127, 0, 0, 1}, port: port)
    server
  end)

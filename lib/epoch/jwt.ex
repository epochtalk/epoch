defmodule Epoch.JWT do
  use Joken.Config, default_signer: :pem_rs256

  @impl Joken.Config
  def token_config do
    default_claims()
    |> add_claim("role", fn -> "USER" end, &(&1 in ["ADMIN", "USER"]))
  end
end

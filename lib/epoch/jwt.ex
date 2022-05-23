defmodule Epoch.JWT do
  use Joken.Config, default_signer: :pem_rs256
end

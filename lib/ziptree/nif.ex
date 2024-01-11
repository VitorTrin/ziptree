defmodule Ziptree.Nif do
  @moduledoc false
  use Rustler, otp_app: :ziptree, crate: "ziptree_nif"

  def new(), do: :erlang.nif_error(:nif_not_loaded)

  def size(_ziptree), do: :erlang.nif_error(:nif_not_loaded)

  def put(_ziptree, _key, _value), do: :erlang.nif_error(:nif_not_loaded)

  def delete(_ziptree, _key), do: :erlang.nif_error(:nif_not_loaded)

  def get(_ziptree, _key), do: :erlang.nif_error(:nif_not_loaded)
end

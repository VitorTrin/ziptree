defmodule ZipTree.Nif do
    use Rustler, otp_app: :ziptree, crate: "ziptree_nif"
  
    def new(), do: :erlang.nif_error(:nif_not_loaded)
  end
defmodule TestMe2.Worker do
  def start_link do
    IO.puts("#{__MODULE__}: start_link begin")
    opts = [port: 8000]
    rst = :ranch.start_listener(:Testme2, 100, :ranch_tcp, opts, TestMe2.Handler, [])
    IO.puts("#{__MODULE__}: start_link end")
    {:ok, _} = rst
  end
end

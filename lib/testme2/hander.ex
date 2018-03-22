defmodule TestMe2.Handler do
 # use Agent, restart: :temporary
  
  def start_link(ref, socket, transport, opts) do
    IO.puts("#{__MODULE__}.start_link begin")
   # pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid} = Task.Supervisor.start_child(TestMe2.TaskSupervisor, fn -> TestMe2.Handler.init(ref, socket, transport, opts) end) # :init, [ref, socket, transport, opts])
    IO.inspect(pid)
    IO.puts("#{__MODULE__}.start_link end")
    {:ok, pid}
  end
         
  def init(ref, socket, transport, _Opts = []) do
    IO.puts("#{__MODULE__}.init begin")
    :ok = :ranch.accept_ack(ref)
    IO.puts("#{__MODULE__}.init accept_ack")
    loop(socket, transport)
    IO.puts("#{__MODULE__}.init end")
  end

  def loop(socket, transport) do
    case transport.recv(socket, 0, 50000) do
      {:ok, data} ->
	IO.puts("#{__MODULE__}.loop ok begin")
	# 修改该模块的代码，会重启socket链接，因为socket链接的进程调用了loop。所以连接模块的代码和业务逻辑的代码应该分开，业务逻辑的代码保持restful，确保热更新重启时不会导致运行时环境出问题。
        transport.send(socket, "abcddddeeeeddddddd") # TestMe2.a)
        TestMe2.Handler.loop(socket, transport)
	# IO.puts("#{__MODULE__}.loop ok end")
      _ ->
	IO.puts("#{__MODULE__}.loop _")
        # :ok = transport.close(socket)
	
    end
  end

  def a do
    12
  end
  

  def code_change(_a, _b, _c) do
    IO.puts "code changed!"
  end
  
end

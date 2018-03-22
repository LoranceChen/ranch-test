defmodule TestMe2.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    IO.puts("#{__MODULE__}: start begin")
    children = [
      {Task.Supervisor, name: TestMe2.TaskSupervisor},
      worker(TestMe2.Worker, [])
    ]

    opts = [strategy: :one_for_one, name: TestMe2.Supervisor]
    rst = Supervisor.start_link(children, opts)

    IO.puts("#{__MODULE__}: start end")

    rst
  end
end

# TestMe2
基于ranch（tcp pool）library的尝试  
主要测试hot reload的情况

## 安装可执行环境
- brew install elixir  
:: macOS下安装elixir（会自动安装erlang环境），其他环境见官网
- mix deps.get  
:: 安装项目依赖

## 测试
- iex -S mix  
:: 运行repl
	- 会启动8000端口监听
- telnet localhost 8000  
:: 连接ranch服务器
	- 输入字符可交互
- 修改`lib/testme2/hander.ex`中`transport.send(socket,`这一行的代码，以返回客户端不同的值。  
- 在repl中使用`recompile`执行code reload
- 在telnet中发送消息，观察repl的行为
:: 第一次发送消息返回的内容仍是旧代码，因为这时候loop还是旧的loop代码。
:: 第二次发送消息返回的内容是新代码，因为上次的消息通过`TestMe2.loop`的方式（要带模块名，直接调用`loop`是不行的）触发了更新。
- 重复上面的三个步骤————修改代码，载入新代码，telnet发送消息，会发现服务器端断开了？
  - 问题是为什么会断开呢？
	- 根据下面的[ref 1](https://elixirforum.com/t/does-hot-code-swapping-come-for-free/2493)，使用老代码的进程会被kill掉，因为erlang运行时只维护两套代码，当第二次hot reload时，连接telnet的进程因为用的时老代码，所以会被kill掉了。

## 结论
为了保证正常的热更新，必须确保引用了修改的代码的**进程**是提供restful服务的，比如socket链接这样的代码，放在单独的进程中，不要经常变动这类进程相关的代码，所以尽量抽象出这些逻辑。对于后端来说，保存状态尽量用OTP提供的server，agent，task，并设置好重启策略。另外，与外部环境交互也要保证，比如跟数据库的交互的进程也需要随时原子性（当然，数据库本来就要保证原子性）。Erlang没有银弹，但简化了整个recover crash的过程。

## ref
1 [热更新的关键步骤](https://elixirforum.com/t/does-hot-code-swapping-come-for-free/2493)
2 [前面一小节](http://learnyousomeerlang.com/relups)
3 https://stackoverflow.com/questions/37368376/how-does-erlang-hot-code-swapping-work-in-the-middle-of-activity
4 [good principles](http://www.erlang.se/doc/programming_rules.shtml#REF86715)
5 [not read yet](http://erlang.org/doc/design_principles/appup_cookbook.html#id86501)

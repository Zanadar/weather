defmodule Weather do
  def for(cities) do
    coordinator = spawn(Weather.Coordinator, :loop, [cities])
  end

  def start_match do
    ping = spawn(Weather.Ping, :loop, [])
    pong = spawn(Weather.Pong, :loop, [])
    send(ping, {:ping, pong})
    Process.send_after(ping, :exit, 1000)
    Process.send_after(pong, :exit, 1000)
  end
end

defmodule Weather.Coordinator do

end

defmodule Weather.Ping do
  def loop(count \\ 1) do
    receive do
      {:ping, sender} -> send(sender, {:pong, self})
        count = count + 1
        loop(count)
      :exit -> 
        IO.puts "I'm done! at #{count}"
      _ -> IO.puts "Bad message"
    end
  end
end

defmodule Weather.Pong do
  def loop(count \\ 1) do
    receive do
      {:pong, sender} -> 
        send(sender, {:ping, self})
        count = count + 1
        loop(count)
      :exit -> 
        IO.puts "I'm done! at #{count}"
      _ -> IO.puts "Bad message"
    end
  end
end

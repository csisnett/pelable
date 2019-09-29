defmodule Pelable.PlugAttack do
    use PlugAttack
    require Logger

    rule "block bot", conn do
        case conn.remote_ip do
            {0, 0, 0, 0, 0, 65535, 2660, x} -> block true
        end
        
    end

    rule "allow local", conn do
        Logger.warn("#{inspect conn.remote_ip}")
        allow conn.remote_ip == {127, 0, 0, 1}
    end

    rule "throttle by ip", conn do
        throttle conn.remote_ip,
          period: 60_000, limit: 10,
          storage: {PlugAttack.Storage.Ets, Pelable.PlugAttack.Storage}
    end

    
end
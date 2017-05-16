defmodule Tracy.Util do

  def clear_traces do
    :erlang.trace(:all, false, [:all])
    :erlang.trace_pattern({:_,:_,:_}, false, [:local,:meta,:call_count,:call_time])
    :erlang.trace_pattern({:_,:_,:_}, false, []) # unsets global
  end

  def start_trace(definition, pid, tracer) do
    for mod <- definition.modules do
      :erlang.trace_pattern({mod, :_, :_}, true, [:local])
    end
    :erlang.trace(pid, true, [:call, {:tracer, tracer}])
    :ok
  end

end

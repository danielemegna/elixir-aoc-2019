defmodule Advent7 do

def max_thruster_signal_for(memory) do
  run_amplifier_controller_software_with(memory, [4,3,2,1,0], 0)
end

defp run_amplifier_controller_software_with(_, [], input_signal), do: input_signal

defp run_amplifier_controller_software_with(memory, [phase_setting | rest_phase], input_signal) do
  {_, outputs} = Advent5.run_memory_program(memory, [phase_setting, input_signal])
  run_amplifier_controller_software_with(memory, rest_phase, Enum.at(outputs,0))
end


end

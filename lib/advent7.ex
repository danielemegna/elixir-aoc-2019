defmodule Advent7 do

  def max_thruster_signal_for(memory) do
    get_permutations([0,1,2,3,4])
      |> Enum.map(fn(phase_settings_sequence) ->
        run_amplifier_controller_software_with(memory, phase_settings_sequence, 0)
      end)
      |> Enum.max
  end


  defp run_amplifier_controller_software_with(memory, [phase_setting | rest_phase], input_signal) do
    {_final_memory, outputs} = Advent5.run_memory_program(memory, [phase_setting, input_signal])
    output_signal = Enum.at(outputs, 0)

    if(Enum.empty?(rest_phase)) do
      output_signal
    else
      run_amplifier_controller_software_with(memory, rest_phase, output_signal)
    end
  end

  defp get_permutations([single]), do: [[single]]
  defp get_permutations(list) do
    list |> Enum.flat_map(fn(element) ->
      rest = list -- [element]
      rest_permutations = get_permutations(rest)
      rest_permutations
        |> Enum.map(fn(storter_permutation) -> [element | storter_permutation] end)
    end)
  end

end

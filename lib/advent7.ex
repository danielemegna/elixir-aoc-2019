defmodule Advent7 do

  def resolve_first_part do
    max_thruster_signal_for(read_initial_memory_from_file(), [0,1,2,3,4])
  end

  def resolve_second_part do
    max_thruster_signal_for(read_initial_memory_from_file(), [5,6,7,8,9])
  end

  def max_thruster_signal_for(memory, phase_settings_sequence_elements) do
    generate_permutations(phase_settings_sequence_elements)
      |> Enum.map(fn(phase_settings_sequence) ->
        thruster_signal_with(memory, phase_settings_sequence)
      end)
      |> Enum.max
  end

  defp thruster_signal_with(memory, phase_settings_sequence) do
    initial_amplifier_states = List.duplicate({memory, 0}, 5)
    run_amplifier_software_with(initial_amplifier_states, phase_settings_sequence, 0, 0)
  end

  defp run_amplifier_software_with(amplifier_states, phase_settings_sequence_stack, amplifier_index, input_signal) do
    {phase_setting, phase_settings_sequence_stack} = phase_settings_sequence_stack |> List.pop_at(0)
    inputs = [phase_setting, input_signal] |> Enum.filter(&(&1 !== nil))

    {memory, memory_pointer} = amplifier_states |> Enum.at(amplifier_index)
    machine_state = Intcode.MachineState.new(memory, memory_pointer, inputs)
    {new_memory, last_instruction, outputs} = Intcode.Machine.run_with(machine_state)

    output_signal = Enum.at(outputs, 0)

    if(last_instruction.code.opcode === :halt && amplifier_index === 4) do
      output_signal
    else
      amplifier_states = amplifier_states
        |> List.replace_at(amplifier_index, {new_memory, last_instruction.memory_pointer})

      next_amplifier_index = rem(amplifier_index+1, 5)
      run_amplifier_software_with(amplifier_states, phase_settings_sequence_stack, next_amplifier_index, output_signal)
    end

  end

  defp generate_permutations([single]), do: [[single]]
  defp generate_permutations(list) do
    list |> Enum.flat_map(fn(element) ->
      rest = list -- [element]
      rest_permutations = generate_permutations(rest)
      rest_permutations
        |> Enum.map(fn(storter_permutation) -> [element | storter_permutation] end) 
    end)
  end

  defp read_initial_memory_from_file do
    File.stream!("advent7.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

end

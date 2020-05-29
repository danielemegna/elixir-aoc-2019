defmodule Advent7 do

  def resolve_first_part do
    max_thruster_signal_for(read_initial_memory_from_file())
  end

  def max_thruster_signal_for(memory) do
    get_permutations([0,1,2,3,4])
      |> Enum.map(fn(phase_settings_sequence) ->
        run_amplifier_controller_software_with(memory, phase_settings_sequence, 0)
      end)
      |> Enum.max
  end

  def resolve_second_part do
    max_thruster_signal_FL_for(read_initial_memory_from_file())
  end

  def max_thruster_signal_FL_for(memory) do
    get_permutations([5,6,7,8,9])
      |> Enum.map(fn(phase_settings_sequence) ->
        run_amplifier_controller_software_FL_with(memory, phase_settings_sequence)
      end)
      |> Enum.max
  end

  defp run_amplifier_controller_software_FL_with(memory, phase_settings_sequence) do
    {final_memory1, last_instruction1, outputs} = Advent5.run_memory_program_from_instruction(
      memory, 0, [Enum.at(phase_settings_sequence, 0), 0], []
    )
    {final_memory2, last_instruction2, outputs} = Advent5.run_memory_program_from_instruction(
      memory, 0, [Enum.at(phase_settings_sequence, 1), Enum.at(outputs, 0)], []
    )
    {final_memory3, last_instruction3, outputs} = Advent5.run_memory_program_from_instruction(
      memory, 0, [Enum.at(phase_settings_sequence, 2), Enum.at(outputs, 0)], []
    )
    {final_memory4, last_instruction4, outputs} = Advent5.run_memory_program_from_instruction(
      memory, 0, [Enum.at(phase_settings_sequence, 3), Enum.at(outputs, 0)], []
    )
    {final_memory5, last_instruction5, outputs} = Advent5.run_memory_program_from_instruction(
      memory, 0, [Enum.at(phase_settings_sequence, 4), Enum.at(outputs, 0)], []
    )

    amplifier_states = [
      {final_memory1, last_instruction1.memory_pointer},
      {final_memory2, last_instruction2.memory_pointer},
      {final_memory3, last_instruction3.memory_pointer},
      {final_memory4, last_instruction4.memory_pointer},
      {final_memory5, last_instruction5.memory_pointer},
    ]
    run_amplifier_controller_software_FL(amplifier_states, Enum.at(outputs,0))
  end

  defp run_amplifier_controller_software_FL(amplifier_states, input_signal) do
    [
      {final_memory1, last_instruction1_memory_pointer},
      {final_memory2, last_instruction2_memory_pointer},
      {final_memory3, last_instruction3_memory_pointer},
      {final_memory4, last_instruction4_memory_pointer},
      {final_memory5, last_instruction5_memory_pointer},
    ] = amplifier_states

    {final_memory1, last_instruction1, outputs} = Advent5.run_memory_program_from_instruction(
      final_memory1, last_instruction1_memory_pointer, [input_signal], []
    )
    {final_memory2, last_instruction2, outputs} = Advent5.run_memory_program_from_instruction(
      final_memory2, last_instruction2_memory_pointer, [Enum.at(outputs, 0)], []
    )
    {final_memory3, last_instruction3, outputs} = Advent5.run_memory_program_from_instruction(
      final_memory3, last_instruction3_memory_pointer, [Enum.at(outputs, 0)], []
    )
    {final_memory4, last_instruction4, outputs} = Advent5.run_memory_program_from_instruction(
      final_memory4, last_instruction4_memory_pointer, [Enum.at(outputs, 0)], []
    )
    {final_memory5, last_instruction5, outputs} = Advent5.run_memory_program_from_instruction(
      final_memory5, last_instruction5_memory_pointer, [Enum.at(outputs, 0)], []
    )

    if(last_instruction5.code.opcode === :read) do
      amplifier_states = [
        {final_memory1, last_instruction1.memory_pointer},
        {final_memory2, last_instruction2.memory_pointer},
        {final_memory3, last_instruction3.memory_pointer},
        {final_memory4, last_instruction4.memory_pointer},
        {final_memory5, last_instruction5.memory_pointer},
      ]
      run_amplifier_controller_software_FL(amplifier_states, Enum.at(outputs,0))
    else
      Enum.at(outputs,0)
    end
  end

  defp run_amplifier_controller_software_with(memory, [phase_setting | rest_phase], input_signal) do
    {_final_memory, _last_instruction, outputs} = Advent5.run_memory_program(memory, [phase_setting, input_signal])
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

  defp read_initial_memory_from_file do
    File.stream!("advent7.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

end

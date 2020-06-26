defmodule Intcode.Machine do
  alias Intcode.Instruction
  
  def run_with(machine_state) do
    instruction = Instruction.build_from(
      Enum.at(machine_state.memory, machine_state.instruction_pointer),
      machine_state.instruction_pointer,
      machine_state.relative_base
    )

    if(halt_program_instruction?(instruction, machine_state.inputs_stack)) do
      { machine_state, instruction }
    else
      new_machine_state = compute_instruction(instruction, machine_state)
      run_with(new_machine_state)
    end
  end

  defp halt_program_instruction?(%{code: %{opcode: :halt}}, _), do: true
  defp halt_program_instruction?(%{code: %{opcode: :read}}, []), do: true
  defp halt_program_instruction?(_, _), do: false

  defp compute_instruction(%{code: %{opcode: :read}} = instruction, machine_state) do
    [next_input_value | inputs_rest ] = machine_state.inputs_stack
    first_parameter = Instruction.first_parameter_from(instruction, machine_state.memory)
    new_memory = machine_state.memory |> List.replace_at(first_parameter, next_input_value)
    %{machine_state | memory: new_memory, instruction_pointer: new_instruction_pointer(instruction), inputs_stack: inputs_rest}
  end

  defp compute_instruction(%{code: %{opcode: :write}} = instruction, machine_state) do
    first_parameter = Instruction.first_parameter_from(instruction, machine_state.memory)
    new_outputs_stack = machine_state.outputs_stack ++ [first_parameter]
    %{machine_state | instruction_pointer: new_instruction_pointer(instruction), outputs_stack: new_outputs_stack}
  end

  defp compute_instruction(%{code: %{opcode: opcode}} = instruction, machine_state)
    when opcode in [:jump_if_true, :jump_if_false]
  do
    first_parameter = Instruction.first_parameter_from(instruction, machine_state.memory)
    second_parameter = Instruction.second_parameter_from(instruction, machine_state.memory)
    should_jump = case(opcode) do
      :jump_if_true -> first_parameter != 0
      :jump_if_false -> first_parameter == 0
    end
    new_instruction_pointer =
      if(should_jump) do second_parameter
      else new_instruction_pointer(instruction)
      end
      
    %{machine_state | instruction_pointer: new_instruction_pointer}
  end

  defp compute_instruction(instruction, machine_state) do
    first_parameter = Instruction.first_parameter_from(instruction, machine_state.memory)
    second_parameter = Instruction.second_parameter_from(instruction, machine_state.memory)
    third_parameter = Instruction.third_parameter_from(instruction, machine_state.memory)

    instruction_result = case(instruction.code.opcode) do
      :add -> first_parameter + second_parameter
      :mult -> first_parameter * second_parameter
      :less_than -> (if (first_parameter < second_parameter), do: 1, else: 0)
      :equals -> (if (first_parameter == second_parameter), do: 1, else: 0)
    end
    new_memory = machine_state.memory |> List.replace_at(third_parameter, instruction_result)
    %{machine_state | memory: new_memory, instruction_pointer: new_instruction_pointer(instruction)}
  end

  defp new_instruction_pointer(instruction), do: instruction.memory_pointer + instruction.length

end

defmodule Intcode.Machine do
  alias Intcode.Instruction
  
  def run_memory_program(memory, inputs_stack), do:
    run_memory_program_from_instruction(memory, 0, 0, inputs_stack, []) 

  def run_memory_program_from_instruction(memory, instruction_pointer, inputs_stack, outputs_stack), do:
    run_memory_program_from_instruction(memory, instruction_pointer, 0, inputs_stack, outputs_stack)

  def run_memory_program_from_instruction(memory, instruction_pointer, relative_base, inputs_stack, outputs_stack) do
    instruction = Instruction.build_from(
      Enum.at(memory, instruction_pointer),
      instruction_pointer,
      relative_base
    )

    if(halt_program_instruction?(instruction, inputs_stack)) do
      { memory, instruction, outputs_stack }
    else
      { new_memory, new_instruction_pointer, new_inputs_stack, new_outputs_stack } =
        compute_instruction(memory, instruction, inputs_stack, outputs_stack)

      run_memory_program_from_instruction(
        new_memory, new_instruction_pointer, relative_base, new_inputs_stack, new_outputs_stack
      )
    end
  end

  defp halt_program_instruction?(%{code: %{opcode: :halt}}, _), do: true
  defp halt_program_instruction?(%{code: %{opcode: :read}}, []), do: true
  defp halt_program_instruction?(_, _), do: false

  defp compute_instruction(memory, %{code: %{opcode: :read}} = instruction, [next_input_value | inputs_rest], outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    new_memory = memory |> List.replace_at(first_parameter, next_input_value)
    { new_memory, instruction.memory_pointer + instruction.length, inputs_rest, outputs_stack }
  end

  defp compute_instruction(memory, %{code: %{opcode: :write}} = instruction, inputs_stack, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    new_outputs_stack = outputs_stack ++ [first_parameter]
    { memory, instruction.memory_pointer + instruction.length, inputs_stack, new_outputs_stack }
  end

  defp compute_instruction(memory, %{code: %{opcode: opcode}} = instruction, inputs_stack, outputs_stack)
    when opcode in [:jump_if_true, :jump_if_false]
  do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    second_parameter = Instruction.second_parameter_from(instruction, memory)
    should_jump = case(opcode) do
      :jump_if_true -> first_parameter != 0
      :jump_if_false -> first_parameter == 0
    end
    new_instruction_pointer =
      if(should_jump) do second_parameter
      else instruction.memory_pointer + instruction.length
      end
      
    { memory, new_instruction_pointer, inputs_stack, outputs_stack }
  end

  defp compute_instruction(memory, instruction, inputs_stack, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    second_parameter = Instruction.second_parameter_from(instruction, memory)
    third_parameter = Instruction.third_parameter_from(instruction, memory)

    instruction_result = case(instruction.code.opcode) do
      :add -> first_parameter + second_parameter
      :mult -> first_parameter * second_parameter
      :less_than -> (if (first_parameter < second_parameter), do: 1, else: 0)
      :equals -> (if (first_parameter == second_parameter), do: 1, else: 0)
    end
    new_memory = memory |> List.replace_at(third_parameter, instruction_result)
    { new_memory, instruction.memory_pointer + instruction.length, inputs_stack, outputs_stack }
  end

end

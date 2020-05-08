defmodule Advent5 do

  def resolve do
    read_initial_memory_from_file()
      |> run_memory_program_with_inputs([1])
  end

  def run_memory_program_from_instruction(memory, instruction_pointer, inputs) do
    instruction_code = InstructionCode.build_from(Enum.at(memory, instruction_pointer))
    if(halt_program_instruction?(instruction_code)) do
      memory
    else
      memory
        |> compute_instruction(instruction_code, instruction_pointer)
        |> run_memory_program_from_instruction(instruction_pointer + 4, inputs)
    end
  end

  defp run_memory_program_with_inputs(memory, inputs) do
    run_memory_program_from_instruction(memory, 0, inputs)
  end

  defp read_initial_memory_from_file do
    File.stream!("advent5.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

  defp halt_program_instruction?(instruction_code) do
    instruction_code.opcode == 99
  end

  defp compute_instruction(memory, instruction_code, instruction_pointer) do
    first_parameter = case(instruction_code.first_parameter_mode) do
      1 -> Enum.at(memory, instruction_pointer + 1)
      0 -> Enum.at(memory, Enum.at(memory, instruction_pointer + 1))
    end
    second_parameter = case(instruction_code.second_parameter_mode) do
      1 -> Enum.at(memory, instruction_pointer + 2)
      0 -> Enum.at(memory, Enum.at(memory, instruction_pointer + 2))
    end
    third_parameter = Enum.at(memory, instruction_pointer + 3)

    instruction_result = case(instruction_code.opcode) do
      1 -> first_parameter + second_parameter
      2 -> first_parameter * second_parameter
    end
    List.replace_at(memory, third_parameter, instruction_result)
  end

end

defmodule InstructionCode do
  defstruct opcode: 1, first_parameter_mode: 0, second_parameter_mode: 0, third_parameter_mode: 0

  def build_from(code) do
    %InstructionCode{
      opcode: rem(code, 100),
      first_parameter_mode: rem(div(code, 100), 10),
      second_parameter_mode: rem(div(code, 1000), 10),
      third_parameter_mode: div(code, 10000)
    }
  end

end

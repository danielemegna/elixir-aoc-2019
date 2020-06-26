defmodule Intcode.MachineState do
  @enforce_keys [:memory, :instruction_pointer, :relative_base, :inputs_stack, :outputs_stack]
  defstruct @enforce_keys

  def new(memory, inputs \\ []) do
    new(memory, 0, 0, inputs, [])
  end

  def new(memory, instruction_pointer, inputs) do
    new(memory, instruction_pointer, 0, inputs, [])
  end

  def new(memory, instruction_pointer, relative_base, inputs_stack, outputs_stack) do
    %Intcode.MachineState{
      memory: memory,
      instruction_pointer: instruction_pointer,
      relative_base: relative_base,
      inputs_stack: inputs_stack,
      outputs_stack: outputs_stack
    }
  end
end

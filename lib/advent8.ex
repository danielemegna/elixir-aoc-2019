defmodule Image do
  @enforce_keys [:width, :height, :layers]
  defstruct @enforce_keys
end
defmodule Layer do
  @enforce_keys [:rows]
  defstruct @enforce_keys
end

defmodule Advent8 do

  def resolve do
    image = image_from(read_image_digits_from_file(), 25, 6)

    fewest_zeros_layer = image.layers
      |> Enum.sort_by(fn(layer) ->
        layer.rows |> List.flatten |> Enum.filter(&(&1 === 0)) |> Enum.count
      end)
      |> Enum.at(0)

    layer_digits = fewest_zeros_layer.rows |> List.flatten
    one_digit_count = layer_digits |> Enum.filter(&(&1 === 1)) |> Enum.count
    two_digit_count = layer_digits |> Enum.filter(&(&1 === 2)) |> Enum.count
    one_digit_count * two_digit_count
  end

  def image_from(digits, wide, tail) do
    layers = digits
      |> Enum.chunk_every(wide * tail)
      |> Enum.map(fn(layer_digits) -> 
        %Layer{ rows: Enum.chunk_every(layer_digits, wide) } 
      end)
    %Image{ width: wide, height: tail, layers: layers }
  end

  def merge_image_layers(source) do
    merged_rows = source.layers
      |> Enum.map(&(&1.rows))
      |> Enum.zip
      |> Enum.map(fn(zipped_rows) ->
        zipped_rows |> Tuple.to_list |> Enum.zip
      end)
      |> Enum.map(fn(row_with_zipped_digits) ->
        Enum.map(row_with_zipped_digits, fn(digits_on_same_position) ->
          digits_on_same_position
            |> Tuple.to_list
            |> Enum.find(2, &(&1 !== 2))
        end)
      end)

    %Image{
      width: source.width,
      height: source.height,
      layers: [%Layer{rows: merged_rows}]
    }
  end

  defp read_image_digits_from_file do
    File.stream!("advent8.txt")
      |> Enum.at(0)
      |> String.codepoints
      |> remove_last
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

  defp remove_last(list), do: Enum.reverse(list) |> tl() |> Enum.reverse

end

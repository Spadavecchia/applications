defmodule Applications do
  @moduledoc """
  Documentation for Applications.
  """

  alias Faker.{Lorem, UUID}

  @storage_dir "storage/"
  @max_number_of_keys 10_000
  @max_number_of_files 100

  def create(num_apps, base_limit, internal_limit) do
    check_storage_directory(@storage_dir)

    valid =
      base_limit * internal_limit <= @max_number_of_keys and num_apps <= @max_number_of_files

    do_create(num_apps, base_limit, internal_limit, valid)
  end

  def do_create(_num_apps, _base_limit, _internal_limit, _is_valid? = false) do
    IO.puts("Total number of keys is max #{@max_number_of_keys}")
    IO.puts("Total number of files is max #{@max_number_of_files}")
  end

  def do_create(num_apps, base_limit, internal_limit, _is_valid? = true) do
    for _ <- 1..num_apps do
      Task.async(fn -> create_map({base_limit, internal_limit}) end)
    end
    |> Enum.each(fn task ->
      file =
        task
        |> Task.await(1_500_000)
        |> :erlang.term_to_binary()
        |> :zlib.compress()

      File.write!("#{@storage_dir}#{UUID.v4()}", file)
    end)

    IO.puts("#{num_apps} applications created")
  end

  defp check_storage_directory(path) do
    unless File.exists?(path) do
      File.mkdir!(path)
    end
  end

  defp create_map({base_limit, internal_limit}) do
    for _ <- 1..base_limit, into: %{} do
      internal_map =
        for _ <- 1..internal_limit, into: %{} do
          {UUID.v4(), 10 |> Lorem.paragraphs() |> Enum.join()}
        end

      {UUID.v4(), internal_map}
    end
  end

  def load do
    bb_map =
      for file <- File.ls!(@storage_dir), into: %{} do
        {file, load_file(file)}
      end

    IO.puts("All file were loaded")

    bb_map
  end

  defp load_file(file_name) do
    "#{@storage_dir}#{file_name}"
    |> File.read!()
    |> :zlib.uncompress()
    |> :erlang.binary_to_term()
  end
end

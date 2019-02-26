# Applications

* Start a new iex session `iex -S mix`
* start the observer to view the memory use: `:observer.start`
* generate 100 **applications** using: `iex> Applications.create(100, 20, 20)`
* or you can measure the performance using: `iex> :timer.tc(Applications, :create, [100, 100, 100])` (100, 100, 100 is the limit) and can last until 10 minutes in be created
* applications will be saved into `storage` directory
* force a garbage collection with: `iex> :erlang.garbage_collect()`
* load the applications in memory with `iex> bb = Applications.load()`
* now you can play with the bb map
  * `iex> first_app_id = bb |> Map.keys() |> hd()`
  * `iex> first_app = Map.get(bb, first_app_id)`
  * `iex> first_text_id = first_app |> Map.keys() |> hd()`
  * `iex> Map.get(first_app, first_text_id)`

The biggest map has 10_000 keys with text (100 x 100). If we pass the text to a word processor we're talking of 4.000 pages of text without white lines.

The biggest map (an improbable application) has a size of 20Mb in memory and about 5Mb in disk. A normal metadata should be a fraction of this size.

A modest map, about 400 keys with text, has a size of 1Mb in memory and 200Kb in disk.

Load 400 modest applications from disk takes 1.2 seconds (3 milliseconds by application)

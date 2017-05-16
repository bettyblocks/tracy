# Tracy

Library for live Elixir function call tracing.

## Usage

A node must be available on the cluster with the `tracy_master` application running.

For tracing a web request, use a custom request header,
e.g. `X-Tracy-Id: asdasdf` and then call `Tracy.check_start_trace/1`
with the header's value to start a trace.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tracy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:tracy, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tracy](https://hexdocs.pm/tracy).

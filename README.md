# Tracy

Library for visual Elixir function call tracing.

This repository contains the `tracy` OTP application which is a
"client" application which can perform realtime tracing of processes
in a running node.

To set up the tracing configuration and viewing the trace results, the
`tracy_web` application is required.


## Usage

A node must be available on the cluster with the `tracy_web` application running.

For tracing a web request, use a custom request header,
e.g. `X-Tracy-definition: asdasdf` and then call `Tracy.check_start_trace/1`
with the header's value to start a trace.

For plug-based applications (e.g. Phoenix) you can `plug Tracy.Plug`
to automatically start tracing when the `X-Tracy-Definition` request
header is set.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tracy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:tracy, "~> 0.1.0"}]
end
```

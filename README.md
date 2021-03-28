# PiedPinger

Pied Piper is a "Silicon Valley" startup that helps you ensure your websites are online.

Step 1. Give us a fully qualified URL
Step 2. We'll tell you the HTTP status code it returns.
Step 3. Profit

#Elixir #Phoenix #LiveView #BuiltToFly



## To start your Phoenix server in development:

* Install dependencies with `mix deps.get`
* Install Node.js dependencies with `npm install` inside the `assets` directory
* Start Phoenix endpoint with `mix phx.server`

### To run multiple nodes
* Specify the `PORT` environment variable and set the node name. Run multiple nodes as shown below:
* Run `PORT=4000 iex --sname a -S mix phx.server`
* Run `PORT=4001 iex --sname b -S mix phx.server`
* Run `PORT=4002 iex --sname c -S mix phx.server`
* You may need to configure the cluster strategy used in development if automatic clustering doesn't work. See `config/dev.exs` and the `libcluster` docs.

Now you can visit [`localhost:PORT`](http://localhost:4000) from your browser.

## To deploy on Fly

* See the [Fly.io Speedrun](https://fly.io/docs/speedrun/) docs.
* Install flyctl, run `flyctl auth signup` or `flyctl auth login`
* Create an app on the fly website, or in an empty DIR. Be sure not to clobber the `fly.toml` file in this repo if you create your app with `flyctl init`.
* Update `fly.toml` with your app name.
* Update `config/prod.exs` with your Fly app domain name.
* Run `flyctl deploy`
* Profit!!!, or whatever.

## Changelog

## Version 1.2.0
* Add support for measuring and reporting response times of HTTP requests.
* Better display up vs down results for each node.

### Version 1.1.0
* `PORT` env var can be specified in development.
* Adds `libcluster` dep with GOSSIP config in dev.
* Add `libcluster` config for release
* Adds support for multiple nodes.
* App version in `mix.exs` was incorrect.

### Version 1.0.0
* Initial release
* Built to run a on a single node.
* Needs to implement TailwindCSS purging.
* App version in `mix.exs` was incorrect.
* Elixir 1.11.2 | OTP 23 | Node v15.11.0

## Licensing notes
* Logo: Font in use Dustismo_Roman_Bold designed by Dustin Norlander and licensed under GNU General Public License. Icon Designed by Brennan Novak. https://www.namecheap.com/logo-maker/app/editor
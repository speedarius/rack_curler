# RackCurler

Given a Rack env, generate a nicely formatted curl command that approximates the request. Suitable for debugging.

## Installation

Add this line to your application's Gemfile:

    gem 'rack_curler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack_curler

## Usage

Where ```env``` is a Rack env:

   RackCurler.to_curl(env)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

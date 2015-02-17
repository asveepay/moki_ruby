# MokiRuby

[![travis-status](https://travis-ci.org/bellycard/moki_ruby.svg)](https://travis-ci.org/bellycard/moki_ruby) [![Gem
Version](https://badge.fury.io/rb/moki_ruby.svg)](http://badge.fury.io/rb/moki_ruby)

A ruby gem for interacting with the Moki API, as a part of Moki Total
Control and Moki Management.

## Installation

Add this line to your application's Gemfile:

    gem 'moki_ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moki_ruby

## Usage

Make sure to set the following environment variables:

```
ENV['MOKI_API_URL']
ENV['MOKI_TENANT_ID']
ENV['MOKI_API_KEY']
```

The following methods have been built out:

- `MokiRuby.ios_profiles` asks for all current profiles associated with this tenant.
- `MokiRuby.device_profiles(device_id)` asks for all profiles installed
  on the provided device. `device_id` must be a UDID or a serial number.
- `MokiRuby.device_managed_apps(device_id)` asks for all managed apps on
  a specific device, provided in a simplified list.

## Contributing

1. Fork it ( https://github.com/bellycard/moki_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

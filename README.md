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

Make sure to set the following environment variables:

```
ENV['MOKI_API_URL']
ENV['MOKI_TENANT_ID']
ENV['MOKI_API_KEY']
```

## Usage

Device management can be done at the Tenant Level (across all devices)
or at the individual device level.

### Tenant Methods

The following methods have been built out:

- `MokiRuby.ios_profiles` asks for all current profiles associated with this
  tenant. This will return an array of `IOSProfile` objects.
- `MokiRuby.tenant_managed_apps` asks for all apps associaited with this
  tenant. This will return an array of `TenantManagedApp` objects.

### Device Methods

First, create a device through one of the following approaches:

```
MokiRuby::Device.new(serial_number)
MokiRuby::Device.new(udid)
```

Using this device, there are several methods available:

- `device.profiles` returns all profiles currently installed on a
  device. This will return an array of `IOSProfile` objects.
- `device.managed_apps` returns all managed applications installed on a
  device. This will return an array of `DeviceManagedApp` objects.
- `device.install_app(app)` takes in a `TenantManagedApp` object, and
  will install the given application on the device. Returns an
  `Action` object, for tracking in the future.
- `device.add_profile(profile)` takes in an `IOSProfile` object, and
  will install the given profile on the device. Returns an `Action`
  object, for tracking in the future.
- `device.remove_profile(profile)` take in an `IOSProfile` object, and
  will remove the given profile from the device. Returns an `Action`
  object, for tracking in the future.
- `device.get_action(action_id)` will take in an `id` from an `Action`
  object, and return an updated `Action` object.

## Contributing

1. Fork it ( https://github.com/bellycard/moki_ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

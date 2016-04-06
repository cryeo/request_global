# RequestGlobal [![Gem Version](https://badge.fury.io/rb/request_global.svg)](https://badge.fury.io/rb/request_global) [![Code Climate](https://codeclimate.com/github/cryeo/request_global/badges/gpa.svg)](https://codeclimate.com/github/cryeo/request_global) [![Build Status](https://travis-ci.org/cryeo/request_global.svg?branch=master)](https://travis-ci.org/cryeo/request_global)
RequestGlobal provides global storage per request for Rails. The core part of RequestGlobal is written in Ruby's C API.

## Installation
Add this line to your Gemfile:

```ruby
gem 'request_global'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install request_global

## Usage
Each storage of request is a Hash.
```ruby
# Setter methods
RequestGlobal.store(:foo, 1) #=> 1
RequestGlobal[:bar] = 2 #=> 2

# Getter methods
RequestGlobal.fetch(:bar) #=> 2
RequestGlobal[:foo] #=> 1

# Delete
RequestGlobal.delete(:bar)

# Clear storage of current request
RequestGlobal.clear!
```

### No Rails?
RequestGlobal provides Railtie which configures Rack middleware. However, if you're not using Rails, use middleware yourself like following:

```ruby
use RequestGlobal::Middleware
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cryeo/request_global.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

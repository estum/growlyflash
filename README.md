# Growlyflash

Tiny gem which provides growl-styled flash messages for Ruby on Rails with Bootstrap.

For XHR requests flash messages are transfering in 'X-Messages' headers, otherwise they are storing in js variables.

Based on [Bootstrap Growl](https://github.com/ifightcrime/bootstrap-growl) and little bit on [Bootstrap Flash Messages](https://github.com/RobinBrouwer/bootstrap_flash_messages)

## Installation

Add this line to your application's Gemfile:

    gem 'growlyflash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install growlyflash

Also you need to put this line inside `head` tag in your layout, before any different javascripts:

    <%= growlyflash_static_notices %>

And require it in your javascript:

	//= require growlyflash/growlyflash

See [Bootstrap Growl](https://github.com/ifightcrime/bootstrap-growl) for any customisations.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

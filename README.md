# CanCanCanSee

Read-only access to roles and abilities with CanCancan. Note: Since this relies on regex-magic at the moment, it requires a particular formatting that will be further articulated upon in future docs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'CanCanCanSee'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install CanCanCanSee

## Usage

Your `Ability.rb` file should use a `case/when` statement for different roles and abilities for this to work.

Create a `config/initializers/cancancansee.rb` file, and if you have a normal Ability.rb file include:

`abilities_type = "single"`

And if you have a custom multiple Ability.rb setup include:

`abilities_type = "multiple"`

Then, anywhere in your code or CLI, you have access to this command:

```ruby
CanCanCanSee.all_abilities

#=> {"RoleOne"=>{"can"=>["manage Object"], "cannot"=>["delete Note", "edit Thing"},
#=> "RoleTwo"=>{"can"=>["edit User"], "cannot"=>["manage Telephone"]}}

#and if you only want to see abilities for a particular slug under multiple....
CanCanCanSee.all_abilities[my_slug]

#=> {"my_slug"=>{"RoleOne"=>{"can"=>["manage Object"], "cannot"=>["delete Note", "edit Thing"},
#=> "RoleTwo"=>{"can"=>["edit User"], "cannot"=>["manage Telephone"]}},
#=> "my_other_slug"=>{"RoleOne"=>{"can"=>["manage Object"], "cannot"=>["delete Note", "edit Thing"},
#=> "RoleTwo"=>{"can"=>["edit User"], "cannot"=>["manage Telephone"]}}
```

## Development

## TODO Before 1.0

* Confirm support for single and multiple Ability.rb files
* Create docs to show style guidelines to have gem work
* Create post to show layout for slug-based auth

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/schwad/CanCanCanSee. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [SCHWAD License](https://github.com/schwad/cancancansee/LICENSE.txt).

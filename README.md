# README

This repository has the following with default values: 

* Ruby 2.6.5

* Rails 6.0.2.1

Remember to create your master key: 

`bundle exec rails credentials:edit`

With security checks:

* [brakeman](https://github.com/presidentbeef/brakeman) (latest 4.7.2)

* [bundler-audit](https://github.com/rubysec/bundler-audit) (latest 0.6.1)

And best practices:

* [rails_best_practices](https://github.com/flyerhzm/rails_best_practices) (latest 1.19.5)

* [rubocop](https://www.github.com/rubocop-hq/rubocop) (latest 0.78.0)

To use the tools:

[brakeman](https://github.com/presidentbeef/brakeman)

A static analysis security vulnerability scanner for Ruby on Rails applications.

`bundle exec brakeman`

[bundler-audit](https://github.com/rubysec/bundler-audit)

Patch-level verification for bundler.

`bundle exec bundle-audit check --update`

[rails_best_practices](https://github.com/flyerhzm/rails_best_practices)

a code metric tool for rails projects.

`bundle exec rails_best_practices`

[rubocop](https://www.github.com/rubocop-hq/rubocop)

A Ruby static code analyzer and formatter, based on the community Ruby style guide.

`bundle exec rubocop`

For further configurations, go check the respective repository.

# Breakpoint

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

After setting up, you can run the application using [foreman]:

    % foreman start

If you don't have `foreman`, see [Foreman's install instructions][foreman]. It
is [purposefully excluded from the project's `Gemfile`][exclude].

[foreman]: https://github.com/ddollar/foreman
[exclude]: https://github.com/ddollar/foreman/pull/437#issuecomment-41110407

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production


# Welcome to Breakpoint App

Breakpoint App is a free tennis league scheduling web application

## Application details

* based on Ruby on Rails
* distributed under the MIT License

## Requirements

* Ubuntu/Debian (not tested on Windows)
* ruby 2.1.0+ (not tested on 1.9.3+)
* PostgreSQL

## Install

1. Bundle install
* cp config/database.yml.example config/database.yml
* createuser -s -r breakpoint_app
* rake db:setup breakpointapp:reset_passwords breakpointapp:user_info
* Note: the reset_passwords task will set the sample user passwords to 'password' and the user_info task will output a list of valid email addresses to the console
* rails s
* login using a valid email address and password

## Contacts

Twitter:

 * @breakpointapp
 * @davekaro

Email

 * admin@breakpointapp.com

## Contributing

[![Build Status](https://travis-ci.org/davekaro/breakpoint-app.png?branch=master)](https://travis-ci.org/davekaro/breakpoint-app)
[![Code Climate](https://codeclimate.com/github/davekaro/breakpoint-app.png)](https://codeclimate.com/github/davekaro/breakpoint-app)


[![Build Status](https://travis-ci.org/bspatafora/time_off.svg?branch=master)](https://travis-ci.org/bspatafora/time_off)

# Time Off

## Requirements
  * PostgreSQL

## Setup
  1.  Set shell variables
    * `TIME_OFF_CLIENT_ID`
    * `TIME_OFF_CLIENT_SECRET`
    * `TIME_OFF_SECRET_DEVELOPMENT`
    * `TIME_OFF_SECRET_TEST`
  2. `bundle install`
  3. `rake db:create`
  4. `rake db:migrate`

## Running the tests
  * `rspec`

## Running the app
  * `rails s`


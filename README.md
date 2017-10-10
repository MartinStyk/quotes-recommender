# Quotes Recommender
Project for course PV254 Recommender Systems. Web application for recommending quotes

Web based recommender application which recommends quotes.


The aim of this project is to implement recommendation algorithms. Database of 9300 quotes was obtained from https://www.brainyquote.com. 
Web app is implemented in Ruby on Rails.

### Environment preparation

In order to set up your environment please follow the instructions provided [here](https://github.com/municz/study-materials/wiki/Environment-preparation-%28cs%29). It contains these main steps:

* Install required dependencies
* (Optionally) Install rbenv
* Install ruby ([official documentation](https://www.ruby-lang.org/en/documentation/installation/))
* Install `rails` and `bundler` (or other useful gems)

### Development

* `cd` to the root directory of the project
* Run `bundle install` to install missing gems
* Run `rails db:migrate` to initialize the database schema
* Run `rails db:seed` to insert data into the database
* Run `rails server` >> <http://localhost:3000/>

### Setup

To initialize an _admin_ user in the system, run the following:

* `cd` to the root directory of the project
* Run `rails console` to start console for rails
* Create a user and add an admin role:

```ruby
> user = User.new
> user.email = 'admin@admin.admin'
> user.password = 'adminadmin'
> user.add_role :admin
> user.save
# Because _user_ default role is assigned after create
> user.remove_role :user
```
* You are done. (You can leave the `console` by pressing `Ctrl^D`)

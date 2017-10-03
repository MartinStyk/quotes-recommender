# Quotes Recommender
Project for course PV254 Recommender Systems. Web application for recommending quotes

Web based recommender application which recommends quotes.


The aim of this project is to implement recommendation algorithms. Database of 1800 quotes was obtained from http://forismatic.com. 
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
* Run `rails db:migrate` to initialize the database
* Run `rails server` >> <http://localhost:3000/>

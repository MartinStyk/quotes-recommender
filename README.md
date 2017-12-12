# Quotes Recommender
Project for course PV254 Recommender Systems. Web application for recommending quotes

The aim of this project is to implement recommendation algorithms. Database of quotes was obtained from https://www.brainyquote.com. 
Web app is implemented in Ruby on Rails.

## Contributors
* [Vojtech Hlavka](https://github.com/vojtechhlavka) 
  * Data analysis
  * Data filtering
  * Evaluation
  * Charts and graphs
* [David Luptak](https://github.com/DavidLuptak) 
  * Implementation of web app
    * Complete web app skeleton
    * Deployment on public domain
    * User interface
    * Authentication
  * Implementation of recommendation algorithms
  * Final presentation
* [Martin Styk](https://github.com/MartinStyk) 
  * Download of quotes database by scraping website www.brainyquote.com
  * Implementation of recommendation algorithms
  * Implementation of web app
    * Integration of recommendation algorithms 
  * Final presentation

## Project structure
Project has well known Ruby on Rails app structure.

#### Controllers
Controllers which handle HTTP requests are located inside [app/controllers](./app/controllers) directory.

Controllers important for recommendations
* [ratings_controller](./app/controllers/ratings_controller.rb) - method ``update`` is triggered when user enters a rating for a quote.  It handles insert of new rating or change of existing rating. ``update``  method triggers methods ``adjust_user_category_preference, adjust_user_quote_length_preference, adjust_user_word_length_preference``. These methods update user's profile everytime user rates a quote. This is the place where user's profile is built.

* [home_controller](./app/controllers/home_controller.rb) - method ``index`` is triggered everytime when user wants to see a new quote. It parses request params and triggers quote selection algorithms on line [12](./app/controllers/home_controller.rb#L12). Category parameter is only used on first random quote selection. For all other quotes line [12](./app/controllers/home_controller.rb#L12) is executed.


#### Interactors
Interactors which are important for recommendations, located in [app/interactors](./app/interactors) directory.

* [initialize_quote](./app/interactors/initialize_quote.rb) - this interactor is triggered from home_controller. It delegates recommendation work to [recommend_quote](./app/interactors/recommend_quote.rb) interactor.

* [recommend_quote](./app/interactors/recommend_quote.rb) - chooses the recommendation algorithm based on user which invoked the method.

#### Services
Recommendation logic is implemented in service classes located in [app/services](./app/services) directory.
This is a list of all recommender services, you can find additional comments directly in source code classes.

* [recommender_service](./app/services/recommender_service.rb) - super class of all recommender service classes. It defines method ``show_next`` which is called by class clients. Method ``choose_next_quote`` is meant to be overriden by subclasses and returns the quote which should be shown.

* [anonymous_recommender_service](./app/services/anonymous_recommender_service.rb) - service is used when user is not logged in. We don't know user's profile, so random quote is returned and entry about user activity on site is not saved.

* [random_recommender_service](./app/services/random_recommender_service.rb) -  Method ``choose_next_quote`` returns random quote.

* [score_board_recommender_service](./app/services/score_board_recommender_service.rb) - base class for all advanced recommenders - ``global_popularity_recommender_service`` and classes based on its child ``learning_score_board_recommender_service``, which compute score board (quote -> score - suitability for user). It overrides `choose_next_quote` method of ``recommender_service``. Inside this method, abstract method ``compute_score_board`` is triggered. This method is meant to be overriden by subclasses. It should return result - scoreboard of quotes ordered and normalized. Top results are then shuffled in method ``score_board_recommender_service#choose_next_quote``. Please see comments directly in the [score_board_recommender_service](./app/services/score_board_recommender_service.rb) class.

* [global_popularity_recommender_service](./app/services/global_popularity_recommender_service.rb) - extends ``score_board_recommender_service`` and overrides method ``compute_score_board`` to compute score of quotes based on their global popularity.

* [learning_score_board_recommender_service](./app/services/learning_score_board_recommender_service.rb) - slightly changes behaviour of ``score_board_recommender_service`` - if user has seen less then 5 quotes, it returns random quote. All other logic is delegated to it's predecessor ``score_board_recommender_service``. This is parent class for ``content_based_category_recommender_service, content_based_quote_analysis_recommender_service, content_based_mixed_recommender_service``.

* [content_based_category_recommender_service](./app/services/content_based_category_recommender_service.rb) - computes scoreboard of quotes based on user's profile for categories. See comments in the source file.

* [content_based_quote_analysis_recommender_service](./app/services/content_based_quote_analysis_recommender_service.rb
) - computes scoreboard of quotes based on user's profile for text style. See comments in the source file.

* [content_based_mixed_recommender_service](./app/services/content_based_mixed_recommender_service.rb) - combines ``content_based_category_recommender_service`` and  ``content_based_quote_analysis_recommender_service``. It merges scoreboards computed by these services. Category has priority with 80% in final score, while text style has only 20%.

#### List of other important files

* Database schema - [db/schema.rb](./db/schema.rb)

* Script for quotes download - [scripts/quotes_finder.rb](./scripts/quotes_finder.rb)

* Quotes data (original and filtered) - [data](./data) directory

## Execution & development

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

#### Admin

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

#### Google authentication

Exporting the following environment variables is needed to use Google authentication
```
GOOGLE_CLIENT_ID = <your client ID>
GOOGLE_CLIENT_SECRET = <your client secret>.
```

#### Facebook authentication

Exporting the following environment variables is needed to use Facebook authentication
```
APP_ID = <your application ID>
APP_SECRET <your application secret>
```

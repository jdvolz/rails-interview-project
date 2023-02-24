# Kaleo Rails Engineer Candidate Interview Project

Thanks for taking the time to complete this exercise. We're excited that you're considering joining our amazing team.

This Rails application is a basic skeleton of an app that serves an API about questions and answers. It already includes 4 basic models:

1.  Question
2.  Answer
3.  User
4.  Tenant

A Question can have one or more answers, and can be private. Every Answer belongs to one question. Each Question has an asker (User), and each Answer has a provider (User).

A Tenant is a consumer of the API you are going to write. A db/seeds.rb file is included to preload the database with test data when you setup the DB.

## You need to accomplish the following tasks:

*   Add a RESTful, read-only API to allow consumers to retrieve Questions with Answers as JSON (no need to retrieve Answers on their own). The response should include Answers inside their Question as well as include the id and name of the Question and Answer users.
*   Don't return private Questions in the API response.
*   Require every API request to include a valid Tenant API key, and return an HTTP code of your choice if the request does not include a valid key.
*   Track API request counts per Tenant.
*   Add an HTML dashboard page as the root URL that shows the total number of Users, Questions, and Answers in the system, as well as Tenant API request counts for all Tenants.  Style it enough to not assault a viewer's sensibilities.
*   Add tests around the code you write as you deem appropriate. Assume that the API cannot be changed once it's released and test accordingly.
*   You are welcome to add any models or other code you think you need, as well as any gems.

## Extra credit features you might consider:

*   Allow adding a query parameter to the API request to select only Questions that contain the query term(s).  Return an appropriate HTML status code if no results are found.
*   Add a piece of middleware to throttle API requests on a per-Tenant basis. After the first 100 requests per day, throttle to 1 request per 10 seconds.

## Project Setup

Clone this repo locally, and from the top-level directory run:

`bundle install`

`bundle exec rake db:setup`

To make sure it's all working,

`rails s`

You should see this same information.

## Notes on setup for modern computers, specifically Ubuntun linux 22.04
- You need to be able to install the correct version of bundler like so:

`gem install bundler -v=1.17.3`

- You need the correct version of the libssl1.0-dev library
Discussion found here:  https://stackoverflow.com/questions/57946621/error-running-requirements-debian-libs-install-libssl-dev

`
sudo nano /etc/apt/sources.list
add deb http://security.ubuntu.com/ubuntu bionic-security main
sudo apt update && apt-cache policy libssl1.0-dev
sudo apt-get install libssl1.0-dev
`

- You need the correct version of ruby

`rvm install 2.2.3`

- Update sqlite3 to 1.3.10 (the default 1.3.6 won't work w/ ruby 2.2.3)
Change the Gemfile line to appear as

` gem 'sqlite3', '1.3.10' `

- You need to run bundler correctly

` bundle _1.17.3_ install

- After that you should be able to make the db

` rake db:setup `

- And finally run your tests

` rake test `

- If you already had a version of this setup, then you will need to run migrations because I added a column to tenant to count the API requests

` rake db:migrate `

## Submitting your project

Create a pull request and put that on the repository you 

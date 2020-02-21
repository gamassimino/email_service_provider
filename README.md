# README

Email Service Provider it's part of challenge for Spark Digital to apply in a Software Engineer position as Sr Ruby.

The goal of this project is create a REST API that allow you switch between two different email service provider, Sendgrid & Mailgun in this case, for avoid lost emails when some service it's not working

For this, the API was written using Ruby on Rails because it's an agile framework that allow you creare app in a quickly way, and after 5.1 version, you can create an API project just using `--api` flag, wich result in a new Rails project wich already is config to work as an API

Things you may want to cover:

* Ruby version `2.6.3`

* Rails version `6.0.2`


### getting started
```sh
$ rvm use ruby-2.6.3@email_service_provider --create
$ bundle install
```

### set your email service provider
* development


```sh
$ touch config/local_env.yml
$ nano config/local_env.yml
```
and then paste the following code, using your credentials

```yml
EMAIL_SERVICE: 'SendgridSender'
# EMAIL_SERVICE: 'MailgunSender'
MG_API_KEY: 'your mailgin api key'
MG_DOMAIN: 'your mailgun base url'
SG_API_KEY: 'your sendgrid api key'

```

or

```yml
# EMAIL_SERVICE: 'SendgridSender'
EMAIL_SERVICE: 'MailgunSender'
MG_API_KEY: 'your mailgin api key'
MG_DOMAIN: 'your mailgun base url'
SG_API_KEY: 'your sendgrid api key'

```

depending wich service you want to use
Note: if you select mailgun and you have a free plan, you have to add and verified your recipient email addres from Mailgun Dashboard before try


* production


if you are using Heroku for example, yo have to change the `EMAIL_SERVICE` value
Settings > Reveal Config Vars > edit EMAIL_SERVICE

### run rails server
```sh
$ bin/rails s
```

### user curl for make post request
```sh
$ curl -d '{"to": "youremail@yourdomain.com", "to_name": "Mr. Fake","from": "noreply@mybrightwheel.com","from_name": "Brightwheel","subject": "A Message from Brighwheet","body": "<h1>Your Bill</h><p>$10</p>"}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/v1/email
```

### run test suite
```sh
$ bundle exec rspec spec/requests/email_sender.rb
```




### Tradeoffs

* The endpoint is `/api/v1/email` because both controller and route are scoped by Api::V1 because I considered it's a good practice magane everything with scope, in the future will allow you change between different API version just changing the version that are you specifing in the route and also it's clear and transparent for the client wich version of API is using.

* Instead of remove the HTML tags in the email body, I used the correct format when I sent it so then it'll parsed and rendered with the correct style
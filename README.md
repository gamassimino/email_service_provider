# README

Email Service Provider it's part of challenge for Spark Digital to apply in a Software Engineer position as Sr Ruby.

The goal of this project is create a REST API that allow you switch between two different email service provider, Sendgrid & Mailgun in this case, for avoid lost emails when some service it's not working

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
open `local_env.yml` and choose one of service provider comenting the other
you'll looking for `EMAIL_SERVICE` variable

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




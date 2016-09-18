# 点検

Simple Website checker. A typical Ruby on Rails application.

Websites are checked with HTTP `HEAD` requests every minute. If response HTTP status code is `200` then check considered
successful. Any other result treated as failed. After 3, 5, 10, 50, 100, 500 minutes of continuous failures email
notifications are being sent to the email address specified for that site. If check is passing after failures distinct
is being sent.

Under hood a `sidekiq-cron` library handles scheduling of checks. This allows to scale Tenken to many servers without
chance that checks for the same site will be started simultaneously.


## Launch

### Prerequisites

Create a file named `.env` in root of current directory with key-value pairs of next environment variables:

 - `Settings.smtp.password` - password to SMTP server to send email notifications
 - `REDIS_URL` - URL to your Redis (optional)
 - `DATABASE_URL` - URL to connect to your database (optional, if not using `config/database.yml`)


### Via Docker

You will need to have installed:

 - Recent Docker
 - Recent Docker Compose

Then just execute next command from this directory (don't forget to `cd`!):

    docker-compose up

To setup DB execute in second terminal (this should be done only once):

    docker-compose run web rails db:setup

Access Tenken on URL like this: http://localhost:3000/


### Manually

You will need to have installed:

 - Recent MRI Ruby version (2.3 and up)
 - Recent PostgreSQL
 - Recent Redis

Follow these simple steps:

 1. Create user and database

 2. Copy `config/database.yml.sample` to `config/database.yml` and adjust for your setup

 3. Install required gems by executing `bundle install` in this directory.

 4. Execute next command to setup the database:

        rails db:setup

 5. Launch web service with command like:

        bundle exec rails server

 6. Launch background job processing with command like:

        bundle exec sidekiq -q default -q mailers

 7. Access API endpoint on URL like this: http://localhost:4567/?latitude=55.923175&longitude=37.858515

 8. …

 9. PROFIT!


## About name

_Tenken_ in Japanese means _inspection, examination, checking_, see [article in WWWJDIC](http://www.edrdg.org/jmdictdb/cgi-bin/entr.py?svc=jmdict&sid=&q=1441540).


## Found a mistake? Have a question?

Search for an (or open new) issue here: https://github.com/Envek/tenken/issues or send a pull request!


## Contributing

 1. Fork it (<https://github.com/Envek/tenken/fork>)
 2. Create your feature branch (`git checkout -b my-new-feature`)
 3. Make your changes
 4. Write tests for them, make sure that `rake test` passes
 5. Commit your changes (`git commit -am 'Add some feature'`)
 6. Push to the branch (`git push origin my-new-feature`)
 7. Create a new Pull Request


## Boring legal stuff

> Copyright © 2016 Andrey Novikov
>
> MIT License
>
> Permission is hereby granted, free of charge, to any person obtaining
> a copy of this software and associated documentation files (the
> "Software"), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, sublicense, and/or sell copies of the Software, and to
> permit persons to whom the Software is furnished to do so, subject to
> the following conditions:
>
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
> LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
> OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
> WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

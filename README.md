# olubalance

Dependencies
------

If you'd like to build olubalance on your own system, the following dependencies are required:

* Ruby 2.5.0
* Rails 5.1.4
* PostgreSQL 9.5
* ImageMagick
* Your own Amazon S3 Storage Credentials (or change the config to use local storage)

Once dependencies have been met:

1. Create Postgres User, set a password
2. Run the command `bundle install`
3. Save the file `application.yml.sample` to `application.yml`
4. Set the configuration values in `application.yml`
5. Run `rake db:create`
6. Run `rake db:migrate`
7. Run `rake db:seed`
8. Boot up your rails server (`rails s`), and browse to `localhost:3000` in a web browser!

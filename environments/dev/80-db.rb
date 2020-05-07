#we need to create the user manually in RDS, and run `npm run seed` on a new database
default['db']['name'] = 'app'
default['db']['username'] = 'app'
default['db']['password'] = 'app-in-dev'


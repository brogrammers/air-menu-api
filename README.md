# AirMenu API

[![Build Status](http://ci.air-menu.com/buildStatus/icon?job=Air-Menu-Api - master)](http://ci.air-menu.com/job/Air-Menu-Api%20-%20master/)

This is a 4th Year Project in DCU (Dublin City University). This is an API for a restaurant service written in Ruby on Rails.
More information about the actual project/products and its features can be found here: https://blog.air-menu.com

## Running the server locally

It's very easy to set the server up to run locally on your machine.

### Requirements / Dependencies

- Ruby (RVM) (ruby-1.9.3-p429)
- Bundler (can be installed through RubyGems)

### Setup

Before starting up the server instance open up a terminal session and use these commands in the project root folder.

```
 $ bundle install
 $ rake migrate
 $ rails server
```

VOILA, the server should be running on port 3000 on your local machine.

### Tests

To ensure all the tests are passing you can use either use the rspec command or use the rake task that comes with rspec.
All tests are targeted at testing the controllers only (through HTTP interface) to ensure the permission and the
responses are working properly.

#### Invoke tests

Here to just invoke the tests
```
 $ rspec
```

Here to invoke the rake task
```
 $ rake spec
```

And if a nicer output is desired, why not get nice html formatting?
```
 $ SPEC_OPTS="--format html" rake spec > rspec.html
```

### Deployment

The deployment is handled through Capistrano, which is a ruby gem that deploys application through VCS (like git) to remote
servers through SSH.
The setup is quite nice as there are no real config files, but programmatic procedures to create, what are called, recipes.
So I can remotely setup new databases, nginx virtual hosts, init files, etc.

The most important capistrano task is the deployment task. This will log you into the remote server and deploy the application.
```
 $ cap <environment> deploy
```

#### Environments

- edge
- stage
# Volders Api Challenge

This coding challenge was a great opportunity to check out the MVC web framework [hanami](http://hanamirb.org). This
framework isn't as bloated as rails and has a nice software architecture. It uses repositories as an abstraction layer
for the persistence level, which is nice. Also the validation is abstracted from the entities and is happening on action
level. All components (controller actions, routes, repositories) are easily testable.

The project has the following structure:

```
.
├── apps
│   └── api
│       ├── config/routes.rb    # Route definitions
│       ├── controllers
│       │   ├── contracts
│       │   └── users
│       ├── errors              # Exceptions managed by middleware
│       ├── serializers
│       └── validators
├── config
├── db/migrations               # DB migrations
├── features                    # Cucumber tests
├── lib
│   └── volders_api_challenge
│       ├── entities            # Entities/models contract and user
│       ├── repositories
│       └── utils/token.rb      # Token class
├── middlewares                 # Exception management
└── spec
    ├── integration
    ├── requests
    └── unit
```

I used time for the contract `starts_on` and `ends_on`. Maybe there are contracts possible which are used in one day.
Times are encoded by the standard ISO8601.

The authentication token is secured against timing attacks. The token is base64 encoded and contains the user id and the
user secret. The user id is used to fetch the real user secret. This is compared with `Rack::Utils.secure_compare` and
uses SHA256 to ensure the same length of the compared values.

Controller actions can raise exceptions which will be handled by the middleware. Normaly Hanami uses exception handling
on controller action level. But that means that exception handling would be duplicated, so I like the middleware
approach more.

Rspec is used for unit and integration tests and Cucumber is used for system tests. Some controller actions are tested
in `spec/requests` aswell, to ensure the right behavior. These tests would be obsolete if the user stories would be more
detailed on technical level. I fixed and added some user stories.

I use Sqlite3 because it was easier to setup and no special postgresql features are needed for this coding challenge.

The entities are structured as: A contract belongs to an user and a user has one contract.

```
+-------------+           +--------------+
|             | 1       n |              |
|    User     +-----------+   Contract   |
|             |           |              |
+-------------+           +--------------+
```

A more general approach would be: A contract vendor could be a separate Entity for a n:m association:

```
+-------------+           +--------------+           +-------------+
|             | 1       n |              | n       1 |             |
|    User     +-----------+   Contract   +-----------+   Vendor    |
|             |           |              |           |             |
+-------------+           +--------------+           +-------------+
```


## Setup

Install all dependencies

```
% bundle install
```

Prepare (create and migrate) DB for `development` and `test` environments:

```
% bundle exec hanami db prepare

% HANAMI_ENV=test bundle exec hanami db prepare
```

Run unit and integration tests:

```
% bundle exec rspec
```

Run system tests:

```
% bundle exec cucumber
```

## Improvements

Some improvements are possible:

* Use [hanami-serializer](https://github.com/davydovanton/hanami-serializer) for serializing the entities
* The Serializer in the controller actions could be dependency injected.
* The output of the entities could be wrapped by the entity name e.g. `{user: {}}`.
* Add `created_at` and `updated_at` field for caching purposes.
* Password should be hashed with bcrypt before it is stored in database.
* Extraction of controller actions to service objects to separate the business logic and the HTTP layer.
* Email format validation

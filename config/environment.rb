require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/volders_api_challenge'
require_relative '../apps/api/application'

Hanami.configure do
  mount Api::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/volders_api_challenge_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/volders_api_challenge_development'
    #    adapter :sql, 'mysql://localhost/volders_api_challenge_development'
    #
    adapter :sql, ENV['DATABASE_URL']

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/volders_api_challenge/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    mailer do
      delivery :smtp, address: ENV['SMTP_HOST'], port: ENV['SMTP_PORT']
    end
  end
end

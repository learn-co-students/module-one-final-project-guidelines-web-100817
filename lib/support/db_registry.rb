require_relative "./connection_adapter"

DBRegistry ||= OpenStruct.new(test: ConnectionAdapter.new("db/spotify-test.db"),
  development: ConnectionAdapter.new("db/spotify-development.db"),
  production: ConnectionAdapter.new("db/spotify-production.db")
  )

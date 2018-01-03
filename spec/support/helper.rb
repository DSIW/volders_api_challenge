# Send POST request with JSON
def post_json(uri, json)
  post(uri, JSON.dump(json), {'CONTENT_TYPE' => 'application/json'})
end

# app is required by Rack::Test
def app
  Hanami.app
end

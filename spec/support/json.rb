# Parse a http response as JSON
def json_body
  JSON.parse(response.body, symbolize_names: true)
end

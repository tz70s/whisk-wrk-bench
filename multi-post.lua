
-- Initialize random number generator for each action number.
math.randomseed(os.time())

function pickup_action()
  local action_number = math.random(10) -- hard coded 10 actions
  return 'noop-' .. action_number
end

-- The request function in each request.
request = function ()
  local query_strings = 'blocking=true'
  local url_path = '/api/v1/namespaces/_/actions/' .. pickup_action() .. '?' .. query_strings
  return wrk.format('POST', url_path)
end
  
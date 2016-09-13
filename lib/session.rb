require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  HEADER_NAME = "_rails_lite_app"
  def initialize(req)
    @cookie = JSON.parse(req.cookies[HEADER_NAME] || "{}")
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(HEADER_NAME, @cookie.to_json)
  end
end

require 'json'

class Flash
  HEADER_NAME = "_rails_lite_app_flash"
  def initialize(req)
    @cookie = JSON.parse(req.cookies["_rails_lite_app_flash"] || "{}")
  end

  def [](key)
    @cookie[key.to_s]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_flash(res)
    res.set_cookie("_rails_lite_app_flash", @cookie.to_json)
  end

end

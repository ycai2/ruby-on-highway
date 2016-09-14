require 'json'

class Flash
  HEADER_NAME = "_rails_lite_app_flash"
  def initialize(req)
    @old = {JSON.parse(req.cookies[HEADER_NAME] || "{}")}
    @new = {}
  end

  # def [](key)
  #   @old[key.to_s]
  # end

  def []=(key, val)
    @new[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_flash(res)
    res.set_cookie(HEADER_NAME, @new.merge(@old).to_json)
  end

  def store_flash_now(res)
    res.set_cookie(HEADER_NAME + "_now", @new.to_json)
  end

end

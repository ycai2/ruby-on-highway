require 'json'

class Flash
  OLD_HEADER = "_rails_lite_app_flash_old"
  NEW_HEADER = "_rails_lite_app_flash_new"
  def initialize(req)
    @old = {JSON.parse(req.cookies[OLD_HEADER] || "{}")}
    @new = {}
  end

  def [](key)
    @new[key.to_s]
  end

  def []=(key, val)
    @new[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_flash(res)
    res.set_cookie(OLD_HEADER, @old.to_json)
    res.set_cookie(NEW_HEADER, @new.to_json)
  end

  def store_flash_now(res)
    res.set_cookie(HEADER_NAME + "_now", @new.to_json)
  end

end

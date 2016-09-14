require 'json'

class Flash
  def initialize(req)
    cookie = req.cookies['_rails_lite_app_flash']
    @new = cookie ? JSON.parse(cookie) : {}
    @old = {}
  end

  def [](key)
    @new[key.to_s] || @old[key.to_s]
  end

  def []=(key, value)
    @old[key.to_s] = value
    @new[key.to_s] = value
  end

  def now
    @new
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', value: @old.to_json, path: '/')
  end
end

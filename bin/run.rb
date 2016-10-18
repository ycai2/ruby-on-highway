require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/show_exceptions'
require_relative '../lib/static'
require_relative '../bin/dog'
require_relative '../bin/dogs_controller'
require 'pg'

class ExceptionController < ControllerBase
  def critical
    raise "Error raised! Abort, abort, abort"
  end

  def dreaded_nil
    nil + 1
  end

  def okay
    render_content("Everything worked :)", "text/html")
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/$"), DogsController, :index
  get Regexp.new("^/dogs/new$"), DogsController, :new
  post Regexp.new("^/dogs$"), DogsController, :create
  get Regexp.new("^/raise$"), ExceptionController, :critical
  get Regexp.new("^/nil$"), ExceptionController, :dreaded_nil
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  use Static
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)

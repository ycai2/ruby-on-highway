require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/show_exceptions'
require_relative '../lib/static'

class Dog
  attr_reader :name, :owner

  def self.all
    @dogs ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
  end

  def errors
    @errors ||= []
  end

  def valid?
    unless @owner.present?
      errors << "Owner can't be blank"
      return false
    end

    unless @name.present?
      errors << "Name can't be blank"
      return false
    end
    true
  end

  def save
    return false unless valid?

    Dog.all << self
    true
  end

  def inspect
    { name: name, owner: owner }.inspect
  end
end

class DogsController < ControllerBase
  def create
    @dog = Dog.new(params["dog"])
    if @dog.save
      flash[:notice] = "Saved dog successfully"
      redirect_to "/dogs"
    else
      flash.now[:errors] = @dog.errors
      render :new
    end
  end

  def index
    @dogs = Dog.all
    render :index
  end

  def new
    @dog = Dog.new
    render :new
  end

  def show
    @dog = Dog.find(params[:id])
    render :show
  end
end

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
  get Regexp.new("^/dogs/(?<id>\\d+)$"), DogsController, :show
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

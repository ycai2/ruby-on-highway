require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'byebug'
require_relative './flash'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = req.params.merge(params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise 'Double render error'
    else
      res.status = 302
      res.header['location'] = url
      session.store_session(res)
      flash.store_flash(res)
      @already_built_response = true
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise 'Double render error'
    else
      res['Content-Type'] = content_type
      session.store_session(res)
      flash.store_flash_now(res)
      res.write(content)
      @already_built_response = true
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.name.underscore
    body = File.read("views/#{controller_name}/#{template_name}.html.erb")
    render_content(ERB.new(body).result(binding), 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    send(name)
    unless already_built_response?
      render name
    end
  end
end

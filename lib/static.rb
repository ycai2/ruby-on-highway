class Static
  MIME_TYPE = {
    ".jpg" => 'image/jpeg',
    ".txt" => 'text/plain',
    ".zip" => 'application/zip',
    ".png" => 'image/png'
  }

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path.match(/public\/.*/).to_s
    unless path.empty?
      render_file(path)
    else
      @app.call(env)
    end
  end

  private
  def render_file(path)
    # debugger
    file = File.read(path)
    # handle nil
    extension = File.extname(path)
    ['200', {'Content-type' => MIME_TYPE[extension]}, [file]]
  end
end

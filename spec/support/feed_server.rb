class FeedServer
  attr_writer :response

  def initialize
    Capybara.server = :webrick
    @server = Capybara::Server.new(method(:response)).boot
  end

  def response(_env)
    [200, {}, [@response]]
  end

  def url
    "http://#{@server.host}:#{@server.port}"
  end
end

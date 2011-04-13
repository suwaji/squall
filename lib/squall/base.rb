module Squall
  class Base
    attr_reader :params
    include HTTParty

    def initialize
      self.class.base_uri Squall::config[:base_uri]
      self.class.basic_auth Squall::config[:username], Squall::config[:password]
      self.class.format :json
      self.class.headers 'Content-Type' => 'application/json'
      # debug_output
    end

    def params
      @params ||= Params.new
    end

    def request(request_method, path, options = {})
      @result  = self.class.send(request_method, path, options)
      @success = (200..207).include?(@result.code)
      case @result.code
      when (200..207)
        @result
      when 404
        raise NotFound, @request
      else
        raise RequestError, @request
      end
    end
  end
end
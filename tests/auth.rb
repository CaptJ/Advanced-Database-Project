ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'

class ApplicationTest < Test::Unit::TestCase
    include Rack::Test::Methods

    def app
        Sinatra::Application
    end

    def test_without_lem
        get '/lem/snow'
        assert_equal 'fail', last_response.body
    end

    def test_with_lem
        get '/lem/lem'
        assert_equal 'done', last_response.body
    end
end

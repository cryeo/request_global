$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'request_global'

def storages
  RequestGlobal.class_variable_get('@@storages')
end

def current_request
  RequestGlobal.class_variable_get('@@current_request')
end

def test_request_id
  "test_request_id"
end

class FakeApp
  attr_reader :last_count

  def call(env)
    RequestGlobal.storage[:count] ||= 0
    RequestGlobal.storage[:count] += 1
    @last_count = RequestGlobal.storage[:count]
    raise "fail" if env[:error]
  end
end

require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../app'
disable :run

SimpleApi.environment = :test

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    SimpleApi
  end

  config.before(:each) do
    Contract.destroy_all
    User.destroy_all
  end
end


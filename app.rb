# Start pry console
# ./console

# myapp.rb
require 'sinatra'
require 'sinatra/namespace'
require 'pry'
require 'pry-doc'


namespace '/api' do
  get '/contracts' do
    content_type :json
    return {test: 123}.to_json
  end
end

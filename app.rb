# Start pry console
# ./console

# myapp.rb
require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'
require 'pry'
require 'pry-doc'

configure do
  enable :sessions, :dump_errors
  set :session_secret, "asdfasfd asfda sfd asfd asfda"

  Mongoid.load!("config/mongoid.yml")
end

class Contract
  include Mongoid::Document
  field :vendor, type: String
  field :starts_on, type: DateTime
  field :ends_on, type: DateTime
end

class User
  include Mongoid::Document
  field :full_name, type: String
  field :email, type: String
  field :password, type: String
  field :api_token, type: String

end

namespace '/api' do
  get '/contracts' do
    content_type :json
    Contract.all.to_json
  end
end

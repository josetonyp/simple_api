# Start pry console
# ./console

# myapp.rb
require 'sinatra'
require 'sinatra/base'
require 'sinatra/namespace'
require 'mongoid'
require 'pry'
require 'pry-doc'
require 'securerandom'

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

  before_create :create_api_token

  private

  def create_api_token
    self.api_token = SecureRandom.hex
  end
end

class SimpleApi < Sinatra::Base
  register Sinatra::Namespace

  namespace '/api' do
    get '/contracts' do
      content_type :json
      Contract.all.to_json
    end

    post '/users' do
      content_type :json
      user = User.create(params["user"])
      user.to_json
    end
  end
end

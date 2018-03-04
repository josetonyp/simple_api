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

module ModelHelpers

  def error_messages
    errors.messages.map{|message| [message.first, message.last.to_sentence]}.to_h
  end
end

class Contract
  include Mongoid::Document
  field :vendor, type: String
  field :starts_on, type: DateTime
  field :ends_on, type: DateTime

  include ModelHelpers
end

class User
  include Mongoid::Document
  field :full_name, type: String
  field :email, type: String
  field :password, type: String
  field :api_token, type: String

  before_create :create_api_token

  validates :email, presence: {message: "Email should not be empty", allow_blank: false }
  validates :email, uniqueness: { message: "Email is already taken" }, if: Proc.new{|user| user.email.present?}
  validates :full_name, presence: {message: "Full Name should not be empty", allow_blank: false }
  validates :password, presence: {message: "Password should not be empty", allow_blank: false }

  private

  def create_api_token
    self.api_token = SecureRandom.hex
  end

  include ModelHelpers
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
      user = User.new(params["user"])
      if user.valid? && user.save!
        user.to_json
      else
        halt 422, {errors: user.error_messages }.to_json
      end
    end
  end
end

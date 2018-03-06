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

  belongs_to :user

  validates :vendor, presence: {message: "Vendor should not be empty", allow_blank: false }
  validates :starts_on, presence: {message: "Starts On should not be empty", allow_blank: false }
  validates :ends_on, presence: {message: "Ends On should not be empty", allow_blank: false }
  validate :starts_and_ends_dates

  protected

  def starts_and_ends_dates
    if self.ends_on.present? && self.starts_on.present? && self.ends_on < self.starts_on
      errors.add(:starts_on, "Ends on should be greater than Starts on")
      errors.add(:ends_on, "Ends on should be greater than Starts on")
    end
  end

  include ModelHelpers
end

class User
  include Mongoid::Document
  field :full_name, type: String
  field :email, type: String
  field :password, type: String
  field :api_token, type: String

  has_many :contracts

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
      authenticate!

      content_type :json
      Contract.all.to_json
    end

    get '/contracts/:id' do
      authenticate!

      content_type :json
      begin
        Contract.where(user: @user).find(params["id"]).to_json
      rescue Exception => e
        halt 404, {errors: "Contract not found"}.to_json
      end
    end

    delete '/contracts/:id' do
      authenticate!

      content_type :json
      begin
        Contract.where(user: @user).find(params["id"]).destroy
        {status: :ok}.to_json
      rescue Exception => e
        halt 404, {errors: "Contract not found"}.to_json
      end
    end

    post '/contracts' do
      authenticate!

      content_type :json
      contract = Contract.new(json_params["contract"])
      contract.user = @user

      if contract.valid? && contract.save!
        contract.to_json
      else
        halt 422, {errors: contract.error_messages }.to_json
      end
    end

    post '/users' do
      content_type :json

      user = User.new(json_params["user"])
      if user.valid? && user.save!
        user.to_json
      else
        halt 422, {errors: user.error_messages }.to_json
      end
    end

    def json_params
      JSON.parse(request.body.read)
    end

    def authenticate!
      halt 403 if User.where(api_token: request.env["HTTP_USER_TOKEN"]).none?
      @user = User.where(api_token: request.env["HTTP_USER_TOKEN"]).first
    end

  end
  run!
end

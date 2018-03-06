require 'active_support'
require 'active_support/core_ext'
require 'awesome_print'
require 'httparty'
require 'faker'

class Client
  include HTTParty

  base_uri "young-retreat-51574.herokuapp.com"

  def create_user
    name = Faker::Name.name
    response = self.class.post("/api/users",
      body: {user: {email: Faker::Internet.email(name), full_name: name, password: Faker::Internet.password}}.to_json,
      headers: { 'Content-Type' => 'application/json' })
    JSON.parse(response.body)
  end

  def list_contracts(user_token)
    response = self.class.get("/api/contracts", headers: {"User-Token": user_token})
    JSON.parse(response.body)
  end

  def create_contract(user_token)
    response = self.class.post("/api/contracts",
      body: {contract: {vendor: Faker::Company.name, starts_on: DateTime.now, ends_on: DateTime.now + 1.year}}.to_json,
      headers: { 'Content-Type' => 'application/json',"User-Token": user_token })

    JSON.parse(response.body)
  end

  def show_contract(contract_id, user_token)
    response = self.class.get("/api/contracts/#{contract_id}", headers: { 'Content-Type' => 'application/json',"User-Token": user_token })
    JSON.parse(response.body)
  end

  def delete_contract(contract_id, user_token)
    response = self.class.delete("/api/contracts/#{contract_id}", headers: { 'Content-Type' => 'application/json',"User-Token": user_token })
    JSON.parse(response.body)
  end
end

client = Client.new

ap "Creating an user"
user = client.create_user
user_token = user["api_token"]
ap user

ap "Creating a new Contract"
contract = client.create_contract(user_token)
contract_id = contract["_id"]["$oid"]
ap contract

ap "Listing Contracts"
ap client.list_contracts(user_token)

ap "Showing contract #{contract_id}"
ap client.show_contract(contract_id, user_token)

ap "Deleting contract #{contract_id}"
ap client.delete_contract(contract_id, user_token)

ap "Showing contract #{contract_id}"
ap client.show_contract(contract_id, user_token)

require 'acceptance_helper'

# As ​ a user
# I want to ​ create a contract
# So that ​ I can safely store and retrieve information about it
describe "Contracts Api" do
  let(:contract_attributes) do
    {vendor: Faker::Company.name, starts_on: DateTime.now, ends_on: DateTime.now + 1.year}
  end

  let(:user_attributes) do
    name = Faker::Name.name
    {email: Faker::Internet.email(name), full_name: name, password: Faker::Internet.password}
  end

  let(:user) { User.create(user_attributes) }
  let(:contract_for_user) { Contract.create(contract_attributes.merge(user: user)) }
  let(:contract) do
    name = Faker::Name.name
    random_user = User.create({email: Faker::Internet.email(name), full_name: name, password: Faker::Internet.password})
    Contract.create({vendor: Faker::Company.name, starts_on: DateTime.now, ends_on: DateTime.now + 1.year}.merge(user: random_user))
  end

  before(:each) do
    header "Content-Type", 'application/json'
  end

  context "Create Contract" do
    before(:each) do
      header "User-Token", user.api_token
    end

    it 'redirect on invalid user token' do
      header "User-Token", "!"
      post "/api/contracts", {contract: contract_attributes}.to_json
      expect(last_response.status).to eq(403)
    end

    # Given​ I have an account
    # When​ a request is performed with valid values
    # Then​ a contract should be created
    it "creates a valid contract" do
      expect{
        post "/api/contracts", {contract: contract_attributes}.to_json
      }.to change(Contract, :count).by(1)

      expect(JSON.parse(last_response.body)["vendor"]).to eq(contract_attributes[:vendor])
      expect(last_response.status).to eq(200)
    end

    # Given​ I have an account
    # When​ a request is performed with an empty ​ vendor
    # Then​ a contract should not be created
    # And​ I the response should include the “Vendor should not be empty” message
    it "validates presence of contract's vendor" do
      post "/api/contracts", {contracts: {vendor: ""}}.to_json

      expect(last_response.status).to eq(422)
      expect(JSON.parse(last_response.body)["errors"]["vendor"]).to eq("Vendor should not be empty")
    end

    # Given​ I have an account
    # When​ a request is performed with an empty ​ starts_on
    # Then​ a contract should not be created
    # And​ the response should include the “Starts on should not be empty” message
    it "validates presence of contract's starts_on" do
      post "/api/contracts", {contracts: {starts_on: ""}}.to_json

      expect(last_response.status).to eq(422)
      expect(JSON.parse(last_response.body)["errors"]["starts_on"]).to eq("Starts On should not be empty")
    end

    # Given​ I have an account
    # When​ a request is performed with an empty ​ ends_on
    # Then​ a contract should not be created
    # And​ the response should include the “Ends on should not be empty” message
    it "validates presence of contract's ends_on" do
      post "/api/contracts", {contracts: {ends_on: ""}}.to_json

      expect(last_response.status).to eq(422)
      expect(JSON.parse(last_response.body)["errors"]["ends_on"]).to eq("Ends On should not be empty")
    end

    # Given​ I have an account
    # When​ a request is performed with an ​ ends_on ​ < ​ starts_on
    # Then​ a contract should not be created
    # And​ the response should include the “Ends on should be greater than Starts on” message
    it "validates starts and ends date" do
      post "/api/contracts", {contract: {ends_on: DateTime.now, starts_on: DateTime.now + 1.year}}.to_json

      expect(last_response.status).to eq(422)
      expect(JSON.parse(last_response.body)["errors"]["starts_on"]).to eq("Ends on should be greater than Starts on")
      expect(JSON.parse(last_response.body)["errors"]["ends_on"]).to eq("Ends on should be greater than Starts on")
    end
  end

  # As ​ a user
  # I want to ​ get information about a contract
  # So that ​ I use it
  context "List Contract" do
    before(:each) do
      contract_for_user && contract
      header "User-Token", user.api_token
    end
    # Given​ I have an account
    # When​ a request is performed to a contract that belongs to me
    # Then​ I should see all the contract available fields
    it 'shows a contract to its own user' do
      get "/api/contracts/#{contract_for_user._id}"
      expect(last_response.status).to eq(200)
    end
    # Given​ I have an account
    # When​ a request is performed to a contract that does not belong to me
    # Then​ the contract should not be deleted
    # And​ I should see “Contract not found” error to prevent information leaking
    it 'does not shows a contract to any other user' do
      get "/api/contracts/#{contract._id}"
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)["errors"]).to eq("Contract not found")
    end
  end

  context "Delete Contract" do
    before(:each) do
      contract_for_user && contract
      header "User-Token", user.api_token
    end

    # Given​ I have an account
    # When​ a request is performed to a contract that belongs to me
    # Then​ the contract should be deleted
    it 'deletes a contract that belongs to its own user' do
      delete "/api/contracts/#{contract_for_user._id}"
      expect(last_response.status).to eq(200)
    end

    # Given​ I have an account
    # When​ a request is performed to a contract that does not belong to me
    # Then​ the contract should not be deleted
    # And​ I should see “Contract not found” error to prevent information leaking
    it 'does not deletes a contract from any other user' do
      delete "/api/contracts/#{contract._id}"
      expect(last_response.status).to eq(404)
      expect(JSON.parse(last_response.body)["errors"]).to eq("Contract not found")
    end
  end
end

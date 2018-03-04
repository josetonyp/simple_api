require File.dirname(__FILE__) + '/../acceptance_helper'

# As ​ a user
# I want to ​ create an account on the service
# So that ​ I can start managing my contracts
describe "Users Api", type: :request do

# Given​ I don’t have an account
# When​ perform a request with valid values
# Then​ an account should be created
it "creates a valid user account" do
  expect{
    post "/api/users", {user: {email: "test@test.com", full_name: "Some Contractor", password: "12345678"}}
  }.to change(User, :count).by(1)

  expect(JSON.parse(last_response.body)["email"]).to eq("test@test.com")
  expect(JSON.parse(last_response.body)["api_token"]).not_to be_nil
  expect(last_response.status).to eq(200)
end

# Given​ I don’t have an account
# When​ perform a request with an empty ​ full_name
# Then​ an account should not be created
# And​ the response should include the “Full Name should not be empty” message

# Given​ I don’t have an account
# When​ a request is performed with an empty ​ email
# Then​ an account should not be created
# And​ the response should include the “Email should not be empty” message

# Given​ I don’t have an account
# When​ a request is performed with an empty ​ password
# Then​ an account should not be created
# And​ the response should include the “Password should not be empty” message

# Given​ I don’t have an account
# When​ a request is performed with an existent ​ email
# Then​ an account should not be created
# And​ the response should include the “Email is already taken” message

# Given​ I don’t have an account
# When​ an account is created
# Then​ a user token should be generated
# And​ this token will be used for authentication purposes

end

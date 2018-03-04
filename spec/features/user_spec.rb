require File.dirname(__FILE__) + '/../acceptance_helper'

# As ​ a user
# I want to ​ create an account on the service
# So that ​ I can start managing my contracts
describe "Users Api", type: :request do
  let(:user_attributes) do
    name = Faker::Name.name
    {email: Faker::Internet.email(name), full_name: name, password: Faker::Internet.password}
  end

# Given​ I don’t have an account
# When​ perform a request with valid values
# Then​ an account should be created
it "creates a valid user account" do
  expect{
    post "/api/users", {user: user_attributes}
  }.to change(User, :count).by(1)

  expect(JSON.parse(last_response.body)["email"]).to eq(user_attributes[:email])
  expect(last_response.status).to eq(200)
end

# Given​ I don’t have an account
# When​ perform a request with an empty ​ full_name
# Then​ an account should not be created
# And​ the response should include the “Full Name should not be empty” message
it "validates presence of user's full_name" do
  post "/api/users", {user: {full_name: ""}}

  expect(last_response.status).to eq(422)
  expect(JSON.parse(last_response.body)["errors"]["full_name"]).to eq("Full Name should not be empty")
end

# Given​ I don’t have an account
# When​ a request is performed with an empty ​ email
# Then​ an account should not be created
# And​ the response should include the “Email should not be empty” message
it "validates presence of user's email" do
  post "/api/users", {user: {full_name: "Some Person"}}

  expect(last_response.status).to eq(422)
  expect(JSON.parse(last_response.body)["errors"]["email"]).to eq("Email should not be empty")
end

# Given​ I don’t have an account
# When​ a request is performed with an empty ​ password
# Then​ an account should not be created
# And​ the response should include the “Password should not be empty” message
it "validates presence of user's password" do
  post "/api/users", {user: {email: "test@test.com", password: "", full_name: "Some Person"}}

  expect(last_response.status).to eq(422)
  expect(JSON.parse(last_response.body)["errors"]["password"]).to eq("Password should not be empty")
end

# Given​ I don’t have an account
# When​ a request is performed with an existent ​ email
# Then​ an account should not be created
# And​ the response should include the “Email is already taken” message
it "validates uniqness of user's email" do
  user = User.create!(user_attributes)
  post "/api/users", {user: {email: user.email}}

  expect(last_response.status).to eq(422)
  expect(JSON.parse(last_response.body)["errors"]["email"]).to eq("Email is already taken")
end

# Given​ I don’t have an account
# When​ an account is created
# Then​ a user token should be generated
# And​ this token will be used for authentication purposes
it "creates a valid user account and return a valid user token" do
  expect{
    post "/api/users", {user: user_attributes}
  }.to change(User, :count).by(1)

  expect(JSON.parse(last_response.body)["email"]).to eq(user_attributes[:email])
  expect(JSON.parse(last_response.body)["api_token"]).not_to be_nil
  expect(last_response.status).to eq(200)
end
end

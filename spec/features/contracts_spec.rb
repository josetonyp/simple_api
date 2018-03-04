require 'acceptance_helper'

# As ​ a user
# I want to ​ create a contract
# So that ​ I can safely store and retrieve information about it
describe "Contracts Api" do

  context "Create Contract" do
    # Given​ I have an account
    # When​ a request is performed with valid values
    # Then​ a contract should be created

    # Given​ I have an account
    # When​ a request is performed with an empty ​ vendor
    # Then​ a contract should not be created
    # And​ I the response should include the “Vendor should not be empty” message

    # Given​ I have an account
    # When​ a request is performed with an empty ​ starts_on
    # Then​ a contract should not be created
    # And​ the response should include the “Starts on should not be empty” message

    # Given​ I have an account
    # When​ a request is performed with an empty ​ ends_on
    # Then​ a contract should not be created
    # And​ the response should include the “Ends on should not be empty” message

    # Given​ I have an account
    # When​ a request is performed with an ​ ends_on ​ < ​ starts_on
    # Then​ a contract should not be created
    # And​ the response should include the “Ends on should be greater than Starts on” messageAs ​ a user
  end

  # I want to ​ get information about a contract
  # So that ​ I use it
  context "List Contract" do
    # Given​ I have an account
    # When​ a request is performed to a contract that belongs to me
    # Then​ I should see all the contract available fields

    # Given​ I have an account
    # When​ a request is performed to a contract that does not belong to me
    # Then​ the contract should not be deleted
    # And​ I should see “Contract not found” error to prevent information leaking
  end
end

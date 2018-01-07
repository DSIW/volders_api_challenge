Feature: Manage contracts
  As a user
  I want to create a contract
  So that I can safely store and retrieve information about it

  Scenario: Try creating contract without permission
    Given I don't have an account
    When a contract request is performed with valid values
    Then a contract should not be created
    And the status code should be 401
    And the response should include the "Unauthorized" message

  Scenario: Create valid contract
    Given I have an account
    When a contract request is performed with valid values
    Then a contract should be created

  Scenario: Try creating contract with empty vendor
    Given I have an account
    When a contract request is performed with an empty vendor
    Then a contract should not be created
    And the response should include the "Vendor should not be empty" message

  Scenario: Try creating contract with empty start_on
    Given I have an account
    When a contract request is performed with an empty starts_on
    Then a contract should not be created
    And the response should include the "Starts On should not be empty" message

  Scenario: Try creating contract with empty ends_on
    Given I have an account
    When a contract request is performed with an empty ends_on
    Then a contract should not be created
    And the response should include the "Ends On should not be empty" message

  Scenario: Try creating contract with ends_on < starts_on
    Given I have an account
    When a contract request is performed with an ends_on < starts_on
    Then a contract should not be created
    And the response should include the "Ends on should be greater than Starts on" message

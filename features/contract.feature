Feature: Manage contracts
  As a user
  I want to create a contract
  So that I can safely store and retrieve information about it

  Scenario: Try creating contract without permission
    Given I don't have an account
    When a request is performed with valid values
    Then a contract should not be created
    And the status code should be 401
    And the response should include the "Unauthorized" message

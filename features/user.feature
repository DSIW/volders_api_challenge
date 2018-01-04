Feature: Manage users
  As a user
  I want to create an account on the service
  So that I can start managing my contracts
  User contains the fields full_name, email and password.

  Scenario: Create valid user
    Given I don't have an account
    When perform a request with valid values
    Then an account should be created
    And the status code should be 201

  Scenario: Try creating user with empty full_name
    Given I don't have an account
    When a request is performed with an empty full_name
    Then an account should not be created
    And the response should include the "Full Name should not be empty" message
    And the status code should be 422

  Scenario: Try creating user with empty email
    Given I don't have an account
    When a request is performed with an empty email
    Then an account should not be created
    And the response should include the "Email should not be empty" message

  Scenario: Try creating user with empty password
    Given I don't have an account
    When a request is performed with an empty password
    Then an account should not be created
    And the response should include the "Password should not be empty" message

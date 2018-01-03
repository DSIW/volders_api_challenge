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

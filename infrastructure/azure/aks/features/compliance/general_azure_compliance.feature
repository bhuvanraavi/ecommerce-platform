Feature: Test tagging compliance

Scenario: Ensure all resources have tags
    Given I have resource that supports tags defined
    When its type is not in ["azuread_application", "azuread_service_principal"]
    And it has tags    
    Then it must contain tags
    And its value must not be null

Scenario Outline: Ensure that specific tags are defined
    Given I have resource that supports tags defined    
    When its type is not in ["azuread_application", "azuread_service_principal"]
    And it has tags
    Then it must contain <tags>
    And its value must match the "<value>" regex

    Examples:
      | tags        | value              |
      | Creator     | .+                 |
      | Application | .+                 |
      | Role        | .+                 |
      | Environment | ^(prod\|uat\|dev)$ |
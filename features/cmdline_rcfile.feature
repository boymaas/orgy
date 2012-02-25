Feature: Org-mode loads and writes an rcfile
  org-mode tool should load a rc file on startup
  
Scenario: an rc file exist
    Given date is "1-1-2012 15:00"
    And we have an environment containing:
    | ORG_MODE_RC_DIR   | features/fixtures |
    | ORG_MODE_RC_FNAME | orgmoderc         |
    When the script is called with "agenda"
    Then the output should contain "Agenda"
    And the output should contain "TODO"
    And the output should contain "Scheduled task defined in orgmoderc"

Scenario: no rc file exists
    Given date is "1-1-2012 15:00"
    And we have an environment containing:
    | ORG_MODE_RC_DIR   | features/tmp  |
    | ORG_MODE_RC_FNAME | orgmoderc-non-existent |
    And I have an empty tmp dir 'features/tmp'
    When the script is called with "agenda"
    Then the output should contain "Agenda"
    And the output should not contain "Scheduled task defined in orgmoderc"
    And the output should contain "TODO Configure orgmoderc file in"

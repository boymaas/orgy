Feature: Handles errors gracefully
  Incomplete information or missing non-existing
  files should be reported.

  Scenario: non-existing file
    When the script is called with "/tmp/non-existent.org"
    Then the output should be
    """
    Could not open `/tmp/non-existent.org'
    """

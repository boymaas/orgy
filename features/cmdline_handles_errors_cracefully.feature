Feature: Handles errors gracefully
  Incomplete information or missing non-existing
  files should be reported.

  Scenario: non-existing file
    When the script is called with "agenda /tmp/non-existent.org"
    Then the output should be
    """
    Encountered a little problem: No such file or directory - /tmp/non-existent.org
    """

Feature: agenda
  org-mode tools should extract meaningfull information
  out of the parsed org-mode files and present
  it in a nicely correct format.

  Scenario: should present meaningfull agenda information
    Given we have an org-file with the following content
      """
      * TODO Scheduled task <1-1-2012 Wed 15:15>
      """
    When the script is executed on the org-file
    Then the output should be
      """
      Agenda ()
        2012-01-01
          TODO Scheduled task
      """

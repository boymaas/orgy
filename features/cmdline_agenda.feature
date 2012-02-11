Feature: agenda
  org-mode tools should extract meaningfull information
  out of the parsed org-mode files and present
  it in a nicely correct format.

  Scenario: should present meaningfull agenda information
    Given date is "1-1-2012 15:00"
    And we have an org-file with the following content
      """
      * TODO Scheduled task <1-1-2012 Wed 15:15>
      """
    When the script is executed on the org-file
    When the script is called with "agenda"
    Then the output should contain "Agenda"
    And the output should contain "2012-01-01"
    And the output should contain "15:15"
    And the output should contain "TODO"
    And the output should contain "Scheduled task"

  # @focus
  # Scenario: should limit restults in a day view
  #   Given date is "1-1-2012 15:00"
  #   And we have an org-file with the following content
  #     """
  #     * TODO Todays task <1-1-2012 Wed 15:15>
  #     * TODO Tommorrows task <2-1-2012 Wed 15:15>
  #     """
  #   When the script is called with "agenda today"
  #   Then the output should be
  #     """
  #     Todays activities:
  #       TODO Todays task
  #     """

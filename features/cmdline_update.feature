Feature: org-mode update <orgfile>
  org-mode script should reformat a file correctly
  to a user can easily reformat an org-file in a 
  standarized way. This also enables certain
  filters to be applied.

  Scenario: should present meaningfull agenda information
    Given we have an org-file with the following content
      """
      a header
      * TODO Scheduled task <1-1-2012 Wed 15:15>
      content that will be indented
      multiline that is
      ** TODO Scheduled task <1-1-2012 Wed 15:15-16:15>
      some other content that will be indented
      """
    When the script is called with "update"
    Then the output should be
      """
      a header
      
      * TODO <2012-01-01 Sun 15:15> Scheduled task
        content that will be indented
        multiline that is
      ** TODO <2012-01-01 Sun 15:15-16:15> Scheduled task
         some other content that will be indented
      """

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

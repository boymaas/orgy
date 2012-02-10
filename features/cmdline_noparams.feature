Feature: noparams or reformat
  Whenever the org-mode script is run without params
  it should just display help

  Scenario: script with no params should display help
    When the script is called with "" should fail
    Then the error should be
      """
      invalid command. Use --help for more information
      """


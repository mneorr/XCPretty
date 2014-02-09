Feature: Create a JSON compilation database

	Scenario: Showing file compilation
        Given I have a file to compile
        When I pipe to xcpretty with "--report json-compilation-database" and specify a custom path
        Then the JSON compilation database should contain a corresponding entry

    Scenario: Handling a complete xcodebuild session
    	Given some big input
    	When I pipe to xcpretty with "--report json-compilation-database" and specify a custom path
    	Then the JSON compilation database should be complete

    Scenario: Writing to a custom file path
        When I pipe to xcpretty with "--report json-compilation-database" and specify a custom path
        Then I should have a JSON compilation database in a custom path

    Scenario: Writing to multiple custom file paths
        When I pipe to xcpretty with two custom "json-compilation-database" report paths
        Then I should have JSON compilation databases in two custom paths
module XCPretty

  module Matchers

    # @regex Captured groups
    # $1 file_path
    # $2 file_name
    ANALYZE_MATCHER = /^Analyze(?:Shallow)?\s(.*\/(.*\.m))*/

    # @regex Captured groups
    # $1 target
    # $2 project
    # $3 configuration
    BUILD_TARGET_MATCHER = /^=== BUILD TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s===/

    # @regex Nothing returned here for now
    CHECK_DEPENDENCIES_MATCHER = /^Check dependencies/

    # @regex Captured groups
    # $1 = whole error
    CLANG_ERROR_MATCHER = /^(clang: error:.*)$/

    # @regex Nothing returned here for now
    CLEAN_REMOVE_MATCHER = /^Clean.Remove/

    # @regex Captured groups
    # $1 target
    # $2 project
    # $3 configuration
    CLEAN_TARGET_MATCHER = /^=== CLEAN TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH CONFIGURATION\s(.*)\s===/

    # @regex Captured groups
    # $1 = file
    CODESIGN_MATCHER = /^CodeSign\s((?:\\ |[^ ])*)$/

    # @regex Captured groups
    # $1 = file
    CODESIGN_FRAMEWORK_MATCHER = /^CodeSign\s((?:\\ |[^ ])*.framework)\/Versions/

    # @regex Captured groups
    # $1 = whole error
    CODESIGN_ERROR_MATCHER = /^(Code\s?Sign error:.*)$/

    # @regex Captured groups
    # $1 file_path
    # $2 file_name (e.g. KWNull.m)
    COMPILE_MATCHER = /^CompileC\s.*\s(.*\/(.*\.(?:m|mm|c|cc|cpp|cxx)))\s.*/

    # @regex Captured groups
    # $1 = file_path
    # $2 = file_name
    # $3 = reason
    COMPILE_ERROR_MATCHER = /^(\/.+\/(.*):.*:.*):(?:\sfatal)?\serror:\s(.*)$/

    # @regex Captured groups
    # $1 file_path
    # $2 file_name (e.g. MainMenu.xib)
    COMPILE_XIB_MATCHER = /^CompileXIB\s(.*\/(.*\.xib))/

    # @regex Captured groups
    # $1 file
    COPY_STRINGS_MATCHER = /^CopyStringsFile.*\/(.*.strings)/

    # @regex Captured groups
    # $1 resource
    CPRESOURCE_MATCHER = /^CpResource\s(.*)\s\//

    # @regex Captured groups
    # $1 cursor (with whitespaces and tildes)
    CURSOR_MATCHER = /^([\s~]*\^[\s~]*)$/

    # @regex Captured groups
    #
    EXECUTED_MATCHER = /^\s*Executed/

    # @regex Captured groups
    # $1 = file
    # $2 = test_suite
    # $3 = test_case
    # $4 = reason
    FAILING_TEST_MATCHER = /^\s*(.+:\d+):\serror:\s[\+\-]\[(.*)\s(.*)\]\s:(?:\s'.*'\s\[FAILED\],)?\s(.*)/

    # @regex Captured groups
    # $1 = whole error.
    #      it varies a lot, not sure if it makes sense to catch everything separately
    FATAL_ERROR_MATCHER = /^(fatal error:.*)$/

    # @regex Captured groups
    # $1 = dsym
    GENERATE_DSYM_MATCHER = /^GenerateDSYMFile \/.*\/(.*\.dSYM)/

    # @regex Captured groups
    # $1 = library
    LIBTOOL_MATCHER = /^Libtool.*\/(.*\.a)/

    # @regex Captured groups
    # $1 = whole error
    LD_ERROR_MATCHER = /^(ld:.*not found for.*)/

    # @regex Captured groups
    # $1 reason
    LINKER_FAILURE_MATCHER = /^(Undefined symbols for architecture .*):$/

    # @regex Captured groups
    # $1 = target
    # $2 = build_variants (normal, profile, debug)
    # $3 = architecture
    LINKING_MATCHER = /^Ld \/.*\/(.*) (.*) (.*)$/

    # @regex Captured groups
    # $1 = suite
    # $2 = test_case
    # $3 = time
    PASSING_TEST_MATCHER = /^\s*Test Case\s'-\[(.*)\s(.*)\]'\spassed\s\((\d*\.\d{3})\sseconds\)/

    # @regex Captured groups
    # $1 = suite
    # $2 = test_case
    PENDING_TEST_MATCHER = /^Test Case\s'-\[(.*)\s(.*)PENDING\]'\spassed/

    # @regex Captured groups
    # $1 = script_name
    PHASE_SCRIPT_EXECUTION_MATCHER = /^PhaseScriptExecution\s(.*)\s\//

    # @regex Captured groups
    PODS_ERROR_MATCHER = /^error:\s(.*)/

    # @regex Captured groups
    # $1 = file
    PROCESS_PCH_MATCHER = /^ProcessPCH\s.*\s(.*.pch)/

    # @regex Captured groups
    # $1 = file
    PREPROCESS_MATCHER = /^Preprocess\s(?:(?:\\ |[^ ])*)\s((?:\\ |[^ ])*)$/

    # @regex Captured groups
    # $1 = file
    PBXCP_MATCHER = /^PBXCp\s((?:\\ |[^ ])*)/

    # @regex Captured groups
    # $1 = file
    PROCESS_INFO_PLIST_MATCHER = /^ProcessInfoPlistFile\s.*\.plist\s(.*\/+(.*\.plist))/

    # @regex Captured groups
    # $1 = reference
    SYMBOL_REFERENCED_FROM_MATCHER = /\s+"(.*)", referenced from:$/

    # @regex Captured groups
    # $1 = suite
    # $2 = time
    TESTS_RUN_COMPLETION_MATCHER = /^\s*Test Suite '(?:.*\/)?(.*[ox]ctest.*)' finished at (.*)/

    # @regex Captured groups
    # $1 = suite
    # $2 = time
    TESTS_SUITE_COMPLETION_MATCHER = /^\s*Test Suite '(.*)' finished at (.*)/

    # @regex Captured groups
    # $1 = suite
    # $2 = time
    TESTS_RUN_START_MATCHER = /^\s*Test Suite '(?:.*\/)?(.*[ox]ctest.*)' started at(.*)/

    # @regex Captured groups
    # $1 test suite name
    TESTS_SUITE_START_MATCHER = /^\s*Test Suite '(.*)' started at/

    # @regex Captured groups
    # $1 test case name
    # $2 test suite name
    TESTS_CASE_START_MATCHER = /^\s*Test Case '-\[(.*)\s(.*)\]' started/

    ALL_TESTS_START_MATCHER = /^\s*Test Suite 'All tests' started at/

    ALL_TESTS_COMPLETION_MATCHER = /^\s*Test Suite 'All tests' finished at/

    # @regex Captured groups
    # $1 file_name
    TIFFUTIL_MATCHER = /^TiffUtil\s(.*)/

    # @regex Captured groups
    # $1 file_path
    # $2 file_name
    TOUCH_MATCHER = /^Touch\s(.*\/([\w+\.]+))/
  end

  class Parser

    include Matchers
    attr_reader :formatter

    def initialize(formatter)
      @formatter = formatter
      @test_runs_parsed = {}
      @test_stack = []
    end

    def parse(text)
      update_test_state(text)
      update_error_state(text)
      update_linker_failure_state(text)

      return format_compile_error if should_format_error?
      return format_linker_failure if should_format_linker_failure?

      case text
      when ANALYZE_MATCHER
        formatter.format_analyze($2, $1)
      when BUILD_TARGET_MATCHER
        formatter.format_build_target($1, $2, $3)
      when CLEAN_REMOVE_MATCHER
        formatter.format_clean_remove
      when CLEAN_TARGET_MATCHER
        formatter.format_clean_target($1, $2, $3)
      when COPY_STRINGS_MATCHER
        formatter.format_copy_strings_file($1)
      when CHECK_DEPENDENCIES_MATCHER
        formatter.format_check_dependencies
      when CLANG_ERROR_MATCHER
        formatter.format_error($1)
      when CODESIGN_FRAMEWORK_MATCHER
        formatter.format_codesign($1)
      when CODESIGN_MATCHER
        formatter.format_codesign($1)
      when CODESIGN_ERROR_MATCHER
        formatter.format_error($1)
      when COMPILE_MATCHER
        formatter.format_compile($2, $1)
      when COMPILE_XIB_MATCHER
        formatter.format_compile_xib($2, $1)
      when CPRESOURCE_MATCHER
        formatter.format_cpresource($1)
      when EXECUTED_MATCHER
        format_summary_if_needed(text)
      when FAILING_TEST_MATCHER
        formatter.format_failing_test($2, $3, $4, $1)
      when FATAL_ERROR_MATCHER
        formatter.format_error($1)
      when GENERATE_DSYM_MATCHER
        formatter.format_generate_dsym($1)
      when LD_ERROR_MATCHER
        formatter.format_error($1)
      when LIBTOOL_MATCHER
        formatter.format_libtool($1)
      when LINKING_MATCHER
        formatter.format_linking($1, $2, $3)
      when PENDING_TEST_MATCHER
        formatter.format_pending_test($1, $2)
      when PASSING_TEST_MATCHER
        formatter.format_passing_test($1, $2, $3)
      when PODS_ERROR_MATCHER
        formatter.format_error($1)
      when PROCESS_INFO_PLIST_MATCHER
        formatter.format_process_info_plist(*unescaped($2, $1))
      when PHASE_SCRIPT_EXECUTION_MATCHER
        formatter.format_phase_script_execution(*unescaped($1))
      when PROCESS_PCH_MATCHER
        formatter.format_process_pch($1)
      when PREPROCESS_MATCHER
        formatter.format_preprocess($1)
      when PBXCP_MATCHER
        formatter.format_pbxcp($1)
      when TESTS_RUN_COMPLETION_MATCHER
        formatter.format_test_run_finished($1, $2)
      when TESTS_RUN_START_MATCHER
        formatter.format_test_run_started($1)
      when TESTS_SUITE_START_MATCHER
        formatter.format_test_suite_started($1)
      when TIFFUTIL_MATCHER
        formatter.format_tiffutil($1)
      when TOUCH_MATCHER
        formatter.format_touch($1, $2)
      else
        ""
      end
    end

    def all_tests_complete?
      @test_stack.count == 0
    end

    def all_test_suites_complete?
      @test_suites_parsed.count > 0 &&
        @test_suites_parsed.values.all?{ |is_complete| is_complete }
    end

    def parsed_passing_tests?
      @parsed_passing_tests == true
    end

    def parsed_failing_tests?
      @parsed_failing_tests == true
    end

    def parsed_valid_test_build?
      parsed_passing_tests? && !parsed_failing_tests? && all_tests_complete?
    end

    def current_test
      @test_stack[-1]
    end

    def formatted_test_stack
      @test_stack.join "\n -> "
    end

    private

    def update_test_state(text)
      case text
      when ALL_TESTS_START_MATCHER
        # ignore the "All tests" suite starting
      when ALL_TESTS_COMPLETION_MATCHER
        # ignore the "All tests" suite completing
      when TESTS_RUN_START_MATCHER
        @tests_done = false
        @tests_started = true
        @formatted_summary = false
        @failures = {}
        record_start_of_test_run $1
      when TESTS_SUITE_START_MATCHER
        record_start_of_test_suite $1
      when TESTS_RUN_COMPLETION_MATCHER
        @tests_done = true
        record_end_of_test_run $1
      when TESTS_SUITE_COMPLETION_MATCHER
        record_end_of_test_suite $1
      when FAILING_TEST_MATCHER
        store_failure($1, $2, $3, $4)
        @parsed_failing_tests = true
        record_end_of_test_case $3
      when PASSING_TEST_MATCHER
        @parsed_passing_tests = true
        record_end_of_test_case $2
      when TESTS_CASE_START_MATCHER
        record_start_of_test_case $2
      end
    end

    def record_start_of_test_run(test_run)
      if @test_stack.length > 0
        store_failure("-", @test_stack.last, "-", "Test run #{@test_stack.last} did not complete")
        @test_stack.pop
        @parsed_failing_tests = true
      end
      @test_stack.push test_run
    end

    def record_start_of_test_suite(test_suite)
      if @test_stack.length > 1
        store_failure("-", @test_stack.last, "-", "Test suite #{@test_stack.last} did not complete")
        @test_stack.pop
        @parsed_failing_tests = true
      end

      if @tests_started
        @test_stack.push test_suite
      end
    end

    def record_start_of_test_case(test_case)
      if @test_stack.length > 2
        store_failure("-", @test_stack.last, "-", "Test case #{@test_stack.last} did not complete")
        @test_stack.pop
        @parsed_failing_tests = true
      end
      @test_stack.push test_case
    end

    def record_end_of_test_case(test_case)
      if @test_stack.last == test_case
        @test_stack.pop
      end
    end

    def record_end_of_test_suite(test_suite)
      if @test_stack.last == test_suite
        @test_stack.pop
      end
    end

    def record_end_of_test_run(test_run)
      if @test_stack.last == test_run
        @test_stack.pop
      end
    end

    # @ return Hash { :file_name, :file_path, :reason, :line }
    def update_error_state(text)
      if text =~ COMPILE_ERROR_MATCHER
        @formatting_error = true
        current_error[:reason]    = $3
        current_error[:file_path] = $1
        current_error[:file_name] = $2
      elsif text =~ CURSOR_MATCHER
        @formatting_error = false
        current_error[:cursor]    = $1.chomp
      elsif @formatting_error
        current_error[:line]      = text.chomp
      end
    end

    def update_linker_failure_state(text)
      if text =~ LINKER_FAILURE_MATCHER
        @formatting_linker_error = true
        current_linker_failure[:message] = $1
      elsif text =~ SYMBOL_REFERENCED_FROM_MATCHER
        current_linker_failure[:symbol] = $1
      elsif @formatting_linker_error
        current_linker_failure[:reference] = text.strip
        @formatting_linker_error = false
      end
    end

    # TODO: clean up the mess around all this
    def should_format_error?
      current_error[:reason] && current_error[:cursor] && current_error[:line]
    end

    def should_format_linker_failure?
      current_linker_failure[:message]     &&
      current_linker_failure[:symbol]      &&
      current_linker_failure[:reference]
    end

    def current_error
      @current_error ||= {}
    end

    def current_linker_failure
      @linker_failure ||= {}
    end

    def format_compile_error
      error = current_error.dup
      @current_error = {}
      formatter.format_compile_error(error[:file_name],
                                     error[:file_path],
                                     error[:reason],
                                     error[:line],
                                     error[:cursor])
    end

    def format_linker_failure
      failure = current_linker_failure.dup
      @linker_failure = {}
      formatter.format_linker_failure(failure[:message],
                                      failure[:symbol],
                                      failure[:reference])
    end

    def store_failure(file, test_suite, test_case, reason)
      failures_per_suite[test_suite] ||= []
      failures_per_suite[test_suite] << {
        :file => file,
        :reason => reason,
        :test_case => test_case
      }
    end

    def failures_per_suite
      @failures ||= {}
    end

    def format_summary_if_needed(executed_message)
      return "" unless should_format_summary?

      @formatted_summary = true
      formatter.format_test_summary(executed_message, failures_per_suite)
    end

    def should_format_summary?
      @tests_done && !@formatted_summary
    end

    def unescaped(*escaped_values)
      escaped_values.map { |v| v.gsub('\\', '') }
    end

  end
end

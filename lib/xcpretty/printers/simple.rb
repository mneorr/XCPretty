# encoding: utf-8
require 'shellwords'

module XCPretty
  module Printer

    class Simple

      include Printer

      PASS = "✓"
      FAIL = "✗"
      ASCII_PASS = "."
      ASCII_FAIL = "x"
      COMPLETION = "▸"
      ASCII_COMPLETION = ">"

      def pretty_format(text)
        case text
        when /^ProcessPCH/
          print_pch(text)
        when /^CompileC/
          print_compiling(text)
        when /^Clean.Remove/
          ""
        when /^Check dependencies/
          ""
        when /^=== CLEAN TARGET/
          print_clean_target(text)
        when /^=== BUILD TARGET/
          print_build_target(text)
        when /^PhaseScriptExecution/
          print_run_script(text)
        when /^Libtool/
          print_libtool(text)
        when /^CpResource/
          print_cpresource(text)
        when /^CopyStringsFile/
          print_copy_strings_file(text)
        when /^GenerateDSYMFile/
          print_generating_dsym(text)
        when /^ProcessInfoPlistFile/
          print_processing_info_plist(text)
        when /^Ld/
          print_linking(text)
        when PASSING_TEST_MATCHER
          print_passing_test($1, $2)
        when FAILING_TEST_MATCHER
          print_failing_test($3, $4)
        when TESTS_RUN_START_MATCHER
          print_test_run_start($1)
        when TEST_SUITE_START_MATCHER
          print_suite_start($1)
        when BUILD_WARNINGS_MATCHER
          print_warning($1, $2)
        else
          ""
        end
      end

      def optional_newline
        "\n"
      end

      def print_failing_test(test_case, reason)
        format_test("#{test_case}, #{reason}", false)
      end

      def print_passing_test(test_case, time)
        format_test("#{test_case} (#{time} seconds)")
      end

      def print_linking(text)
        format("Linking", text.shellsplit[1].split('/').last)
      end

      def print_pch(text)
        format("Precompiling", Shellwords.shellsplit(text)[2])
      end

      def print_processing_info_plist(text)
        format("Processing", text.lines.first.shellsplit.last.split('/').last)
      end

      def print_compiling(text)
        format("Compiling", text.shellsplit[2].split('/').last)
      end

      def print_clean_target(text)
        info = project_build_info(text)
        format("Cleaning", "#{info[:project]}/#{info[:target]} [#{info[:configuration]}]")
      end

      def print_build_target(text)
        info = project_build_info(text)
        format("Building", "#{info[:project]}/#{info[:target]} [#{info[:configuration]}]")
      end

      def print_run_script(text)
        format("Running script", "'#{text.lines.first.shellsplit[1..-2].join(' ').gsub('\ ',' ')}'")
      end

      def print_libtool(text)
        format("Building library", text.shellsplit[1].split('/').last)
      end

      def print_cpresource(text)
        format("Copying", text.shellsplit[1])
      end

      def print_copy_strings_file(text)
        format("Copying", text.shellsplit.last.split('/').last)
      end

      def print_generating_dsym(text)
        format("Generating DSYM file")
      end

      def print_test_run_start(name)
        heading("Test Suite", name, "started")  
      end

      def print_suite_start(name)
        heading("", name, "")
      end

      def print_warning(file, warning)
        format("Warning", "#{file} warns you about #{warning}", false)
      end

      def heading(prefix, text, description)
        heading_text = colorize? ? white(text) : text
        [prefix, heading_text, description].join(" ").strip
      end

      def format(command, argument_text="", success=true)
        command_text = colorize? ? white(command) : command
        [status_symbol(success ? :completion : :fail), command_text, argument_text].join(" ").strip
      end

      def format_test(test_case, success=true)
        [status_symbol(success ? :pass : :fail), test_case].join(" ").strip
      end

      def status_symbol(status)
        case status
        when :pass
          green(use_unicode? ? PASS : ASCII_PASS)
        when :fail
          red(use_unicode? ? FAIL : ASCII_FAIL)
        when :completion
          yellow(use_unicode? ? COMPLETION : ASCII_COMPLETION)
        else
          ""
        end
      end
    end
  end
end

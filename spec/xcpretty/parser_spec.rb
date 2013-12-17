require 'xcpretty'
require 'xcpretty/parser'
require 'fixtures/constants'

module XCPretty

  describe Parser do

    before(:each) do
      @formatter = Formatter.new(false, false)
      @parser = Parser.new(@formatter)
    end

    it "parses analyze" do
      @formatter.should receive(:format_analyze).with("CCChip8DisplayView.m", "CocoaChip/CCChip8DisplayView.m")
      @parser.parse(SAMPLE_ANALYZE)
    end

    it "parses analyze shallow" do
      @formatter.should receive(:format_analyze).with("CCChip8DisplayView.m", "CocoaChip/CCChip8DisplayView.m")
      @parser.parse(SAMPLE_ANALYZE_SHALLOW)
    end

    it "parses build target" do
      @formatter.should receive(:format_build_target).with("The Spacer", "Pods", "Debug")
      @parser.parse(SAMPLE_BUILD)
    end

    it "parses clean remove" do
      @formatter.should receive(:format_clean_remove)
      @parser.parse(SAMPLE_CLEAN_REMOVE)
    end

    it "parses clean target" do
      @formatter.should receive(:format_clean_target).with("Pods-ObjectiveSugar", "Pods", "Debug")
      @parser.parse(SAMPLE_CLEAN)
    end

    it "parses clean target withut dash in target name" do
      @formatter.should receive(:format_clean_target).with("Pods", "Pods", "Debug")
      @parser.parse(SAMPLE_ANOTHER_CLEAN)
    end

    it "parses check dependencies" do
      @formatter.should receive(:format_check_dependencies)
      @parser.parse("Check dependencies")
    end

    it "parses compiling categories" do
      @formatter.should receive(:format_compile).with("NSMutableArray+ObjectiveSugar.m", "/Users/musalj/code/OSS/ObjectiveSugar/Classes/NSMutableArray+ObjectiveSugar.m")
      @parser.parse(SAMPLE_COMPILE)
    end

    it "parses compiling classes" do
      @formatter.should receive(:format_compile).with("KWNull.m", "Classes/Core/KWNull.m")
      @parser.parse(SAMPLE_ANOTHER_COMPILE)
    end

    it "parses compiling XIBs" do
      @formatter.should receive(:format_compile_xib).with("MainMenu.xib", "CocoaChip/en.lproj/MainMenu.xib")
      @parser.parse(SAMPLE_COMPILE_XIB)
    end

    it "parses CopyStringsFile" do
      @formatter.should receive(:format_copy_strings_file).with('InfoPlist.strings')
      @parser.parse(SAMPLE_COPYSTRINGS)
    end

    it "parses CpResource" do
      @formatter.should receive(:format_cpresource).with('ObjectiveSugar/Default-568h@2x.png')
      @parser.parse(SAMPLE_CPRESOURCE)
    end

    it "parses GenerateDSYMFile" do
      @formatter.should receive(:format_generate_dsym).with('ObjectiveSugarTests.octest.dSYM')
      @parser.parse(SAMPLE_DSYM)
    end
    
    it "parses info.plist processing" do
      @formatter.should receive(:format_process_info_plist).with('The Spacer-Info.plist')
      @parser.parse(SAMPLE_PROCESS_INFOPLIST)
    end

    it "parses Ld" do
      @formatter.should receive(:format_linking).with('ObjectiveSugar', 'normal', 'i386')
      @parser.parse(SAMPLE_LD)
    end

    it "parses Libtool" do
      @formatter.should receive(:format_libtool).with('libPods-ObjectiveSugarTests-Kiwi.a')
      @parser.parse(SAMPLE_LIBTOOL)
    end
    
    it "parses failing tests" do
      @formatter.should receive(:format_failing_test).with("RACCommandSpec", "enabled_signal_should_send_YES_while_executing_is_YES_and_allowsConcurrentExecution_is_YES", "expected: 1, got: 0", "/Users/musalj/code/OSS/ReactiveCocoa/ReactiveCocoaFramework/ReactiveCocoaTests/RACCommandSpec.m:458")
      @parser.parse(SAMPLE_SPECTA_FAILURE)
    end

    it "parses passing tests" do
      @formatter.should receive(:format_passing_test).with('RACTupleSpec', '_tupleByAddingObject__should_add_a_non_nil_object', '0.001')
      @parser.parse(SAMPLE_OCUNIT_TEST)
    end

    it "parses PhaseScriptExecution" do
      @formatter.should receive(:format_phase_script_execution).with('Check Pods Manifest.lock')
      @parser.parse(SAMPLE_RUN_SCRIPT)
    end

    it "parses process PCH" do
      @formatter.should receive(:format_process_pch).with("Pods-CocoaLumberjack-prefix.pch")
      @parser.parse(SAMPLE_PRECOMPILE)
    end

    it "parses test run finished" do
      @formatter.should receive(:format_test_run_finished).with('ReactiveCocoaTests.octest(Tests)', '2013-12-10 07:03:03 +0000.')
      @parser.parse(SAMPLE_OCUNIT_TEST_RUN_COMPLETION)  
    end

    it "parses test run started" do
      @formatter.should receive(:format_test_run_started).with('ReactiveCocoaTests.octest(Tests)')
      @parser.parse(SAMPLE_OCUNIT_TEST_RUN_BEGINNING)
    end

    it "parses test suite started" do
      @formatter.should receive(:format_test_suite_started).with('RACKVOWrapperSpec')
      @parser.parse(SAMPLE_OCUNIT_SUITE_BEGINNING)
    end


    context "summary" do

      def given_tests_have_started(reporter = SAMPLE_OCUNIT_TEST_RUN_BEGINNING)
        @parser.parse(reporter)  
      end

      def given_tests_are_done(reporter = SAMPLE_OCUNIT_TEST_RUN_COMPLETION)
        @parser.parse(reporter)
      end

      def given_kiwi_tests_are_done
        @parser.parse(SAMPLE_KIWI_TEST_RUN_COMPLETION)
        @parser.parse(SAMPLE_EXECUTED_TESTS)
        @parser.parse(SAMPLE_KIWI_SUITE_COMPLETION)
      end

      it "returns empty string if the suite is not done" do
        @parser.parse(SAMPLE_EXECUTED_TESTS).should == ""
      end

      it "knows when the test suite is done for OCunit / Specta" do
        given_tests_are_done
        @formatter.should receive(:format_test_summary)
        @parser.parse(SAMPLE_EXECUTED_TESTS)
      end

      it "doesn't print executed message twice for Kiwi tests" do
        @formatter.should_receive(:format_test_summary).once
        given_tests_have_started(SAMPLE_KIWI_TEST_RUN_BEGINNING)
        given_kiwi_tests_are_done
      end

      it "knows when the test suite is done for XCtest" do
        @formatter.should_receive(:format_test_summary).once
        2.times {
          given_tests_are_done(SAMPLE_KIWI_TEST_RUN_COMPLETION)
          @parser.parse(SAMPLE_EXECUTED_TESTS)
        }
      end

      it "prints OCunit / XCTest summary twice if tests executed twice" do
        @formatter.should_receive(:format_test_summary).twice
        2.times {
          given_tests_have_started
          given_tests_are_done
          @parser.parse(SAMPLE_EXECUTED_TESTS)
        }
      end

      it "prints Kiwi summary twice if tests executed twice" do
        @formatter.should_receive(:format_test_summary).twice
        2.times {
          given_tests_have_started(SAMPLE_KIWI_TEST_RUN_BEGINNING)
          given_kiwi_tests_are_done
        }
      end

    end

  end
end

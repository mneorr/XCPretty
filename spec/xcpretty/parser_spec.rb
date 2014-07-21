# encoding: utf-8

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

    it "parses code signing" do
      @formatter.should receive(:format_codesign).with("build/Release/CocoaChip.app")
      @parser.parse(SAMPLE_CODESIGN)
    end

    it "parses code signing a framework" do
      @formatter.should receive(:format_codesign).with("build/Release/CocoaChipCore.framework")
      @parser.parse(SAMPLE_CODESIGN_FRAMEWORK)
    end

    it "parses compiling categories" do
      @formatter.should receive(:format_compile).with("NSMutableArray+ObjectiveSugar.m", "/Users/musalj/code/OSS/ObjectiveSugar/Classes/NSMutableArray+ObjectiveSugar.m")
      @parser.parse(SAMPLE_COMPILE)
    end

    it "parses compiling classes" do
      @formatter.should receive(:format_compile).with("KWNull.m", "Classes/Core/KWNull.m")
      @parser.parse(SAMPLE_ANOTHER_COMPILE)
    end

    it "parses compiling Objective-C++ classes" do
      @formatter.should receive(:format_compile).with("KWNull.mm", "Classes/Core/KWNull.mm")
      @parser.parse(SAMPLE_ANOTHER_COMPILE.sub('.m', '.mm'))
    end

    it "parses compiling C and C++ files" do
      for file_extension in ['.c', '.cc', '.cpp', '.cxx'] do
        @formatter.should receive(:format_compile).with("KWNull" + file_extension, "Classes/Core/KWNull" + file_extension)
        @parser.parse(SAMPLE_ANOTHER_COMPILE.sub('.m', file_extension))
      end
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
      @formatter.should receive(:format_process_info_plist).with('The Spacer-Info.plist', 'The Spacer/The Spacer-Info.plist')
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

    it "parses specta failing tests" do
      @formatter.should receive(:format_failing_test).with("SKWelcomeViewControllerSpecSpec",
                                                           "SKWelcomeViewController_When_a_user_opens_the_app_from_a_clean_installation_displays_the_welcome_screen",
                                                           "The step timed out after 2.00 seconds: Failed to find accessibility element with the label \"The asimplest way to make smarter business decisions\"",
                                                           "/Users/vickeryj/Code/ipad-register/KIFTests/Specs/SKWelcomeViewControllerSpec.m:11")
      @parser.parse(SAMPLE_SPECTA_FAILURE)
    end

    it "parses old specta failing tests" do
      @formatter.should receive(:format_failing_test).with("RACCommandSpec",
                                                           "enabled_signal_should_send_YES_while_executing_is_YES_and_allowsConcurrentExecution_is_YES",
                                                           "expected: 1, got: 0",
                                                           "/Users/musalj/code/OSS/ReactiveCocoa/ReactiveCocoaFramework/ReactiveCocoaTests/RACCommandSpec.m:458")
      @parser.parse(SAMPLE_OLD_SPECTA_FAILURE)
    end

    it "parses passing ocunit tests" do
      @formatter.should receive(:format_passing_test).with('RACCommandSpec',
                                                           'enabled_signal_should_send_YES_while_executing_is_YES_and_allowsConcurrentExecution_is_YES',
                                                           '0.001')
      @parser.parse(SAMPLE_OCUNIT_TEST)
    end

    it "parses passing specta tests" do
      @formatter.should receive(:format_passing_test).with('SKWelcomeActivationViewControllerSpecSpec',
                                                           'SKWelcomeActivationViewController_When_a_user_enters_their_details_lets_them_enter_a_valid_manager_code',
                                                           '0.725')
      @parser.parse(SAMPLE_SPECTA_TEST_PASSED)
    end

    it "parses pending tests" do
      @formatter.should receive(:format_pending_test).with('TAPIConversationSpec',
                                                           'TAPIConversation_createConversation_SendsAPOSTRequestToTheConversationsEndpoint')
      @parser.parse(SAMPLE_PENDING_KIWI_TEST)
    end

    it "parses test case starting" do
      @parser.parse(SAMPLE_KIWI_TEST_CASE_STARTING)
      @parser.current_test.should eq 'SKWelcomeViewController_When_a_user_opens_the_app_from_a_clean_installation_displays_the_welcome_screen'
    end

    it "parses test case passing" do
      @parser.parse(SAMPLE_KIWI_TEST_CASE_STARTING)
      @parser.parse(SAMPLE_KIWI_TEST)
      @parser.current_test.should be_nil
    end

    it "parses test case failing" do
      @parser.parse(SAMPLE_KIWI_TEST_CASE_STARTING)
      @parser.parse(SAMPLE_KIWI_FAILURE)
      @parser.current_test.should be_nil
    end

    it "parses PhaseScriptExecution" do
      @formatter.should receive(:format_phase_script_execution).with('Check Pods Manifest.lock')
      @parser.parse(SAMPLE_RUN_SCRIPT)
    end

    it "parses process PCH" do
      @formatter.should receive(:format_process_pch).with("Pods-CocoaLumberjack-prefix.pch")
      @parser.parse(SAMPLE_PRECOMPILE)
    end

    it "parses preprocessing" do
      @formatter.should receive(:format_preprocess).with("CocoaChip/CocoaChip-Info.plist")
      @parser.parse(SAMPLE_PREPROCESS)
    end

    it "parses PBXCp" do
      @formatter.should receive(:format_pbxcp).with("build/Release/CocoaChipCore.framework")
      @parser.parse(SAMPLE_PBXCP)
    end

    it "parses Touch" do
      @formatter.should receive(:format_touch).with(
        '/Users/musalj/Library/Developer/Xcode/DerivedData/Alcatraz-aobuxcinaqyzjugrnxjjhfzgwaou/Build/Products/Debug/AlcatrazTests.octest',
        'AlcatrazTests.octest')
      @parser.parse(SAMPLE_TOUCH)
    end

    it "parses TiffUtil" do
      @formatter.should receive(:format_tiffutil).with('eye_icon.tiff')
      @parser.parse(SAMPLE_TIFFUTIL)
    end

    it "parses undefined symbols" do
      @formatter.should receive(:format_linker_failure).with("Undefined symbols for architecture x86_64",
                                                             '_OBJC_CLASS_$_CABasicAnimation',
                                                             'objc-class-ref in ATZRadialProgressControl.o')

      SAMPLE_UNDEFINED_SYMBOLS.each_line do |line|
        @parser.parse(line)
      end
    end

    it "parses ocunit test run finished" do
      @formatter.should receive(:format_test_run_finished).with('ReactiveCocoaTests.octest(Tests)', '2013-12-10 07:03:03 +0000.')
      @parser.parse(SAMPLE_OCUNIT_TEST_RUN_COMPLETION)
    end

    it "parses specta test run finished" do
      @formatter.should receive(:format_test_run_finished).with('KIFTests.xctest', '2014-02-28 15:44:32 +0000.')
      @parser.parse(SAMPLE_SPECTA_TEST_RUN_COMPLETION)
    end

    it "parses ocunit test run started" do
      @formatter.should receive(:format_test_run_started).with('ReactiveCocoaTests.octest(Tests)')
      @parser.parse(SAMPLE_OCUNIT_TEST_RUN_BEGINNING)
    end

    it "parses specta test run started" do
      @formatter.should receive(:format_test_run_started).with('KIFTests.xctest')
      @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
    end

    it "parses ocunit test suite started" do
      @formatter.should receive(:format_test_suite_started).with('RACKVOWrapperSpec')
      @parser.parse(SAMPLE_OCUNIT_SUITE_BEGINNING)
    end

    it "parses specta test suite started" do
      @formatter.should receive(:format_test_suite_started).with('All tests')
      @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
    end

    it "does not treat a test run start as a test suite start" do
      @formatter.should_not receive(:format_test_suite_started)
      @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
    end

    it "does not treat a test suite start as a test run start" do
      @formatter.should_not receive(:format_test_run_started)
      @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
    end

    context "errors" do

      it "parses clang errors" do
        @formatter.should receive(:format_error).with(SAMPLE_CLANG_ERROR)
        @parser.parse(SAMPLE_CLANG_ERROR)
      end

      it "parses cocoapods errors" do
        @formatter.should receive(:format_error).with("The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.")
        @parser.parse(SAMPLE_PODS_ERROR)
      end

      it "parses compiling errors" do
        @formatter.should receive(:format_compile_error).with(
          "SampleTest.m",
          "/Users/musalj/code/OSS/SampleApp/SampleTest.m:12:59",
          "expected identifier",
          "                [[thread.lastMessage should] equal:thread.];",
          "                                                          ^")
        SAMPLE_COMPILE_ERROR.each_line do |line|
          @parser.parse(line)
        end
      end

      it 'parses fatal compiling errors' do
        @formatter.should receive(:format_compile_error).with(
          'SomeRandomClass.h',
          '/Users/musalj/code/OSS/SampleApp/Pods/Headers/LessCoolPod/SomeRandomClass.h:31:9',
          "'SomeRandomHeader.h' file not found",
          '#import "SomeRandomHeader.h"',
          '        ^'
          # For now, it's probably not worth to provide the import stack
          # It'd require more state, and not sure if it'd be any useful
#%Q(In file included from /Users/musalj/code/OSS/SampleApp/Pods/SuperCoolPod/SuperAwesomeClass.m:12:
#In file included from /Users/musalj/code/OSS/SampleApp/Pods/../LessCoolPod/LessCoolClass.h:9:
#In file included from /Users/musalj/code/OSS/SampleApp/Pods/../LessCoolPod/EvenLessCoolClass.h:10:)
        )
        SAMPLE_FATAL_COMPILE_ERROR.each_line do |line|
          @parser.parse(line)
        end
      end

      it 'parses fatal error: on the beginning of the line for corrupted AST files' do
        @formatter.should receive(:format_error).with(
          "fatal error: malformed or corrupted AST file: 'could not find file '/Users/mpv/dev/project/Crashlytics.framework/Headers/Crashlytics.h' referenced by AST file' note: after modifying system headers, please delete the module cache at '/Users/mpv/Library/Developer/Xcode/DerivedData/ModuleCache/M5WJ0FYE7N06'"
        )
        @parser.parse(SAMPLE_FATAL_HEADER_ERROR)
      end

      it 'parses fatal error: on the beginning of the line for cached PCH' do
        @formatter.should receive(:format_error).with(
          "fatal error: file '/path/to/myproject/Pods/Pods-environment.h' has been modified since the precompiled header '/Users/hiroshi/Library/Developer/Xcode/DerivedData/MyProject-gfmuvpipjscewkdnqacgumhfarrd/Build/Intermediates/PrecompiledHeaders/MyProject-Prefix-dwjpvcnrlaydzmegejmcvrtcfkpf/MyProject-Prefix.pch.pch' was built"
        )
        @parser.parse(SAMPLE_FATAL_COMPILE_PCH_ERROR)
      end



      it "parses compiling errors with tildes" do
        @formatter.should receive(:format_compile_error).with(
          'NSSetTests.m',
          '/Users/musalj/code/OSS/ObjectiveSugar/Example/ObjectiveSugarTests/NSSetTests.m:93:16',
          "no visible @interface for 'NSArray' declares the selector 'shoulds'",
          '            }] shoulds] equal:@[ @"F458 Italia", @"Testarossa" ]];',
          '            ~~ ^~~~~~~')
        SAMPLE_COMPILE_ERROR_WITH_TILDES.each_line do |line|
          @parser.parse(line)
        end
      end

      it "parses code sign error:" do
        @formatter.should receive(:format_error).with(
          'Code Sign error: No code signing identites found: No valid signing identities (i.e. certificate and private key pair) matching the team ID ‚ÄúCAT6HF57NJ‚Äù were found.'
        )
        @parser.parse(SAMPLE_CODESIGN_ERROR)
      end

      it "parses CodeSign error: (no spaces)" do
        @formatter.should receive(:format_error).with(
          "CodeSign error: code signing is required for product type 'Application' in SDK 'iOS 7.0'"
        )
        @parser.parse(SAMPLE_CODESIGN_ERROR_NO_SPACES)
      end

      it "parses ld library errors" do
        @formatter.should receive(:format_error).with(
          SAMPLE_LD_LIBRARY_ERROR
        )
        @parser.parse(SAMPLE_LD_LIBRARY_ERROR)
      end

      it 'parses ld symbols errors' do
        @formatter.should receive(:format_error).with(
          SAMPLE_LD_SYMBOLS_ERROR
        )
        @parser.parse(SAMPLE_LD_SYMBOLS_ERROR)
      end

      it "doesn't print the same error over and over" do
        SAMPLE_COMPILE_ERROR.each_line do |line|
          @parser.parse(line)
        end
        @formatter.should_not receive(:format_compile_error)
        @parser.parse("hohohoooo")
      end

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

      it "knows when the test suite is done for OCunit" do
        given_tests_are_done
        @formatter.should receive(:format_test_summary)
        @parser.parse(SAMPLE_EXECUTED_TESTS)
      end

      it "knows when the test suite is done for Specta" do
        given_tests_are_done
        @formatter.should receive(:format_test_summary)
        @parser.parse(SAMPLE_SPECTA_EXECUTED_TESTS)
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

    context "test running detection" do

      it "detects when a test run completes" do
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_COMPLETION)
        @parser.all_tests_complete?.should be true
      end

      it "detects when a test run does not complete" do
        @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_SUITE_COMPLETION)
        @parser.all_tests_complete?.should be false
      end

      it "detects when a test suite completes" do
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_SUITE_COMPLETION)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_COMPLETION)
        @parser.all_tests_complete?.should be true
      end

      it "detects when a test suite does not complete" do
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_OCUNIT_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_COMPLETION)
        @parser.all_tests_complete?.should be false
      end

      it "detects when a failing test is run" do
        @parser.parse(SAMPLE_SPECTA_FAILURE)
        @parser.parsed_failing_tests?.should be true
      end

      it "detects when a passing test is run" do
        @parser.parse(SAMPLE_OCUNIT_TEST)
        @parser.parsed_passing_tests?.should be true
      end

      it "detects when no passing tests are run" do
        @parser.parse(SAMPLE_SPECTA_FAILURE)
        @parser.parsed_passing_tests?.should be false
      end

      it "detects when no failing tests are run" do
        @parser.parse(SAMPLE_OCUNIT_TEST)
        @parser.parsed_failing_tests?.should be false
      end

      it "detects when a test case does not complete" do
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_OCUNIT_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_CASE_STARTING)
        @parser.parse(SAMPLE_SPECTA_TEST_CASE_STARTING)
        @parser.parsed_failing_tests?.should be true
      end
    end

    context "valid build detection" do

      it "detects that a build is invalid when no tests are run" do
        @parser.parsed_valid_test_build?.should be false
      end

      it "detects that a build is invalid when a test run starts and does not finish" do
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_CASE_STARTING)
        @parser.parse(SAMPLE_SPECTA_SUITE_COMPLETION)
        @parser.parsed_valid_test_build?.should be false
      end

      it "detects that a build is invalid when a test suite starts and does not finish" do
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_PASSED)
        @parser.parsed_valid_test_build?.should be false
      end

      it "detects that a build is valid when a test run starts, finishes and passes tests" do
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_PASSED)
        @parser.parse(SAMPLE_SPECTA_SUITE_COMPLETION)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_COMPLETION)
        @parser.parsed_valid_test_build?.should be true
      end

      it "detects that a build is invalid when a test fails" do
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_CASE_STARTING)
        @parser.parse(SAMPLE_SPECTA_FAILURE)
        @parser.parse(SAMPLE_SPECTA_SUITE_COMPLETION)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_COMPLETION)
        @parser.parsed_valid_test_build?.should be false
      end

      it "detects that a build is valid when multiple test runs start and finish" do
        @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_XCTEST_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_CASE_STARTING)
        @parser.parse(SAMPLE_SPECTA_TEST_PASSED)
        @parser.parse(SAMPLE_XCTEST_SUITE_COMPLETION)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_COMPLETION)
        @parser.parse(SAMPLE_SPECTA_SUITE_COMPLETION)

        @parser.parse(SAMPLE_SPECTA_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_BEGINNING)
        @parser.parse(SAMPLE_XCTEST_SUITE_BEGINNING)
        @parser.parse(SAMPLE_SPECTA_TEST_CASE_STARTING)
        @parser.parse(SAMPLE_SPECTA_TEST_PASSED)
        @parser.parse(SAMPLE_XCTEST_SUITE_COMPLETION)
        @parser.parse(SAMPLE_SPECTA_TEST_RUN_COMPLETION)
        @parser.parse(SAMPLE_SPECTA_SUITE_COMPLETION)

        @parser.parsed_valid_test_build?.should be true
        @parser.parsed_failing_tests?.should be false
      end

    end

  end

end

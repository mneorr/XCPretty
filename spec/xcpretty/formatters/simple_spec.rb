require 'xcpretty/formatters/formatter'
require "xcpretty/formatters/simple"
require "fixtures/constants"

module XCPretty

    describe Simple do

      before(:each) do
        @formatter = Simple.new(false, false)
      end

      it "formats analyzing" do
        @formatter.format_analyze("CCChip8DisplayView.m", 'path/to/file').should ==
        "> Analyzing CCChip8DisplayView.m"
      end

      it "formats build target/project/configuration with target" do
        @formatter.format_build_target("The Spacer", "Pods", "Debug").should ==
        "> Building Pods/The Spacer [Debug]"
      end

      it "formats clean target/project/configuration" do
        @formatter.format_clean_target("Pods-ObjectiveSugar", "Pods", "Debug").should ==
        "> Cleaning Pods/Pods-ObjectiveSugar [Debug]"
      end

      it "formats compiling output" do
        @formatter.format_compile("NSMutableArray+ObjectiveSugar.m", 'path/to/file').should ==
        "> Compiling NSMutableArray+ObjectiveSugar.m"
      end

      it "formats compiling xib output" do
        @formatter.format_compile_xib("MainMenu.xib", 'path/to/file').should ==
        "> Compiling MainMenu.xib"
      end

      it "formats copy resource" do
        @formatter.format_cpresource("ObjectiveSugar/Default-568h@2x.png").should ==
        "> Copying ObjectiveSugar/Default-568h@2x.png"
      end

      it "formats Copy strings file" do
        @formatter.format_copy_strings_file("InfoPlist.strings").should ==
        "> Copying InfoPlist.strings"
      end

      it "formats GenerateDSYMFile" do
        @formatter.format_generate_dsym("ObjectiveSugarTests.octest.dSYM").should ==
        "> Generating 'ObjectiveSugarTests.octest.dSYM'"
      end
      
      it "formats info.plist processing" do
        @formatter.format_process_info_plist("The Spacer-Info.plist").should ==
        "> Processing The Spacer-Info.plist"
      end
      
      it "formats Linking" do
        @formatter.format_linking("ObjectiveSugar", 'normal', 'i386').should ==
        "> Linking ObjectiveSugar"
      end

      it "formats Libtool" do
        @formatter.format_libtool("libPods-ObjectiveSugarTests-Kiwi.a").should ==
        "> Building library libPods-ObjectiveSugarTests-Kiwi.a"
      end

      it "formats failing tests" do
        @formatter.format_failing_test("RACCommandSpec", "enabled_signal_should_send_YES_while_executing_is_YES_and_allowsConcurrentExecution_is_YES", "expected: 1, got: 0", 'path/to/file').should ==
        "x enabled_signal_should_send_YES_while_executing_is_YES_and_allowsConcurrentExecution_is_YES, expected: 1, got: 0"
      end

      it "formats passing tests" do
        @formatter.format_passing_test("RACCommandSpec", "_tupleByAddingObject__should_add_a_non_nil_object", "0.001").should ==
        ". _tupleByAddingObject__should_add_a_non_nil_object (0.001 seconds)"
      end

      it "formats Phase Script Execution" do
        @formatter.format_phase_script_execution("Check Pods Manifest.lock").should ==
        "> Running script 'Check Pods Manifest.lock'"
      end

      it "formats precompiling output" do
        @formatter.format_process_pch("Pods-CocoaLumberjack-prefix.pch").should ==
        "> Precompiling Pods-CocoaLumberjack-prefix.pch"
      end

      it "formats test run start" do
        @formatter.format_test_run_started("ReactiveCocoaTests.octest(Tests)").should ==
        "Test Suite ReactiveCocoaTests.octest(Tests) started"
      end
      
      it "formats tests suite started" do
        @formatter.format_test_suite_started("RACKVOWrapperSpec").should ==
        "RACKVOWrapperSpec"
      end

    end
end

require 'xcpretty/parser/parser'
module XCPretty

# PATH is a generic path matcher. It needs to end wither with / in case of a
# directory match, or a word character in case of a file (or directory without
# a trailing slash).
PATH              = /(?:[\w\/:\-+.@]|\\ |\\&)+[\w\/]/

# Some outputs include unescaped paths (like SwiftC). Unfortunately, PATH won't
# match them, so we're forced to use something like this.
#
# Caution: when using, make sure you end the path if possible with known
# extensions or patterns. For example, a SwiftC command will end in .swift
UNESCAPED_PATH    = /[ \w\/:\-+.@&\\]+[\w\/]/

# WORD is used mostly for configuration options
WORD              = /[\w]+/
FLAG              = /(?:(-\w+)+)/
CLANG             = /^\s{4}(?:#{PATH})\/usr\/bin\/(?:clang|clang\+\+)/
SWIFT             = /^\s{4}(?:#{PATH})\/usr\/bin\/swift/
SWIFTC            = /^\s{4}(?:#{PATH})\/usr\/bin\/swiftc/
SHELL_BUILTIN     = /^\s{4}builtin-/
SHELL_CD          = /^\s{4}cd\s(#{PATH})$/
SHELL_EXPORT      = /^\s{4}export \w+=.*$/
SHELL_SETENV      = /^\s{4}setenv (?:#{WORD}) (?:#{PATH})?[\w\-]+\s(.*)$/
SHELL_SUBSHELL    = /^\s{4}\/bin\/sh -c/
SHELL_MKDIR       = /^\/bin\/mkdir -p/
SHELL_CHMOD       = /^chmod/
SHELL_IBTOOL      = /^\s{4}(?:#{PATH})\/usr\/bin\/ibtool /

chunk "Compiling" do |c|
  c.line /^CompileC (?:#{PATH}\.o) (#{PATH}\.(?:m|mm|c|cc|cpp|cxx)) / do |f, m|
    f.format_compile(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_SETENV
  c.line SHELL_EXPORT
  c.line CLANG
end

chunk "Compiling Swift files" do |c|
  c.line /^CompileSwift (?:#{WORD}\s)*(#{UNESCAPED_PATH}\.swift)$/ do |f, m|
    f.format_compile(path(m[1]))
  end
  c.line SHELL_CD
  c.line SWIFT
end

chunk "Compiling bunch of Swift files with whole module optimization" do |c|
  c.line /^CompileSwift( #{WORD})+$/

  c.line SHELL_CD
  c.line SHELL_EXPORT

  # Sometimes the list of files is too big, that xcodebuild is storing it in a
  # temporary file under -filelist flag
  c.line /#{SWIFT} (?:#{FLAG} )*-filelist (#{PATH}) .*$/ do |f, m|
    begin
      paths = File.read(m[2]).lines.map { |fp| path(fp.chomp) }
      f.format_compile_swift_with_module_optimization(paths)
    rescue Errno::ENOENT => e
      # No file found for the -filelist value.
      # TODO: alert pageruty, @channel people on call, etc
      Log.info e
    end
  end

  # List of files is passed thru command line
  c.line /#{SWIFT} (?:#{FLAG} )*(.*#{PATH}\.swift) .*$/ do |f, m|
    paths = Shellwords.split(m[2]).map { |p| path(p) }
    f.format_compile_swift_with_module_optimization(paths)
  end
end

chunk "Compile a pile of swift files" do |c|
  c.line /^CompileSwiftSources/ do |f|
    f.format_compile_swift_sources
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SWIFTC
end

chunk "Merge swift modules" do |c|
  c.line /^MergeSwiftModule (?:[\w]+\s)*(#{PATH}\.swiftmodule)$/ do |f, m|
    f.format_merge_swift_module(path(m[1]))
  end
  c.line SHELL_CD
  c.line SWIFT
end

chunk "Ditto" do |c|
  c.line /^Ditto (?:#{PATH}) (#{PATH})$/ do |f, m|
    f.format_ditto(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SHELL_BUILTIN
  c.line /^    \/usr\/bin\/ditto/
end

chunk "Code sign" do |c|
  c.line /^CodeSign\s(#{PATH})$/ do |f, m|
    f.format_codesign(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
end

chunk "Write auxilliary files" do |c|
  c.line /^Write auxiliary files$/ do |f|
    f.format_write_auxiliary_files()
  end
  c.line SHELL_MKDIR
  c.line SHELL_CHMOD
  c.line /^write-file (#{PATH})$/ do |f, m|
    f.format_write_file(path(m[1]))
  end
end

chunk "Create product structure" do |c|
  c.line /^Create product structure$/ do |f|
    f.format_create_product_structure()
  end
  c.line SHELL_MKDIR
end

chunk "Check Dependencies" do |c|
  c.line /^Check dependencies$/ do |f|
    f.format_check_dependencies()
  end
end

chunk "Process info.plist" do |c|
  c.line /^ProcessInfoPlistFile (?:#{PATH}.plist) (#{PATH}.plist)$/ do |f, m|
    f.format_process_info_plist(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SHELL_BUILTIN
end

chunk "Process entitlements" do |c|
  c.line(/^ProcessProductPackaging .* (#{PATH})(\/embedded\.mobileprovision|\.xcent)$/) do |f, m|
    product_name = path(m[1]).basename.to_s.sub(/-Simulated$/, "")
    f.format_process_entitlements(product_name)
  end
  c.exit /^\s{4}builtin-productPackagingUtility.*$/
  c.line /.*/
  c.line SHELL_CD
  c.line SHELL_EXPORT
end

chunk "PhaseScriptExecution" do |c|
  c.line /^PhaseScriptExecution\s((\\\ |\S)*)\s/ do |f, m|
    f.format_phase_script_execution(m[1].delete("\\"))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SHELL_SUBSHELL
end

chunk "Touch" do |c|
  c.line /^Touch (#{PATH})/ do |f, m|
    f.format_touch(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /^\s{4}\/usr\/bin\/touch -c/
end

chunk "Ld" do |c|
  c.line /^Ld (#{PATH}) (#{WORD})\s(#{WORD})$/ do |f, m|
    f.format_ld(path(m[1]), m[2], m[3])
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line CLANG
end

chunk "CpHeader" do |c|
  c.line /^CpHeader (#{PATH}) (#{PATH})$/ do |f, m|
    f.format_copy_header_file(path(m[1]), path(m[2]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SHELL_BUILTIN
end

chunk "CpResource" do |c|
  c.line /^CpResource (#{PATH}) (#{PATH})$/ do |f, m|
    f.format_cpresource(path(m[1]), path(m[2]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SHELL_BUILTIN
end

chunk "CompileXIB" do |c|
  c.line /^CompileXIB (#{PATH})/ do |f, m|
    f.format_compile_xib(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SHELL_IBTOOL
end

chunk "CompileStoryboard" do |c|
  # Currently there's a bug in CompileStoryboard where it escapes only
  # spaces, but not & signs.
  c.line /^CompileStoryboard (#{UNESCAPED_PATH}\.storyboard)$/ do |f, m|
    f.format_compile_storyboard(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SHELL_IBTOOL
end

chunk "Libtool" do |c|
  c.line /^Libtool (#{PATH}) (#{WORD}) (#{WORD})$/ do |f, m|
    f.format_libtool(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /^\s{4}(?:#{PATH})\/usr\/bin\/libtool /
end

chunk "CopyPNGFile" do |c|
  c.line /^CopyPNGFile (#{PATH}) (#{PATH})/ do |f, m|
    f.format_copy_png_file(path(m[2]), path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /^\s{4}(?:#{PATH})\/usr\/bin\/copypng /
end

chunk "CopyStringsFile" do |c|
  c.line /^CopyStringsFile (#{PATH}) (#{PATH})/ do |f, m|
    f.format_copy_strings_file(path(m[2]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SHELL_BUILTIN
end

chunk "CopySwiftLibs" do |c|
  c.line /^CopySwiftLibs (#{PATH})$/ do |f, m|
    f.format_copy_swift_libs(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /^\s{4}(?:#{PATH})\/usr\/bin\/swift-stdlib-tool /
  c.line /^\s{4}builtin-swiftStdLibTool /
  c.line /^Codesigning (#{PATH})$/ do |f, m|
    f.format_codesigning_swift_lib(path(m[1]))
  end
  c.line /^Probing signature of (#{PATH})$/ do |f, m|
    f.format_probing_swift_lib(path(m[1]))
  end
  c.line /^\s{2}\/usr\/bin\/codesign /
  c.line /^Code signature of (#{PATH}) is unchanged; keeping original$/ do |f, m|
    f.format_code_signature_unchanged(path(m[1]))
  end
end

chunk "CompileAssetCatalog" do |c|
  c.line /^CompileAssetCatalog (?:#{PATH}) (#{PATH})/ do |f, m|
    f.format_compile_asset_catalog(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /^\s{4}(?:#{PATH})\/usr\/bin\/actool /
  c.line /\* com\.apple\.actool\.compilation-results \*/
  c.line /^#{PATH}$/
end

chunk "CreateUniversalBinary" do |c|
  c.line /^CreateUniversalBinary (#{PATH})/ do |f, m|
    f.format_create_universal_binary(path(m[1]))
  end
  c.line SHELL_EXPORT
  c.line SHELL_CD
  c.line /^\s{4}(?:#{PATH})\/usr\/bin\/lipo /
  c.line /^\s{4}(?:#{PATH})\/usr\/bin\/libtool /
end

chunk "GenerateDSYMFile" do |c|
  c.line /^GenerateDSYMFile (#{PATH})/ do |f, m|
    f.format_generate_dsym(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /^\s{4}(?:#{PATH})\/usr\/bin\/dsymutil /
end

chunk "LinkStoryboards" do |c|
  c.line /^LinkStoryboards/ do |f, m|
    f.format_link_storyboards
  end
  c.line SHELL_IBTOOL
  c.line SHELL_CD
  c.line SHELL_EXPORT
end

chunk "PBXCp" do |c|
  c.line /^PBXCp (#{PATH}) (?:#{PATH})$/ do |f, m|
    f.format_pbxcp(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SHELL_BUILTIN
end

chunk "SymLink" do |c|
  c.line /^SymLink (#{PATH}) (#{PATH})$/ do |f, m|
    f.format_symlink(path(m[1]), path(m[2]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /\s{4}\/bin\/ln /
end

chunk "SwiftCodeGeneration" do |c|
  c.line /^SwiftCodeGeneration (?:#{WORD}\s)*(#{PATH})/ do |f, m|
    f.format_swift_code_generation(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line SWIFT
end

chunk "Strip" do |c|
  c.line /^Strip (#{PATH})$/ do |f, m|
    f.format_strip(path(m[1]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /^\s{4}(?:#{PATH})\/usr\/bin\/strip /
end

chunk "SetOwnerAndGroup" do |c|
  c.line /^SetOwnerAndGroup (\w+:\w+) (#{PATH})/ do |f, m|
    f.format_set_owner_and_group(m[1], path(m[2]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /\s{4}\/usr\/sbin\/chown /
end

chunk "SetMode" do |c|
  c.line /^SetMode ([\w\+\-,]+) (#{PATH})$/ do |f, m|
    f.format_set_mode(m[1], path(m[2]))
  end
  c.line SHELL_CD
  c.line SHELL_EXPORT
  c.line /\s{4}\/bin\/chmod /
end

# TODO: move
def self.action_regex(action)
  target = /^=== #{action}(?: AGGREGATE)? TARGET (.*)/
  project = /OF PROJECT (.*)/
  configuration = /WITH(?: THE DEFAULT)? CONFIGURATION (.*) ===$/

  /#{target} #{project} #{configuration}/
end

chunk "=== BUILD target" do |c|
  c.line action_regex("BUILD") do |f, m|
    f.format_build_target(m[1], m[2], m[3])
  end
end

chunk "=== CLEAN target" do |c|
  c.line action_regex("CLEAN") do |f, m|
    f.format_clean_target(m[1], m[2], m[3])
  end
end

chunk "=== ANALYZE target" do |c|
  c.line action_regex("ANALYZE") do |f, m|
    f.format_analyze_target(m[1], m[2], m[3])
  end
end

end

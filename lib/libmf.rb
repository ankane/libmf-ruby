# dependencies
require "ffi"

# modules
require "libmf/model"
require "libmf/version"

module Libmf
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  lib_name =
    if Gem.win_platform?
      "mf.dll"
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      if RbConfig::CONFIG["host_cpu"] =~ /arm/i
        "libmf.arm64.dylib"
      else
        "libmf.dylib"
      end
    else
      if RbConfig::CONFIG["host_cpu"] =~ /aarch64/i
        "libmf.arm64.so"
      else
        "libmf.so"
      end
    end
  vendor_lib = File.expand_path("../vendor/#{lib_name}", __dir__)
  self.ffi_lib = [vendor_lib]

  # friendlier error message
  autoload :FFI, "libmf/ffi"
end

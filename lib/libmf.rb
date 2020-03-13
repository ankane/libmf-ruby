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
      "libmf.dylib"
    else
      "libmf.so"
    end
  vendor_lib = File.expand_path("../vendor/#{lib_name}", __dir__)
  self.ffi_lib = [vendor_lib]

  # friendlier error message
  autoload :FFI, "libmf/ffi"
end

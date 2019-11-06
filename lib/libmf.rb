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
  self.ffi_lib = ["mf"]

  lib_path =
    if ::FFI::Platform.windows?
      "../vendor/windows/mf.dll"
    elsif ::FFI::Platform.mac?
      "libmf.bundle"
    else
      "libmf.so"
    end
  self.ffi_lib << File.expand_path(lib_path, __dir__)

  # friendlier error message
  autoload :FFI, "libmf/ffi"
end

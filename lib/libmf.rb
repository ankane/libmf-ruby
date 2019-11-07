# dependencies
require "fiddle/import"

# modules
require "libmf/model"
require "libmf/version"

module Libmf
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  root_path = File.expand_path("..", __dir__)
  self.ffi_lib = [
    "#{root_path}/lib/libmf.so",
    "#{root_path}/lib/libmf.bundle",
    "#{root_path}/vendor/libmf/windows/mf.dll"
  ]

  # friendlier error message
  autoload :FFI, "libmf/ffi"
end

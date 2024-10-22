require_relative "lib/libmf/version"

Gem::Specification.new do |spec|
  spec.name          = "libmf"
  spec.version       = Libmf::VERSION
  spec.summary       = "Large-scale sparse matrix factorization for Ruby"
  spec.homepage      = "https://github.com/ankane/libmf-ruby"
  spec.license       = "BSD-3-Clause"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib,vendor}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "ffi"
end

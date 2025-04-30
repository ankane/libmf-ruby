require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

class Minitest::Test
  def setup
    if stress?
      # autoload before GC.stress
      Libmf::FFI.name
      read_file("real_matrix.te.txt")
      read_file("real_matrix.tr.txt")
      GC.stress = true
    end
  end

  def teardown
    GC.stress = false if stress?
  end

  def stress?
    ENV["STRESS"]
  end
end

require "mkmf"

arch = RbConfig::CONFIG["arch"]
case arch
when /mingw/
  File.write("Makefile", dummy_makefile("libmf").join)
else
  $CXXFLAGS << " -std=c++0x -DUSESSE"

  $srcs = ["mf.cpp"]
  vendor_path = File.expand_path("../../vendor/libmf", __dir__)
  create_makefile("libmf", vendor_path)
end

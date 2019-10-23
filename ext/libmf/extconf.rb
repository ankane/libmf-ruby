require "mkmf"

arch = RbConfig::CONFIG["arch"]
case arch
when /mingw/
  File.write("Makefile", dummy_makefile("libmf").join)
else
  abort "Missing stdc++" unless have_library("stdc++")
  $CXXFLAGS << " -std=c++11"

  # TODO
  # if have_library("libomp")
  # end

  $objs = ["mf.o"]
  vendor_path = File.expand_path("../../vendor/libmf", __dir__)
  create_makefile("libmf", vendor_path)
end

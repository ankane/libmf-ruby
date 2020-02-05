require "mkmf"

arch = RbConfig::CONFIG["arch"]
case arch
when /mingw/
  File.write("Makefile", dummy_makefile("libmf").join)
else
  abort "Missing stdc++" unless have_library("stdc++")
  $CXXFLAGS << " -std=c++0x"

  # use SSE to accelerate LIBMF
  $CXXFLAGS << " -DUSESSE"

  # if have_library("omp")
  #   $CXXFLAGS << " -fopenmp -DUSEOMP"
  # end

  $objs = ["mf.o"]
  vendor_path = File.expand_path("../../vendor/libmf", __dir__)
  create_makefile("libmf", vendor_path)
end

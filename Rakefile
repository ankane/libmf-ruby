require "bundler/gem_tasks"
require "rake/testtask"
require "ruby_memcheck"

test_config = lambda do |t|
  t.pattern = "test/**/*_test.rb"
end
Rake::TestTask.new(&test_config)

namespace :test do
  RubyMemcheck::TestTask.new(:valgrind, &test_config)
end

task default: :test

def download_file(file, sha256)
  require "open-uri"

  url = "https://github.com/ankane/ml-builds/releases/download/libmf-3d5570a/#{file}"
  puts "Downloading #{file}..."
  contents = URI.parse(url).read

  computed_sha256 = Digest::SHA256.hexdigest(contents)
  raise "Bad hash: #{computed_sha256}" if computed_sha256 != sha256

  dest = "vendor/#{file}"
  File.binwrite(dest, contents)
  puts "Saved #{dest}"
end

namespace :vendor do
  task :linux do
    download_file("libmf.so", "2197628cfff98ede7269edc191ec8b7ff6e04edd4d20088938637ddefa596f40")
    download_file("libmf.arm64.so", "99d315522ebd118318dad42ffeda08683cbdbd76c5e609cf7a494f9155feca2f")
  end

  task :mac do
    download_file("libmf.dylib", "a6ea218370dbb489119e8a561089beea860a05ae0c30e58cc26d5f980d6cb8a2")
    download_file("libmf.arm64.dylib", "fd88da76cb1b9cfdc02fc7dc14a61229195ae9fdf845c78ede7701bb72dfe4e2")
  end

  task :windows do
    download_file("mf.dll", "c65eec5ef25482780f8b8f429d55d58ebf494288f84ccb689a2e7e88346fdc40")
  end

  task all: [:linux, :mac, :windows]

  task :platform do
    if Gem.win_platform?
      Rake::Task["vendor:windows"].invoke
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      Rake::Task["vendor:mac"].invoke
    else
      Rake::Task["vendor:linux"].invoke
    end
  end
end

task :benchmark do
  require "benchmark/ips"
  require "libmf"

  data = []
  File.foreach("vendor/demo/real_matrix.tr.txt") do |line|
    row = line.chomp.split(" ")
    data << [row[0].to_i, row[1].to_i, row[2].to_f]
  end
  model = Libmf::Model.new(quiet: true)

  Benchmark.ips do |x|
    x.report("fit") { model.fit(data) }
  end
end

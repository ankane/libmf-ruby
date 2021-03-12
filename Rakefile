require "bundler/gem_tasks"
require "rake/testtask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = false
end

def download_file(file, sha256)
  require "open-uri"

  url = "https://github.com/ankane/ml-builds/releases/download/libmf-master-2/#{file}"
  puts "Downloading #{file}..."
  contents = URI.open(url).read

  computed_sha256 = Digest::SHA256.hexdigest(contents)
  raise "Bad hash: #{computed_sha256}" if computed_sha256 != sha256

  dest = "vendor/#{file}"
  File.binwrite(dest, contents)
  puts "Saved #{dest}"
end

namespace :vendor do
  task :linux do
    download_file("libmf.so", "5a22ec277a14ab8e3b8efacfec7fe57e5ac4192ea60e233d7e6db38db755a67e")
    download_file("libmf.arm64.so", "223ef5d1213b883c8cb8623bf07bf45167cd48585a5f2b59618cea034c72ad61")
  end

  task :mac do
    download_file("libmf.dylib", "6e3451feeded62a2e761647aef7c2a0e7dbeeee83ce8d4ab06586f5820f7ebf9")
    download_file("libmf.arm64.dylib", "063c1dc39a6fda12ea2616d518fa319b8ab58faa65b174f176861cf8f8eaae0d")
  end

  task :windows do
    download_file("mf.dll", "8b0e53ab50ca3e2b365424652107db382dff47a26220c092b89729f9c3b8d7e7")
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

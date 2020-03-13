require "bundler/gem_tasks"
require "rake/testtask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = false
end

def download_file(file)
  require "open-uri"

  url = "https://github.com/ankane/ml-builds/releases/download/libmf-master/#{file}"
  puts "Downloading #{file}..."
  dest = "vendor/#{file}"
  File.binwrite(dest, URI.open(url).read)
  puts "Saved #{dest}"
end

namespace :vendor do
  task :linux do
    download_file("libmf.so")
  end

  task :mac do
    download_file("libmf.dylib")
  end

  task :windows do
    download_file("mf.dll")
  end

  task all: [:linux, :mac, :windows]
end

task :benchmark do
  require "benchmark/ips"
  require "libmf"

  data = []
  File.foreach("vendor/libmf/demo/real_matrix.tr.txt") do |line|
    row = line.chomp.split(" ")
    data << [row[0].to_i, row[1].to_i, row[2].to_f]
  end
  model = Libmf::Model.new(quiet: true)

  Benchmark.ips do |x|
    x.report("fit") { model.fit(data) }
  end
end

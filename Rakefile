require "bundler/gem_tasks"
require "rake/testtask"
require "rake/extensiontask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = false
end

Rake::ExtensionTask.new("libmf")

# include ext in local installs but not releases
task :remove_ext do
  path = "lib/libmf.bundle"
  File.unlink(path) if File.exist?(path)
end

Rake::Task["release:guard_clean"].enhance [:remove_ext]

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

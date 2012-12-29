task :gem do
  require 'echoe'

  Echoe.new("rmemlimit") do |p|
    p.author = "Andrew Snow"
    p.email = 'andrew@modulus.org'
    p.summary = "Slow down garbage collector & limit ruby process memory"
    p.url = "https://github.com/andys/rmemlimit"
  end
end

task :test do
  `ruby #{File.dirname(__FILE__)}/test/rmemlimit_test.rb`
end

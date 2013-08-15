require "#{File.dirname(__FILE__)}/../lib/rmemlimit"
Rmemlimit.setup
require 'test/unit'

class TestRmemlimit < Test::Unit::TestCase

  def test_rss_kb
    Rmemlimit.run_gc
    kb = Rmemlimit.rss_kb
    assert(kb > 0)
    
    assert_equal "VmRSS:\t%8d kB\n" % kb,
                 File.read("/proc/#{$$}/status").lines.grep(/VmRSS/).first
  end
  
  def test_gc_mb
    Rmemlimit.gc_mb = Rmemlimit.rss_mb
    Rmemlimit.sleep_time = 0.5
    gccount = GC.stat[:count]
    flibble = 'x' * 100000000
    sleep 0.6
    assert_equal gccount + 1, GC.stat[:count] 
  end

end

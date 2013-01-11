require "#{File.dirname(__FILE__)}/../lib/rmemlimit"
Rmemlimit.setup
require 'test/unit'

class TestRmemlimit < Test::Unit::TestCase

  def test_rss_kb
    kb = Rmemlimit.rss_kb
    assert(kb > 0)
    
    assert_equal "VmRSS:\t%8d kB\n" % kb,
                 File.read("/proc/#{$$}/status").lines.grep(/VmRSS/).first
  end
  
  def test_run_gc
    gccount = GC.stat[:count] + 1
    sleep 1.1
    assert_equal gccount, GC.stat[:count]
  end
  
  def test_gc_mb
    Rmemlimit.gc_mb = Rmemlimit.rss_mb
    gccount = GC.stat[:count] + 1
    flibble = 'x' * 1024 * 1024
    sleep 1.1
    assert_equal gccount, GC.stat[:count]
  end

end

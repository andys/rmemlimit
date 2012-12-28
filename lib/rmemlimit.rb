
class Rmemlimit

  class << self
    attr_accessor :gc_mb, :kill_mb
    
    def gcthread
      @gcthread ||= Thread.new do
        loop do
          mb = rss_mb
          if kill_mb && mb > kill_mb
            STDERR.puts "#{self}: Exceeded kill memory limit (#{mb} > #{kill_Mb} MB)"
            Process.kill(9, $$)
          elsif gc_mb && mb > gc_mb
            run_gc
          elsif mb == 0 || !gc_mb || !kill_mb
            run_gc
          end
          sleep 1
        end
      end
    end
    
    def run_gc
      GC.enable
      GC.start
      GC.disable
    end
  
    def pagesize
      4096
    end
    
    def rss_mb
      rss_kb >> 10
    end
    
    def rss_kb
      pagesize * (File.read("/proc/#{$$}/statm").split(' ')[1].to_i rescue 0) >> 10
    end
    
    def setup
      self.gc_mb = ENV['RUBY_GC_MB'].to_i if ENV['RUBY_GC_MB']
      if ENV['RUBY_KILL_MB']
        self.kill_mb = ENV['RUBY_KILL_MB'].to_i 
        self.kill_mb = nil unless Rmemlimit.kill_mb > 1
      end
      GC.disable
      self.gcthread
    end
  end

end

Rmemlimit.setup

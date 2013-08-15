class Rmemlimit

  class << self
    attr_accessor :gc_mb, :kill_mb, :sleep_time

    def gcthread
      if !@gcthread || !@gcthread.alive?
        @gcthread = Thread.new do
          begin
            loop do
              mb = rss_mb
              if kill_mb && mb > kill_mb
                STDERR.puts "#{self}: Exceeded kill memory limit (#{mb} > #{kill_mb} MB)"
                Process.kill(9, $$)
              elsif gc_mb && mb > gc_mb
                run_gc
              end
              sleep sleep_time
            end
          rescue
            puts "Exception: #{$!.class} #{$!}"
          end
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
      self.sleep_time ||= 1
      self.gc_mb = ENV['RUBY_GC_MB'].to_i if ENV['RUBY_GC_MB']
      if ENV['RUBY_KILL_MB']
        self.kill_mb = ENV['RUBY_KILL_MB'].to_i
        self.kill_mb = nil unless Rmemlimit.kill_mb > 1
      end
      GC.disable if gc_mb
      self.gcthread
    end
  end

end

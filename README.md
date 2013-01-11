
## Rmemlimit gem

The garbage collector in Ruby 1.x is blocking, and runs whenever there is a
need to allocate more memory for new objects.

In a large application (eg. Rails) it runs many times per second, saving
memory but hurting performance.

#### Run GC less often

To increase performance, you can use this gem to run the GC once per second
instead, in a background thread.

    gem 'rmemlimit' # in your Gemfile

    Rmemlimit.setup # somewhere in app startup, or after forking


#### Set a memory limit for GC (requires linux /proc)

If you know roughly how much RAM you want your app to use, you can set that
and GC will run whenever it is exceeded.  Resident Set Size is checked once
per second. Example to limit to 500MB:

    Rmemlimit.gc_mb = 500

(Or you can use the RUBY_GC_MB environment variable). 


#### Set a hard memory limit for Ruby

If your application sometimes eats too much memory and you'd rather have it
kill itself when it passes a threshold, you can do limit to say 1000MB:

    Rmemlimit.kill_mb = 1000

(Or you can use the RUBY_KILL_MB environment variable)


#### Forking

When fork()ing in ruby 1.9, only the thread doing the fork keeps running in
the child.  So you have to call Rmemlimit.setup in every child after
forking, or GC won't be running at all.


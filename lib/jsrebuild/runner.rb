module JSRebuild
  class Runner
    def initialize(dir, interval, jake_options)
      @dir          = Jake.path(dir || Dir.getwd)
      @config_file  = Jake.path(dir, CONFIG_FILE)
      @helper_file  = Jake.path(dir, HELPER_FILE)
      
      @jake_options = jake_options
      
      @config       = Config.new(@dir, @jake_options)
      @config.load!
      @watcher      = Watcher.new(@config)
    end
    
    def rebuild!
      build = Jake::Build.new(@dir, @jake_options)
      
      build.on(:file_created) do |build, pkg, build_type, path|
        size = (File.size(path) / 1024.0).ceil
        @logger.log(LOG_FORMAT % [pkg.name, build_type, path.gsub(@dir, ''), "#{ size } kB"])
      end
      
      build.on(:file_not_changed) do |build, pkg, build_type, path|
        @logger.log(LOG_FORMAT % [pkg.name, build_type, path.gsub(@dir, ''), 'UP-TO-DATE'])
      end
      
      begin
        build.run!
      rescue => err
        @logger.err(err.message + "\n" + (err.backtrace * "\n"))
      end
    end
    
    def run!
      %w{HUP INT}.each do |sig|
        Signal.trap(sig) { exit! }
      end
      
      @watcher.on :config_change do |w, path|
        @config.load!
        rebuild!
      end
      
      @watcher.on :script_change do |w, path|
        @config.load!
        rebuild!
      end
      
      @watcher.on :source_change do |w, path|
        rebuild!
      end
      
      @watcher.start
    end
    
    def exit!
      @watcher.stop
    end
  end
end

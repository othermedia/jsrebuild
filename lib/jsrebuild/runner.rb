module JSRebuild
  class Runner
    def initialize(dir, interval, jake_options)
      @dir          = Jake.path(dir || Dir.getwd)
      @jake_options = jake_options
      @config       = load_config!
      @watcher      = Watcher.new(interval, @config)
    end
    
    def rebuild!
      build = Jake::Build.new(@dir, @jake_options)
      
      build.on(:file_created) do |build, pkg, build_type, path|
        size = (File.size(path) / 1024.0).ceil
        $stderr.puts LOG_FORMAT % [pkg.name, build_type, path.gsub(@dir, ''), "#{ size } kB"]
      end
      
      build.on(:file_not_changed) do |build, pkg, build_type, path|
        $stderr.puts LOG_FORMAT % [pkg.name, build_type, path.gsub(@dir, ''), 'UP-TO-DATE']
      end
      
      begin
        build.run!
      rescue => err
        $stderr.puts err.message + "\n" + (err.backtrace * "\n")
      end
    end
    
    def load_config!
      @config = Config.new(@dir, @jake_options)
    end
    
    def run!
      %w{HUP INT}.each do |sig|
        Signal.trap(sig) { exit! }
      end
      
      @watcher.on :config_change do |w, path|
        load_config!
        rebuild!
      end
      
      @watcher.on :helper_change do |w, path|
        load_config!
        rebuild!
      end
      
      @watcher.on :source_change do |w, path|
        rebuild!
      end
      
      rebuild!
      
      @watcher.start
    end
    
    def exit!
      @watcher.stop
      exit(true)
    end
  end
end

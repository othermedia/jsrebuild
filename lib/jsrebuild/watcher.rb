module JSRebuild
  class Watcher
    include Eventful
    
    def initialize(interval = 0.5, config)
      @interval       = interval
      @config         = config
      @loop           = nil
      @watchers       = nil
      @config_watcher = nil
      @helper_watcher = nil
    end
    
    def start
      return unless @loop.nil?
      
      config_file      = @config.config_file
      helper_file      = @config.helper_file
      
      @loop            = Coolio::Loop.default
      
      @config_watcher  = FileWatcher.new(config_file, @interval)
      @helper_watcher  = FileWatcher.new(helper_file, @interval)
      
      @config_watcher.on :change do
        fire(:config_change, config_file)
        reattach_source_watchers
      end
      
      @helper_watcher.on :change do
        fire(:helper_change, helper_file)
        reattach_source_watchers
      end
      
      @config_watcher.attach(@loop)
      @helper_watcher.attach(@loop)
      
      attach_source_watchers
      
      @loop.run
    end
    
    def reattach_source_watchers
      detach_source_watchers
      attach_source_watchers
    end
    
    def attach_source_watchers
      @source_watchers = {}
      
      @config.source_files.each do |file|
        watcher = FileWatcher.new(file, @interval)
        @source_watchers[file] = watcher
        
        watcher.on :change do
          fire(:source_change, file)
        end
        
        watcher.attach(@loop)
      end
    end
    
    def detach_source_watchers
      unless @source_watchers.nil? || @source_watchers.empty?
        @source_watchers.each do |file, watcher|
          watcher.detach
        end
      end
    end
    
    def stop
      detach_source_watchers
      
      @config_watcher.detach
      @helper_watcher.detach
      
      @loop.stop
    end
  end
  
  class FileWatcher < Coolio::StatWatcher
    include Eventful
    
    def initialize(path, interval = 0)
      @ctime = File.ctime(path) if File.exists?(path)
      super
    end
    
    def on_change
      fire(:change) and return unless File.exists?(path)
      
      ctime = File.ctime(path)
      
      if @ctime.nil? || ctime > @ctime
        @ctime = ctime
        fire(:change)
      end
    end
  end
end

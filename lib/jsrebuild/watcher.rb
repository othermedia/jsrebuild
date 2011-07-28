module JSRebuild
  class Watcher
    include Eventful
    
    def initialize(config)
      @config      = config
      @config_file = config.config_file
      @helper_file = config.helper_file
      
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
      
      @config_watcher  = Coolio::StatWatcher.new(config_file, 0.5)
      @helper_watcher  = Coolio::StatWatcher.new(helper_file, 0.5)
      
      @config_watcher.on_change do
        puts "changed config file"
        fire(:config_change, config_file)
        reattach_source_watchers
      end
      
      @helper_watcher.on_change do
        puts "changed helper file"
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
        watcher = Coolio::StatWatcher.new(file, 0.5)
        @watchers[file] = watcher
        
        watcher.on_change do
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
end

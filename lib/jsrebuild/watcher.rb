module JSRebuild
  # Every jsrebuild process has a Watcher, which keeps tabs on the config,
  # helper and source files and notifies the application if any of them change.
  class Watcher
    include Eventful
    
    # Set the interval at which files should be checked for changes, and pass
    # in a JSRebuild::Config object which tells the watch which config, helper
    # and source files it should watch.
    def initialize(interval = 0.5, config)
      @interval       = interval
      @config         = config
      @loop           = nil
      @watchers       = nil
      @config_watcher = nil
      @helper_watcher = nil
    end
    
    # Start the watcher process.
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
    
    # Detach all current source watchers and attach new ones.
    #
    # This is a simple and robust way of ensuring that when changes are made
    # which change which files should be watched, only those files which should
    # be watched are watched, and no others.
    def reattach_source_watchers
      detach_source_watchers
      attach_source_watchers
    end
    
    # Attach a file watcher to each source file.
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
    
    # Detach all current source watchers.
    def detach_source_watchers
      unless @source_watchers.nil? || @source_watchers.empty?
        @source_watchers.each do |file, watcher|
          watcher.detach
        end
      end
    end
    
    # Detach all watchers and stop the event loop.
    def stop
      detach_source_watchers
      
      @config_watcher.detach
      @helper_watcher.detach
      
      @loop.stop
    end
  end
  
  # The FileWatcher class is a small extension to the Coolio::StatWatcher class
  # which encapsulates one further piece of information, the last time the
  # watched file was changed.
  #
  # When the watched file changes, FileWatcher objects notify any observers
  # only when the file has been modified since it was last checked.
  class FileWatcher < Coolio::StatWatcher
    include Eventful
    
    # Notify any observers if either the file no longer exists, or if the file
    # has been modified since it was last checked.
    def on_change(prev, current)
      fire(:change) and return unless File.exists?(path)
      
      fire(:change) if current.ctime > prev.ctime
    end
  end
end

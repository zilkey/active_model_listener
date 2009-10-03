class ActiveModelListener

  class << self
    def listeners
      @listeners ||= []
    end

    def listeners=(listeners)
      @listeners = listeners
    end

    def dispatch(object, action)
      self.listeners.each do |listener|
        listener.send "after_#{action}", object
      end
    end

    def without_listeners
      with_listeners([]) do
        yield
      end
    end

    def with_listeners(*listeners)
      original_listeners = self.listeners
      self.listeners = listeners.flatten
      yield
    ensure
      self.listeners = original_listeners
    end
  end

end
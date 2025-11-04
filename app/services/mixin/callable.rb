module Mixin
  # This concern is useful when you need to create a service.
  #
  # It gives you 2 class methods : +.call+ and +.call_later+.
  #
  # By sending +.call+, the service is executed and give you a return value.
  #
  # When sending +.call_later+, the service is queued in a {CallableJob}
  # and you can not have a return value. The queue can be change with +.queue+.
  #
  # @example Call a service
  #   class MyService
  #     include Mixin::Callable
  #
  #     def call
  #       # do stuff
  #     end
  #   end
  #
  #   MyService.call
  #
  # @example Enqueue a service
  #   class MyService
  #     include Mixin::Callable
  #
  #     def call
  #       # do stuff
  #     end
  #   end
  #
  #   MyService.call_later
  #
  # @example Enqueue a service in a specific queue
  #   class MyService
  #     include Mixin::Callable
  #
  #     queue :my_service
  #
  #     def call
  #       # do stuff
  #     end
  #   end
  #
  #   MyService.call_later
  module Callable
    extend ActiveSupport::Concern

    module ClassMethods
      # @param ... any service parameters
      def call(...)
        service = new(...)
        service.prepare
        result = service.call
        service.finish
        result
      end

      # @param ... any service parameters
      def call_later(...)
        options = {}
        options[:queue] = @queue if @queue

        CallableJob.set(options).perform_later(name, ...)
      end

      # @param queue [String, nil] the queue
      def queue(queue = nil)
        @queue = queue
      end
    end

    def prepare
    end

    def call
      raise NotImplementedError, "#{self.class} must implement #call"
    end

    def finish
    end
  end
end

require "flexcon/version"

module Flexcon
  class << self
    def dispatch(scope, handler, *props)
      handler.call(*self.args(self.eval_scope(scope), handler, *props))
    end

    protected
      def args(scope, handler, *props)
        props = self.argnames(handler) if props.empty?

        getter   = lambda do |index| scope[props[index]]      end if scope.is_a?(Hash)
        getter ||= lambda do |index| scope[index]             end if scope.is_a?(Array)
        getter ||= lambda do |index| scope.send(props[index]) end

        limit = handler.arity
        limit = props.size if limit == -1

        return (0...limit).map(&getter)
      end

      def argnames(handler)
        handler.parameters.map { |a| a[-1] }
      end
    
      def eval_scope(scope)
        return scope.call if scope.is_a?(Proc)
        return scope
      end
  end
end

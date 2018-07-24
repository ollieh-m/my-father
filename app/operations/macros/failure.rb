module Macros
  module Failure

    def self.Set(&block)
      step = ->(input, options) do
        unless input['failure']
          input['failure'] = ::Failure.new(block ? block.call(input, options['params']) : {})
        end
      end

      [ step, name: 'set_failure' ]
    end

  end
end

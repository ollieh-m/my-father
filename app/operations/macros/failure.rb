module Macros
  module Failure

    def self.Set(&block)
      step = ->(input, options) do
        unless input["failure"]
          failure_options = block.call(input, options["params"])
          input["failure"] = ::Failure.new(**failure_options)
        end
      end

      [ step, name: "set_failure" ]
    end

  end
end

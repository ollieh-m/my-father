class Failure

  attr_reader :message, :type, :go_to, :step

  def initialize(message: nil, type: :next, go_to: nil, step:, detail: nil)
    @message = message
    @type = type
    @go_to = go_to
    @step = step
  end

end

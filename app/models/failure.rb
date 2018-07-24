class Failure

  attr_reader :message, :type, :go_to

  def initialize(message: nil, type: :next, go_to: nil)
    @message = message
    @type = type
    @go_to = go_to
  end

end

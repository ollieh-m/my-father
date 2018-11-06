class Session::New < Trailblazer::Operation

  step :contract

  step :set_redirect_to

  def contract(options, params:, **)
    options['contract.default'] = SessionForm.new
  end

  def set_redirect_to(options, params:, **)
  	options['contract.default'].redirect_to = params[:redirect_to]
  end

end

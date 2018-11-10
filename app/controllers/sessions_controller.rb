class SessionsController < ApplicationController

	def new
    render locals: {
      form: Session::New.(params)['contract.default']
    }
	end

	def create
		result = Session::Create.(session_params, session: session)

    if result.success?
      redirect_to result['redirect_to']
    else
      handle_standard_failure(result['failure'], locals: {form: result['contract.default']})
    end
	end

  private

  def session_params
    params.require(:session_form).permit(:password, :redirect_to)
  end

end
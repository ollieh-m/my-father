class Session::Create < Trailblazer::Operation

	include Rails.application.routes.url_helpers

  step :contract

  step :validate
  failure Macros::Failure::Set() { |options, params|
    {
      type: :now,
      step: 'validate',
      go_to: :new
    }
  }

  step :sign_in

  step :set_redirect

  def contract(options, params:, **)
    options['contract.default'] = SessionForm.new
  end

  def validate(options, params:, **)
  	if options['contract.default'].validate(params)
  		options['contract.validated_as'] = options['contract.default'].validated_as
  	end
  end

  def sign_in(options, params:, session:, **)
  	session[:current_user] = options['contract.validated_as']
  end

  def set_redirect(options, params:, **)
  	options['redirect_to'] = if params[:redirect_to].present?
  		params[:redirect_to]
  	elsif options['contract.validated_as'] == 'admin'
  		admin_part_sections_path(part_id: Part.first)
  	else
  		part_sections_path(part_id: Part.first)
  	end
  end

end

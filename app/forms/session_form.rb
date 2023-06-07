class SessionForm
  include ActiveModel::Model

  attr_accessor :password, :redirect_to
  attr_reader :validated_as
  validate :check_password_against_env_variables

  def validate(params)
    self.password = params[:password]
    valid?
  end

  def check_password_against_env_variables
    if password == ENV["STANDARD_PASSWORD"]
      @validated_as = "standard"
    elsif password == ENV["ADMIN_PASSWORD"]
      @validated_as = "admin"
    else
      errors[:password] << "Sorry, that password is wrong"
    end
  end
end

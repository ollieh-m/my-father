module Admin
  class BaseController < ApplicationController
    layout 'admin'

    before_action :authenticate!

    private

      def authenticate!
        unless admin_access?
          redirect_to new_session_path(redirect_to: request.fullpath)
        end
      end
  end
end

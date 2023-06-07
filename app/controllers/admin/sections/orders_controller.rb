module Admin
  module Sections
    class OrdersController < BaseController
      def update
        result = SectionOrder::Update.(params)

        if result.success?
          render json: {
            status: "success"
          }, status: :ok
        else
          render json: {
            error: result["failure"].message
          }, status: :bad_request
        end
      end
    end
  end
end

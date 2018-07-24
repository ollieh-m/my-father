module StandardFailure

  def handle_standard_failure(failure)
    if failure.type == :now
      flash.now[:alert] = failure.message
      render failure.go_to
    elsif failure.type == :next
      flash[:alert] = failure.message
      redirect_to failure.go_to
    end
  end

end

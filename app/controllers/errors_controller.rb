class ErrorsController < ApplicationController
  def not_found
    render :status => 404
  end

  def unacceptable
    render :status => 422
  end

  def internal_error
    render :status => 500
  end

  def cause_an_internal_error
    i_cause_error
  end
end

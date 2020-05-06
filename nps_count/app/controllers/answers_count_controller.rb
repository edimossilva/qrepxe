class AnswersCountController < ApplicationController
  def index
    count_result = AnswersCountService.call
    render json: count_result, status: :ok
  end
end

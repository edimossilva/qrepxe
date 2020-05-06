class AnswersCollectionController < ApplicationController
  def create
    answers = Answer.save_many(answer_collection_params)
    render json: answers, status: :created
  end

  private

  def answer_collection_params
    params.require('_json').map do |param|
      param.require(%i[company timestamp])
      param.permit(:grade, :company, :timestamp).to_hash
    end
  end
end

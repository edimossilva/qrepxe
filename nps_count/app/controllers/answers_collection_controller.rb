class AnswersCollectionController < ApplicationController
  def create
    answer = AnswerCollection.save_many(answer_collection_params)
    render json: answer, status: :created
  end

  private

  def answer_collection_params
    params.require('_json').map do |param|
      param.require(%i[company timestamp])
      param.permit(:grade, :company, :timestamp).to_hash
    end
  end
end

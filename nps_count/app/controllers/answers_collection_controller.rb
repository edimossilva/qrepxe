class AnswersCollectionController < ApplicationController
  # POST /answers
  def create
    answer = AnswerCollection.save(answer_collection_params)
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

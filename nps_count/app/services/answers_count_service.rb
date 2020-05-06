class AnswersCountService < ApplicationService
  attr_reader :query

  def call
    lowest = find_lowest
    {
      company: lowest['_id'],
      count: lowest['count']
    }
  end

  def find_lowest
    Answer.collection
          .aggregate([
                       {
                         '$group': {
                           _id: '$company',
                           count: { '$sum': 1 }
                         }
                       },
                       { '$sort': { count: 1 } }
                     ]).first
  end
end

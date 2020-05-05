class NpsService < ApplicationService
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def call
    report_count = count_categories

    promoters_percentage = percent_of(report_count['countPromoters'], report_count['countTotal'])
    detractors_percentage = percent_of(report_count['countDetractors'], report_count['countTotal'])

    calculate_nps_score(promoters_percentage, detractors_percentage)
  end

  def calculate_nps_score(promoters_percentage, detractors_percentage)
    nps_score = promoters_percentage - detractors_percentage
    "#{nps_score}%"
  end

  def percent_of(value, total)
    value / total.to_f * 100.0
  end

  def count_categories
    AnswerCollection.collection.aggregate([
                                            { '$match': params },
                                            {
                                              '$project': {
                                                item: 1,
                                                'promoters': {
                                                  '$cond': [{ '$gt': ['$grade', 8] }, 1, 0]
                                                },
                                                'detractors': {
                                                  '$cond': [{ '$lt': ['$grade', 7] }, 1, 0]
                                                },
                                                'total': {
                                                  '$cond': [{ '$gte': ['$grade', 0] }, 1, 0]
                                                }
                                              }
                                            },
                                            {
                                              '$group': {
                                                _id: '$item',
                                                countPromoters: { '$sum': '$promoters' },
                                                countDetractors: { '$sum': '$detractors' },
                                                countTotal: { '$sum': '$total' }
                                              }
                                            }
                                          ]).first
  end
end

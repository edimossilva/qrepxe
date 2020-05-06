class NpsService < ApplicationService
  attr_reader :query

  def initialize(params = {})
    @query = {}
    merge_company(params[:company]) if params.key? :company
    merge_date(params[:month], params[:year]) if params.key?(:month) && params.key?(:year)
  end

  def merge_company(company)
    @query['company'] = company
  end

  def merge_date(month, year)
    day_number = 1

    from_date = Time.zone.local(year, month, day_number)
    to_date = from_date.at_beginning_of_month.next_month

    from_timestamp = from_date.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
    to_timestamp = to_date.strftime('%Y-%m-%dT%H:%M:%S.%L%z')

    timestamp_query = {
      '$gte': from_timestamp,
      '$lt': to_timestamp
    }

    @query['timestamp'] = timestamp_query
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
                                            { '$match': query },
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

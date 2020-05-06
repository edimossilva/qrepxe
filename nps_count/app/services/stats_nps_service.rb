class StatsNpsService < ApplicationService
  def call
    companies = Answer.companies

    companies_nps = find_companies_nps(companies)

    {
      median_nps: median(companies_nps),
      average_nps: average(companies_nps)
    }
  end

  private

  def average(array)
    result = (array.reduce(:+) / array.size.to_f).round(2)
    "#{result}%"
  end

  def median(array)
    sorted = array.sort
    len = sorted.length
    result = if len.even?
               (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
             else
               sorted[len / 2]
             end
    result_f = result.round(2)
    "#{result_f}%"
  end

  def find_companies_nps(companies)
    companies.map do |company|
      company_nps_f(company)
    end
  end

  def company_nps_f(company)
    NpsService.call(company: company).delete('%').to_f
  end
end

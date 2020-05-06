class HighestNpsService < ApplicationService
  attr_reader :query

  def call
    companies = Answer.companies

    company = companies.max { |a, b| company_nps_f(a) <=> company_nps_f(b) }

    {
      highest_nps: "#{company_nps_f(company)}%",
      highest_nps_company: company
    }
  end

  def company_nps_f(company)
    NpsService.call(company: company).delete('%').to_f
  end
end

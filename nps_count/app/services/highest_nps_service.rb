class HighestNpsService < ApplicationService
  attr_reader :query

  def call
    companies = Answer.companies

    highest_nps = -100
    highest_nps_company = nil

    companies.each do |company|
      company_nps = company_nps_f(company)
      if company_nps > highest_nps
        highest_nps = company_nps
        highest_nps_company = company
      end
    end

    {
      highest_nps: "#{highest_nps}%",
      highest_nps_company: highest_nps_company
    }
  end

  def company_nps_f(company)
    NpsService.call(company: company).delete('%').to_f
  end
end

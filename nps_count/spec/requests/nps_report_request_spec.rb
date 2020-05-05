require 'rails_helper'

RSpec.describe 'NpsReportsController', type: :request do
  context '#index' do
    context 'When receive highest param' do
      let!(:highest_company) { Faker::Company.unique.name }

      before do
        # nps = 60%
        create_list(:answer, 7, :promoter, company: highest_company)
        create_list(:answer, 2, :passive, company: highest_company)
        create_list(:answer, 1, :detractor, company: highest_company)

        second_company = Faker::Company.unique.name
        # nps = -25%
        create_list(:answer, 5, :promoter, company: second_company)
        create_list(:answer, 5, :passive, company: second_company)
        create_list(:answer, 10, :detractor, company: second_company)

        # nps = 5%
        third_company = Faker::Company.unique.name
        create_list(:answer, 25, :promoter, company: third_company)
        create_list(:answer, 55, :passive, company: third_company)
        create_list(:answer, 20, :detractor, company: third_company)

        get('/nps_report')
      end

      it { expect(response).to have_http_status(200) }

      it {
        expect(response_body['highest']['highest_nps']).to eq('60.0%')
      }

      it {
        expect(response_body['highest']['highest_nps_company']).to eq(highest_company)
      }
    end
  end
end

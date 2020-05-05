require 'rails_helper'

RSpec.describe 'NpsController', type: :request do
  context '#index' do
    context 'When query is empty' do
      let!(:promoters_quantity) { 25 }
      let!(:passives_quantity) { 55 }
      let!(:detractors_quantity) { 20 }

      before do
        create_list(:answer, promoters_quantity, :promoter)
        create_list(:answer, passives_quantity, :passive)
        create_list(:answer, detractors_quantity, :detractor)
      end

      before do
        get('/nps')
      end

      it { expect(response).to have_http_status(200) }

      it {
        expect(response_body['nps']).to eq('5.0%')
      }
    end

    context 'When query has company and date empty' do
      let!(:company_name) { Faker::Company.unique.name }
      let!(:february_date_query) { { month: 2, year: 2020 } }
      let!(:passives_quantity) { 55 }
      let!(:detractors_quantity) { 20 }

      before do
        february_time = Time.zone.local(2020, 2, 1)

        create_list(:answer, 80, :promoter)
        create_list(:answer, 25, :passive)
        create_list(:answer, 32, :detractor)

        create_list(:answer, 7, :promoter, timestamp: february_time, company: company_name)
        create_list(:answer, 2, :passive, timestamp: february_time, company: company_name)
        create_list(:answer, 1, :detractor, timestamp: february_time, company: company_name)
      end

      before do
        get('/nps', params: { company: company_name, date: february_date_query })
      end

      it { expect(response).to have_http_status(200) }

      it {
        expect(response_body['nps']).to eq('60.0%')
      }
    end
  end
end

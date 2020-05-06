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

        get('/nps_report?type=highest')
      end

      it { expect(response).to have_http_status(200) }

      it {
        expect(response_body['highest']['highest_nps']).to eq('60.0%')
      }

      it {
        expect(response_body['highest']['highest_nps_company']).to eq(highest_company)
      }
    end

    context 'When receive stats param' do
      context 'when quantity is odd' do
        before do
          # nps = 60%
          first_company = Faker::Company.unique.name
          create_list(:answer, 7, :promoter, company: first_company)
          create_list(:answer, 2, :passive, company: first_company)
          create_list(:answer, 1, :detractor, company: first_company)

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

          get('/nps_report?type=stats')
        end

        it { expect(response).to have_http_status(200) }

        # -25, 5, 60 => 5
        it { expect(response_body['stats']['median_nps']).to eq('5.0%') }

        # (-25 + 5 + 60) / 3 => 13.33%
        it { expect(response_body['stats']['average_nps']).to eq('13.33%') }
      end

      context 'When quantity is even' do
        before do
          # nps = 60%
          first_company = Faker::Company.unique.name
          create_list(:answer, 7, :promoter, company: first_company)
          create_list(:answer, 2, :passive, company: first_company)
          create_list(:answer, 1, :detractor, company: first_company)

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

          # nps = 100%
          forty_company = Faker::Company.unique.name
          create_list(:answer, 100, :promoter, company: forty_company)
          create_list(:answer, 0, :passive, company: forty_company)
          create_list(:answer, 0, :detractor, company: forty_company)

          get('/nps_report?type=stats')
        end

        it { expect(response).to have_http_status(200) }

        # (-25 + 5 + 60 + 100) => (5 + 60) / 2
        it { expect(response_body['stats']['median_nps']).to eq('32.5%') }

        # (-25 + 5 + 60 + 100) / 4 => 35%
        it { expect(response_body['stats']['average_nps']).to eq('35.0%') }
      end
    end

    context 'When does not receive type param' do
      before do
        get('/nps_report')
      end

      it { expect(response).to have_http_status(400) }

      it { expect(response_body['error_message']).to eq('param is missing or the value is empty: type') }
    end

    context 'When does not receive param' do
      before do
        get('/nps_report?type=unknowtype')
      end

      it { expect(response).to have_http_status(400) }

      it { expect(response_body['error_message']).to eq('invalid report type') }
    end
  end
end

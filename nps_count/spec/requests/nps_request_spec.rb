require 'rails_helper'

RSpec.describe 'NpsReports', type: :request do
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
  end
end

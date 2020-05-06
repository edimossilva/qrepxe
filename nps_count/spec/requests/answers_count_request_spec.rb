require 'rails_helper'

RSpec.describe 'AnswersCountController', type: :request do
  context '#index' do
    let!(:lowest_company) { Faker::Company.unique.name }
    let!(:lowest_quantity) { 3 }

    before do
      create_list(:answer, 5, :promoter, company: Faker::Company.unique.name)

      create_list(:answer, lowest_quantity, :promoter, company: lowest_company)

      create_list(:answer, 20, :promoter, company: Faker::Company.unique.name)

      get('/answers_count')
    end

    it { expect(response).to have_http_status(200) }

    it { expect(response_body['company']).to eq(lowest_company) }

    it { expect(response_body['count']).to eq(lowest_quantity) }
  end
end

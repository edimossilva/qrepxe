require 'rails_helper'

RSpec.describe 'AnswersCountService' do
  context '#call' do
    let!(:lowest_company) { Faker::Company.unique.name }
    let!(:lowest_quantity) { 3 }

    before do
      create_list(:answer, 5, :promoter, company: Faker::Company.unique.name)

      create_list(:answer, lowest_quantity, :promoter, company: lowest_company)

      create_list(:answer, 20, :promoter, company: Faker::Company.unique.name)
    end

    subject { AnswersCountService.new.call }

    it { expect(subject[:company]).to eq(lowest_company) }

    it { expect(subject[:count]).to eq(lowest_quantity) }
  end
end

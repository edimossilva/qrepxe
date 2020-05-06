require 'rails_helper'

RSpec.describe 'Answer', type: :model do
  context '.companies' do
    let!(:companies_quantity) { 33 }

    before(:each) do
      companies_quantity.times do
        create_list(:answer, 10, company: Faker::Company.unique.name)
      end
    end

    subject { Answer.companies }

    it { expect(subject.count).to eq(companies_quantity) }
  end
end

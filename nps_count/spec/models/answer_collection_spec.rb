require 'rails_helper'

RSpec.describe 'AnswerCollection', type: :model do
  let!(:promoters_quantity) { 10 }
  let!(:passives_quantity) { 30 }
  let!(:detractors_quantity) { 60 }

  before do
    create_list(:answer, promoters_quantity, :promoter)
    create_list(:answer, passives_quantity, :passive)
    create_list(:answer, detractors_quantity, :detractor)
  end

  context '.promoters_count' do
    subject { AnswerCollection.promoters_count }

    it { expect(subject).to eq(promoters_quantity) }
  end

  context '.passives' do
    subject { AnswerCollection.passives_count }

    it { expect(subject).to eq(passives_quantity) }
  end

  context '.detractors' do
    subject { AnswerCollection.detractors_count }

    it { expect(subject).to eq(detractors_quantity) }
  end
end

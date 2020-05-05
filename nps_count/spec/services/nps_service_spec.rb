require 'rails_helper'

RSpec.describe 'NpsService' do
  context '#count_categories' do
    let!(:promoters_quantity) { 10 }
    let!(:passives_quantity) { 30 }
    let!(:detractors_quantity) { 60 }
    let!(:countTotal) { promoters_quantity + passives_quantity + detractors_quantity }

    before do
      create_list(:answer, promoters_quantity, :promoter)
      create_list(:answer, passives_quantity, :passive)
      create_list(:answer, detractors_quantity, :detractor)
    end
    subject { NpsService.new({}).count_categories }

    it { expect(subject['countPromoters']).to eq(promoters_quantity) }

    it { expect(subject['countDetractors']).to eq(detractors_quantity) }

    it { expect(subject['countTotal']).to eq(countTotal) }
  end

  context '#call' do
    context 'when nps is positive' do
      let!(:promoters_quantity) { 25 }
      let!(:passives_quantity) { 55 }
      let!(:detractors_quantity) { 20 }
      let!(:countTotal) { promoters_quantity + passives_quantity + detractors_quantity }

      before do
        create_list(:answer, promoters_quantity, :promoter)
        create_list(:answer, passives_quantity, :passive)
        create_list(:answer, detractors_quantity, :detractor)
      end

      subject { NpsService.call }

      it { expect(subject).to eq('5.0%') }
    end

    context 'when nps is negative' do
      let!(:promoters_quantity) { 50 }
      let!(:passives_quantity) { 50 }
      let!(:detractors_quantity) { 100 }
      let!(:countTotal) { promoters_quantity + passives_quantity + detractors_quantity }

      before do
        create_list(:answer, promoters_quantity, :promoter)
        create_list(:answer, passives_quantity, :passive)
        create_list(:answer, detractors_quantity, :detractor)
      end

      subject { NpsService.call }

      it {
        expect(subject).to eq('-25.0%')
      }
    end
  end
end

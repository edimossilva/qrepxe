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
    subject { NpsService.new.count_categories }

    it { expect(subject['countPromoters']).to eq(promoters_quantity) }

    it { expect(subject['countDetractors']).to eq(detractors_quantity) }

    it { expect(subject['countTotal']).to eq(countTotal) }
  end

  context '#call' do
    context 'When receive no params' do
      context 'When nps is positive' do
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

      context 'When nps is negative' do
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

    context 'When receive company params' do
      let!(:company_name) { 'Funny Happy Recruiting' }

      before do
        create_list(:answer, 10, :promoter)
        create_list(:answer, 10, :passive)
        create_list(:answer, 10, :detractor)

        create_list(:answer, 70, :promoter, company: company_name)
        create_list(:answer, 20, :passive, company: company_name)
        create_list(:answer, 10, :detractor, company: company_name)
      end

      subject { NpsService.call(company: company_name) }

      it {
        expect(subject).to eq('60.0%')
      }
    end

    context 'When receive date params' do
      before do
        january_date = Time.zone.local(2020, 1, 1)
        april_date = Time.zone.local(2020, 4, 1)

        create_list(:answer, 50, :promoter, timestamp: january_date)
        create_list(:answer, 50, :passive, timestamp: january_date)
        create_list(:answer, 50, :detractor, timestamp: january_date)

        create_list(:answer, 7, :promoter, timestamp: april_date)
        create_list(:answer, 2, :passive, timestamp: april_date)
        create_list(:answer, 1, :detractor, timestamp: april_date)
      end

      subject do
        NpsService.call(month: 4, year: 2020)
      end

      it {
        expect(subject).to eq('60.0%')
      }
    end

    context 'When receive company name and date params' do
      let!(:company_name) { 'Funny Happy Recruiting' }

      before do
        january_date = Time.zone.local(2020, 1, 1)
        april_date = Time.zone.local(2020, 4, 1)
        other_company_name = 'checkmarket'

        create_list(:answer, 50, :promoter, timestamp: january_date)
        create_list(:answer, 50, :passive, timestamp: january_date)
        create_list(:answer, 50, :detractor, timestamp: january_date)

        create_list(:answer, 88, :promoter, timestamp: january_date, company: company_name)
        create_list(:answer, 97, :passive, timestamp: april_date, company: other_company_name)
        create_list(:answer, 45, :detractor, timestamp: january_date, company: company_name)

        create_list(:answer, 7, :promoter, timestamp: april_date, company: company_name)
        create_list(:answer, 2, :passive, timestamp: april_date, company: company_name)
        create_list(:answer, 1, :detractor, timestamp: april_date, company: company_name)
      end

      subject { NpsService.call(month: 4, year: 2020, company: company_name) }

      it {
        expect(subject).to eq('60.0%')
      }
    end
  end
end

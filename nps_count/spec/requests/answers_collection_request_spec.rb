require 'rails_helper'

RSpec.describe 'AnswersCollection', type: :request do
  context '#create' do
    context 'When data is valid' do
      let!(:create_answers_params) do
        {
          _json: [
            { "grade": 7, "company": 'Experq Oy', "timestamp": '2020-04-28T11:09:42.840+03:00' },
            { "grade": nil, "company": 'Experq Oy', "timestamp": '2020-04-07T11:09:42.840+03:00' }
          ]
        }
      end

      before do
        post('/answers_collection',
             params: create_answers_params)
      end

      it {
        expect(response).to have_http_status(201)
      }

      it {
        expect(response_body['results']['n_inserted']).to eq(2)
      }
    end

    context 'When data is NOT valid (company is missing)' do
      let!(:create_answers_params) do
        {
          _json: [
            {
              "grade": nil,
              "companys": 'Experq Oy',
              "timestamp": '2020-04-28T11:09:42.840+03:00'
            },
            {
              "grade": 2,
              "company": 'Experq Oy',
              "timestamp": '2020-04-28T11:09:42.840+03:00'
            }
          ]
        }
      end
      before do
        post('/answers_collection',
             params: create_answers_params)
      end

      it {
        expect(response).to have_http_status(400)
      }

      it {
        expect(response_body['error_message']).to eq('param is missing or the value is empty: company')
      }
    end
  end
end

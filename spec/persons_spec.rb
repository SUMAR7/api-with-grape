require 'rails_helper'

RSpec.describe 'Persons', type: 'request' do
  describe 'GET /persons' do
    let!(:person) { create(:person) }

    it 'should return success code' do
      get '/api/v1/persons'
      expect(response).to have_http_status(200)
    end

    it 'should return all persons' do
      persons = Person.all
      get '/api/v1/persons'
      expect(JSON.parse(response.body)).to eq(JSON.parse(persons.to_json))
    end
  end

  describe 'GET /persons/:id' do
    let!(:person) { create(:person) }

    it 'should return 404 when we pass invalid id' do
      get '/api/v1/persons/900'
      expect(response).to have_http_status(404)
    end

    it 'should return a specific person' do
      get "/api/v1/persons/#{person.id}"
      expect(JSON.parse(response.body)['name']).to eq(person.name)
    end
  end

  describe 'POST /persons' do
    let!(:params) { {name: 'Test Name',
                     company: 'Test Company',
                     phone: '+9230212332112',
                     email: 'test@gmail.com',
                     age: 22} }

    context 'valid params' do
      it 'should create a new person' do
        post '/api/v1/persons', params: params
        expect(JSON.parse(response.body)['name']).to eq(params[:name])
      end

      it 'should return 201 status' do
        post '/api/v1/persons', params: params
        expect(response).to have_http_status(201)
      end
    end

    context 'invalid params' do
      it 'should return empty name, phone error' do
        params[:name] = ''
        params[:phone] = ''

        post '/api/v1/persons', params: params
        puts response.body.inspect # for logs
        expect(JSON.parse(response.body)['error']).to eq('name is empty, phone is empty')
      end

      it 'should return missing, name and phone error' do
        params.delete(:name)
        params.delete(:phone)

        post '/api/v1/persons', params: params
        puts response.body.inspect # for logs
        expect(JSON.parse(response.body)['error']).to eq('name is missing, name is empty, phone is missing, phone is empty')
      end
    end
  end

  describe 'PUT /persons/:id' do
    let!(:person_attrs) {attributes_for(:person)}
    let!(:person) {create(:person)}

    context 'Valid params' do
      it 'should update the existing person record' do
        person_attrs[:name] = 'Updated Name'
        put "/api/v1/persons/#{person.id}", params: person_attrs
        expect(person.reload.name).to eq(person_attrs[:name])
      end

      it 'should return success response' do
        person_attrs[:phone] = '+92121321312'
        put "/api/v1/persons/#{person.id}", params: person_attrs
        expect(response).to have_http_status(200)
      end

      it 'should return record not found 404 when invalid id is passed' do
        put '/api/v1/persons/900'
        expect(JSON.parse(response.body)['error']).to eq('Record not found')
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /persons/:id' do
    let!(:person) {create(:person)}

    context 'Valid person id' do
      it 'should delete the person' do
        delete "/api/v1/persons/#{person.id}"
        expect(JSON.parse(response.body)['message']).to eq('Person deleted successfully')
      end
    end

    context 'Invalid person id' do
      it 'should return record not found 404 when invalid id is passed' do
        delete '/api/v1/persons/900'
        expect(JSON.parse(response.body)['error']).to eq('Record not found')
        expect(response).to have_http_status(404)
      end
    end
  end
end
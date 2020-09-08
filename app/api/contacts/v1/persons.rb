module Contacts
  module V1
    class Persons < Grape::API
      # lets follow TDD
      resource :persons do
        # GET /api/v1/persons
        desc 'Return all persons'
        get do
          Person.all
        end

        # GET /api/v1/persons/:id
        desc 'Return a single person'
        route_param :id, type: Integer do
          get do
            Person.find(params[:id])
          rescue ActiveRecord::RecordNotFound
            error!('Record not found', 404)
          end
        end

        # POST /api/v1/persons
        desc 'Create a person'
        params do
          requires :name, type: String, allow_blank: false
          requires :phone, type: String, allow_blank: false
          optional :company, type: String
          optional :email, type: String
          optional :age, type: Integer
        end
        post do
          Person.create!(declared(params))
        end

        # PUT /api/v1/persons/:id
        desc 'Update a person'
        params do
          optional :name, type: String
          optional :phone, type: String
          optional :company, type: String
          optional :email, type: String
          optional :age, type: Integer
        end

        route_param :id, type: Integer do
          put do
            person = Person.find(params[:id])
            person.update(declared(params))

            {message: 'person updated successfully'}
          rescue ActiveRecord::RecordNotFound
            error!('Record not found', 404)
          end
        end

        # DELETE /api/v1/persons/:id
        desc 'Delete a person'
        route_param :id, type: Integer do
          delete do
            Person.find(params[:id]).destroy
            {message: 'Person deleted successfully'}
          rescue ActiveRecord::RecordNotFound
            error!('Record not found', 404)
          end
        end
      end
    end
  end
end
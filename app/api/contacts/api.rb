module Contacts
  class API < Grape::API
    format :json
    prefix :api
    version 'v1', :path

    mount Contacts::V1::Persons
  end
end
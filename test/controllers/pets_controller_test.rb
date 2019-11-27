require 'test_helper'
KEYS = ["id", "name", "age", "human"].sort

describe PetsController do
  describe "index" do
    # These tests are a little verbose - yours do not need to be
    # this explicit.
    it "is a real working route" do
      get pets_path
      #must_respond_with :success
      check_response(expected_type: Array)
    end
    
    it "returns json" do
      get pets_path
      expect(response.header['Content-Type']).must_include 'json'
    end

    it "responds with an array of pet hashes" do
      # Act
      get pets_path
  
      # Get the body of the response
      #body = JSON.parse(response.body)
      body = check_response(expected_type: Array)
  
      # Assert
      #expect(body).must_be_instance_of Array
      body.each do |pet|
        expect(pet).must_be_instance_of Hash
        expect(pet.keys.sort).must_equal KEYS
      end
    end

    it "will respond with an empty array when there are no pets" do
      # Arrange
      Pet.destroy_all
  
      # Act
      get pets_path
      body = check_response(expected_type: Array)
  
      # Assert
      expect(body).must_equal []
    end
  end

  describe "show" do
    it "returns a pet hash for valid pet" do
      # Arrange
      pet = Pet.first

      # Act
      get pet_path(pet)
      body = JSON.parse(response.body)

      # Assert 
      expect(body).must_be_instance_of Hash
      must_respond_with :success
      expect(body.keys.sort).must_equal KEYS

    end

    it "returns an empty hash for invalid pet and a 404 
    code" do
      # Arrange
      invalid_id = -100

      # Act
      get pet_path(invalid_id)
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Hash
      must_respond_with :not_found
    end
  end
  describe "create" do
    # pets_controller_test.rb
  describe "create" do
    let(:pet_data) {
      {
        pet: {
          age: 13,
          name: 'Stinker',
          human: 'Grace'
        }
      }
    }
    it "can create a new pet" do
      expect {
        post pets_path, params: pet_data
      }.must_change 'Pet.count', 1

      must_respond_with :created
    end

    it "will respond with bad_request for invalid data" do
      #arrange
      pet_data[:pet][:age] = nil

      expect{post pets_path, params: pet_data}.wont_change "Pet.count"

      must_respond_with :bad_request
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "age"
    end


  end
  end
end

  #   it "returns an Array" do
  #     get pets_path

  #     body = JSON.parse(response.body)
  #     body.must_be_kind_of Array
  #   end

  #   it "returns all of the pets" do
  #     get pets_path

  #     body = JSON.parse(response.body)
  #     body.length.must_equal Pet.count
  #   end

  #   it "returns pets with exactly the required fields" do
  #     keys = %w(age human id name)
  #     get pets_path
  #     body = JSON.parse(response.body)
  #     body.each do |pet|
  #       pet.keys.sort.must_equal keys
  #     end
  #   end
  # end

  # describe "show" do
  #   # This bit is up to you!
  #   it "can get a pet" do
  #     get pet_path(pets(:two).id)
  #     must_respond_with :success
  #   end
  # end

  # describe "create" do
  #   let(:pet_data) {
  #     {
  #       name: "Jack",
  #       age: 7,
  #       human: "Captain Barbossa"
  #     }
  #   }

  #   it "creates a new pet given valid data" do
  #     expect {
  #     post pets_path, params: { pet: pet_data }
  #   }.must_change "Pet.count", 1

  #     body = JSON.parse(response.body)
  #     expect(body).must_be_kind_of Hash
  #     expect(body).must_include "id"

  #     pet = Pet.find(body["id"].to_i)

  #     expect(pet.name).must_equal pet_data[:name]
  #     must_respond_with :success
  #   end

  #   it "returns an error for invalid pet data" do
  #     # arrange
  #     pet_data["name"] = nil

  #     expect {
  #     post pets_path, params: { pet: pet_data }
  #   }.wont_change "Pet.count"

  #     body = JSON.parse(response.body)

  #     expect(body).must_be_kind_of Hash
  #     expect(body).must_include "errors"
  #     expect(body["errors"]).must_include "name"
  #     must_respond_with :bad_request
  #   end



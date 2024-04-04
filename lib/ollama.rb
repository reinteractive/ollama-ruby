require 'httparty'
require_relative './ollama_generate_schema'

module Ollama
  class ApiClient
    include HTTParty
    format :json

    # Constructor with keyword arguments for enhanced flexibility
    def initialize(host: 'localhost', port: 11434, timeout: 60)
      self.class.base_uri "http://#{host}:#{port}/api"
      @options = { timeout: timeout }
    end

    # Generate text using the specified options
    def generate(options:)
      validate_options!(options) # Ensure options are valid
      response = safe_post_request('/generate', options)
      handle_response(response) # Process and return the response appropriately
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    # Chat with a model using the specified options
    def chat(options:)
      validate_options!(options) # Ensure options are valid
      response = safe_post_request('/chat', options)
      handle_response(response) # Process and return the response appropriately
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    # Retrieves a list of local models available in the API
    def list_local_models
      response = safe_get_request('/tags')
      handle_response(response) # Process and return the response appropriately
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    # Shows detailed information about a specific model
    def show_model_information(name:)
      validate_name!(name) # Ensure the model name is valid
      response = safe_post_request('/show', { name: name })
      handle_response(response) # Process and return the response appropriately
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    # Creates a new model with the specified options
    def create_model(options:)
      validate_options!(options) # Ensure options are valid
      response = safe_post_request('/create', options)
      handle_response(response) # Process and return the response appropriately
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    # Copies a model from source to destination
    def copy_model(source:, destination:)
      validate_names!(source, destination) # Ensure model names are valid
      options = { source: source, destination: destination }
      response = safe_post_request('/copy', options)
      handle_response(response) # Process and return the response appropriately
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    # Deletes a model by name
    def delete_model(name:)
      validate_name!(name) # Ensure the model name is valid
      response = safe_delete_request('/delete', { name: name })
      handle_response(response) # Process and return the response appropriately
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    # Pulls a model by name, with optional parameters
    def pull_model(name:, options: {})
      validate_name!(name) # Ensure the model name is valid
      body = { name: name }.merge(options)
      response = safe_post_request('/pull', body)
      handle_response(response) # Process and return the response appropriately
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    # Pushes a model by name, with optional parameters
    def push_model(name:, options: {})
      validate_name!(name) # Ensure the model name is valid
      body = { name: name }.merge(options)
      response = safe_post_request('/push', body)
      handle_response(response) # Process and return the response appropriately
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    # Example method with improved error handling and input validation
    def generate_embeddings(model:, prompt:, options: {})
      validate_model_and_prompt!(model, prompt) # Validate inputs
      body = { model: model, prompt: prompt }.merge(options)
      
      response = safe_post_request('/embeddings', body)
      response.parsed_response['embedding']
    rescue => e
      handle_error(e) # Gracefully handle and log errors
    end

    private

    # Validates that options hash is not empty
    def validate_options!(options)
      validation = GenerateSchema.call(options)
      raise ArgumentError, validation.errors.to_h.inspect unless validation.success?
    end

    # Handles HTTP POST requests with error handling and retries
    def safe_post_request(endpoint, options)
      retries ||= 0
      response = self.class.post(endpoint, body: options.to_json, headers: { 'Content-Type' => 'application/json' }, **@options)
    rescue Net::ReadTimeout, Net::OpenTimeout => e
      (retries += 1) <= 3 ? retry : raise("Request to #{endpoint} failed after 3 attempts: #{e.message}")
    rescue HTTParty::Error => e
      raise "HTTP error occurred: #{e.message}"
    rescue => e
      raise "Unexpected error: #{e.message}"
    else
      response
    end

    # Example response handler for processing API responses
    def handle_response(response)
      unless response.ok?
        raise "API Error: #{response.code} #{response.message}"
      end
      response.parsed_response
    end

    # Example error handler method for logging and managing errors
    def handle_error(error)
      # Implement logging, notification, etc.
      puts "An error occurred: #{error.message}"
    end
  end
end

client = Ollama::ApiClient.new(host: 'localhost', port: 11434, timeout: 60)
client.generate(options: {model: 'llama2', prompt: 'Hi', stream: false})
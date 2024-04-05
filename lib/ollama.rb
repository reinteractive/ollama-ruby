# frozen_string_literal: true

require_relative "ollama/version"

module Ollama
  class Error < StandardError; end

  autoload :ApiClient, 'ollama/api_client'
end

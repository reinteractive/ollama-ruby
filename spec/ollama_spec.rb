# frozen_string_literal: true

RSpec.describe Ollama do
  it "has a version number" do
    expect(Ollama::VERSION).not_to be nil
  end
end

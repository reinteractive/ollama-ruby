# frozen_string_literal: true

RSpec.describe Ollama::ApiClient do
  let(:client) { described_class.new }

  let(:model_name) { 'mario' }

  let(:creation_options) do
    { name: "mario", modelfile: "FROM llama2\nSYSTEM You are mario from Super Mario Bros.", stream: false }
  end

  let(:generate_options) do
    {
      model: model_name,
      prompt: 'What is the name of your brother?',
      format: 'json',
      stream: false
    }
  end

  let(:chat_options) do
    {
      model: 'mario',
      stream: false,
      messages: [
        {
          role: 'user',
          content: 'What is the name of you brother?'
        },
        {
          role: "assistant",
          content: "Woah, easy question! My broth- er, my brother's name is Luigi! *adjusts cap* He's always gettin' into trouble, but I've got his back. We make a great team, him and me!"
        },
        {
          role: 'user',
          content: 'What you do to live?'
        }
      ]
    }
  end

  let(:pull_model_options) {
    { stream: false }
  }

  let(:embeddings_prompt) {
    'Here is a little piece of information about the Princess. She is not in this castle.'
  }

  describe '#create_model' do
    let(:response) { client.create_model(options: creation_options) }

    it 'returns a hash' do
      VCR.use_cassette('create_model') do
        expect(response).to be_a(Hash)
      end
    end

    it 'the hash has the key status' do
      VCR.use_cassette('create_model') do
        expect(response.keys.last).to eq('status')
      end
    end

    it 'the key status have the value "success"' do
      VCR.use_cassette('create_model') do
        expect(response['status']).to eq('success')
      end
    end

    context 'for an unknown error' do
      xit 'raise a RuntimeError' do
        allow_any_instance_of(Ollama::ApiClient)
          .to receive(:safe_post_request)
          .and_raise(RuntimeError, 'boommm')

        expect{ response }.to raise_error(RuntimeError, /boommm/)
      end
    end
  end

  describe '#generate' do
    context 'with valid options' do
      let(:response) { client.generate(options: generate_options) }

      it 'returns a Hash' do
        VCR.use_cassette('generate') do
          expect(response).to be_a(Hash)
        end
      end

      %w[model response done context total_duration load_duration prompt_eval_count prompt_eval_duration eval_count].each do |key|
        it "the response has the #{key} key" do
          VCR.use_cassette("generate") do
            expect(response.keys).to include(key)
          end
        end
      end
    end
  end

  describe '#list_local_models' do
    let(:response) { client.list_local_models }

    it 'returns a hash' do
      VCR.use_cassette("list_local_models") do
        expect(response).to be_a(Hash)
      end
    end

    it 'has the key "models"' do
      VCR.use_cassette("list_local_models") do
        expect(response['models']).to be_an(Array)
      end
    end

    it 'the model key returned has specific keys' do
      VCR.use_cassette("list_local_models") do
        expect(response['models'].last.keys).to eq(%w[name model modified_at size digest details])
      end
    end
  end

  describe '#show_model_information' do
    let(:response) { client.show_model_information(name: model_name) }

    it 'returns a hash' do
      VCR.use_cassette('show_model_information') do
        expect(response).to be_a(Hash)
      end
    end

    it 'has specific keys' do
      VCR.use_cassette("show_model_information") do
        expect(response.keys).to eq(%w[license modelfile parameters template system details])
      end
    end
  end

  describe '#copy_model' do
    let(:models_list) { client.list_local_models }

    it 'copy the model' do
      VCR.use_cassette('copy_model') do
        VCR.use_cassette('local_model_backup') do
          client.copy_model(source: 'mario:latest', destination: 'mario:latest-backup')

          copied_model = models_list['models'].find { |model| model['name'].eql?('mario:latest-backup') }

          expect(copied_model).not_to be_nil
        end
      end
    end
  end

  describe '#delete_model' do
    let(:models_list) { client.list_local_models }

    it 'delete a model' do
      VCR.use_cassette('delete_model') do
        client.delete_model(name: 'mario:latest-backup')

        VCR.use_cassette('local_models_after_delete') do
          model = models_list['models'].find { |model| model['name'].eql?('mario:latest-backup') }

          expect(model).to be_nil
        end
      end
    end
  end

  describe '#chat' do
    let(:response) { client.chat(options: chat_options) }

    it 'returns a hash' do
      VCR.use_cassette('basic_chat') do
        expect(response).to be_a(Hash)
      end
    end

    it 'has specific keys' do
      VCR.use_cassette("basic_chat") do
        expect(response.keys).to eq(%w[model created_at message done total_duration load_duration prompt_eval_duration eval_count eval_duration])
      end
    end
  end

  describe '#pull_model' do
    let(:response) { client.pull_model(name: 'llama2:latest', options: pull_model_options) }

    it 'returns a hash' do
      VCR.use_cassette('pull_model') do
        expect(response).to be_a(Hash)
      end
    end

    it 'the hash has the key status' do
      VCR.use_cassette('pull_model') do
        expect(response.keys.last).to eq('status')
      end
    end

    it 'the key status have the value "success"' do
      VCR.use_cassette('pull_model') do
        expect(response['status']).to eq('success')
      end
    end
  end

  describe '#generate_embeddings' do
    let(:response) { client.generate_embeddings(model: 'mario:latest', prompt: embeddings_prompt) }

    it 'returns an array' do
      VCR.use_cassette('embeddings') do
        expect(response).to be_an(Array)
      end
    end
  end
end

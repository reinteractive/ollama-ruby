# Ollama-ruby

Here we have a simple wrapper for the [Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md). We covered almost all the endpoints and we still working to improve some parts.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ollama_ruby

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ollama_ruby

## Usage

After install the gem, you can create a new client and interact with the Ollama endpoints already implemented like the example below:

```ruby
    # host: 'http://localhost', port: 11434, timeout: 60
    client = Ollama::ApiClient.new

    client.list_local_models # it'll returns something like this:
    {
        "models"=>
        [{
            "name"=>"llama2:latest",
            "model"=>"llama2:latest",
            "modified_at"=>"2024-04-05T23:19:28.167292344-03:00",
            "size"=>3826793677,
            "digest"=>"78e26419b4469263f75331927a00a0284ef6544c1975b826b15abdaef17bb962",
            "details"=>{
                "parent_model"=>"", "format"=>"gguf", "family"=>"llama", "families"=>["llama"], "parameter_size"=>"7B", "quantization_level"=>"Q4_0"
            }
        }]
    }
```

The covered endpoints now are:
* Generate a completion
* Generate a chat completion
* Create a Model
* List Local Models
* Show Model Information
* Copy a Model
* Delete a Model
* Pull a Model
* Generate Embeddings

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/reinteractive/ollama-ruby.

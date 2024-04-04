require 'dry-schema'

# Define the schema for the options hash
OptionsSchema = Dry::Schema.Params do
  optional(:mirostat).value(included_in?: [0, 1, 2])
  optional(:mirostat_eta).value(:float)
  optional(:mirostat_tau).value(:float)
  optional(:num_ctx).value(:integer)
  optional(:num_gqa).value(:integer)
  optional(:num_gpu).value(:integer)
  optional(:num_thread).value(:integer)
  optional(:repeat_last_n).value(:integer)
  optional(:repeat_penalty).value(:float)
  optional(:temperature).value(:float)
  optional(:seed).value(:integer)
  optional(:stop).value(:string)
  optional(:tfs_z).value(:float)
  optional(:num_predict).value(:integer)
  optional(:top_k).value(:integer)
  optional(:top_p).value(:float)
end

# Update the GenerateSchema to include the options validation
GenerateSchema = Dry::Schema.Params do
  required(:model).filled(:string)
  optional(:prompt).maybe(:string)
  optional(:images).maybe { array? & each(:string) }
  optional(:format).value(included_in?: ['json'])
  optional(:options).maybe { hash? & schema(OptionsSchema) }
  optional(:system).maybe(:string)
  optional(:template).maybe(:string)
  optional(:context).maybe(:string)
  optional(:stream).maybe(:bool)
  optional(:raw).maybe(:bool)
  optional(:keep_alive).maybe(:string)
end
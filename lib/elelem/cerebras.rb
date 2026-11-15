# frozen_string_literal: true

require "elelem/openai"

require_relative "cerebras/version"

Elelem.configure do |config|
  config.provider(:cerebras) do |model: nil, **|
    # A variable that is set but empty counts as unset.
    env = ->(name) { ENV[name].to_s.strip.then { |v| v.empty? ? nil : v } }
    key = env.call("CEREBRAS_API_KEY")
    raise KeyError, "CEREBRAS_API_KEY is not set" if key.nil?

    model = env.call("CEREBRAS_MODEL") if model.to_s.strip.empty?
    raise KeyError, "CEREBRAS_MODEL is not set. Pass --model or set CEREBRAS_MODEL" if model.nil?

    Elelem::OpenAI::Provider.new(
      model:,
      api_key: key,
      base_url: env.call("CEREBRAS_BASE_URL") || "https://api.cerebras.ai/v1"
    )
  end
end

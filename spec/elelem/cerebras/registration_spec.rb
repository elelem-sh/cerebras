# frozen_string_literal: true

RSpec.describe "the cerebras provider" do
  around do |example|
    saved = ENV.to_h.slice("CEREBRAS_API_KEY", "CEREBRAS_BASE_URL", "CEREBRAS_MODEL")
    example.run
  ensure
    %w[CEREBRAS_API_KEY CEREBRAS_BASE_URL CEREBRAS_MODEL].each { |k| ENV.delete(k) }
    ENV.update(saved)
  end

  before do
    ENV["CEREBRAS_API_KEY"] = "test-key"
    ENV["CEREBRAS_MODEL"] = "env-model"
    ENV.delete("CEREBRAS_BASE_URL")
  end

  def build(**) = Elelem::Config.build_provider("cerebras", **)
  def uri(**) = build(**).instance_variable_get(:@uri).to_s
  def model(**) = build(**).instance_variable_get(:@model)

  it "registers provider cerebras" do
    expect(Elelem::Config.names).to include("cerebras")
    expect(build).to be_a(Elelem::OpenAI::Provider)
  end

  it "talks to Cerebras by default" do
    expect(uri).to eq("https://api.cerebras.ai/v1/chat/completions")
  end

  it "sends CEREBRAS_API_KEY" do
    expect(build.instance_variable_get(:@api_key)).to eq("test-key")
  end

  it "names CEREBRAS_API_KEY when the key is missing or empty" do
    ENV.delete("CEREBRAS_API_KEY")
    expect { build }.to raise_error(KeyError, /CEREBRAS_API_KEY/)

    ENV["CEREBRAS_API_KEY"] = " "
    expect { build }.to raise_error(KeyError, /CEREBRAS_API_KEY/)
  end

  it "names CEREBRAS_MODEL when no model is set, and treats an empty one as unset" do
    ENV.delete("CEREBRAS_MODEL")
    expect { build }.to raise_error(KeyError, /CEREBRAS_MODEL/)

    ENV["CEREBRAS_MODEL"] = ""
    expect { build }.to raise_error(KeyError, /CEREBRAS_MODEL/)
  end

  it "takes the model from CEREBRAS_MODEL" do
    expect(model).to eq("env-model")
  end

  it "prefers --model over CEREBRAS_MODEL" do
    expect(model(model: "flag-model")).to eq("flag-model")
  end

  it "uses CEREBRAS_BASE_URL, with or without a trailing slash, and treats an empty one as unset" do
    ENV["CEREBRAS_BASE_URL"] = "http://127.0.0.1:8080/v1/"
    expect(uri).to eq("http://127.0.0.1:8080/v1/chat/completions")

    ENV["CEREBRAS_BASE_URL"] = "http://127.0.0.1:8080/v1"
    expect(uri).to eq("http://127.0.0.1:8080/v1/chat/completions")

    ENV["CEREBRAS_BASE_URL"] = ""
    expect(uri).to eq("https://api.cerebras.ai/v1/chat/completions")
  end
end

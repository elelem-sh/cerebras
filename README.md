# elelem-cerebras

A [Cerebras](https://cloud.cerebras.ai) provider plugin for [elelem](https://elelem.sh).
It talks to Cerebras's OpenAI-compatible Chat Completions API
through [elelem-openai](https://github.com/elelem-sh/openai).

## Install

```sh
gem install elelem-cerebras
```

## Use

```sh
export CEREBRAS_API_KEY=...
elelem -p cerebras --model MODEL
```

* `CEREBRAS_API_KEY` (required): get one at https://cloud.cerebras.ai
* `CEREBRAS_MODEL`: the model, when `--model` is not given
* `CEREBRAS_BASE_URL`: overrides `https://api.cerebras.ai/v1`

There is no default model, since free model lists change often. With
no model set, elelem stops and names `CEREBRAS_MODEL`. A variable that is
set but empty counts as unset.

Free tier limits are on Cerebras's own page: https://inference-docs.cerebras.ai/support/rate-limits

## Development

```sh
bin/setup
bin/test
bin/lint
```

## License

MIT. See LICENSE.txt.

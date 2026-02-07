#!/bin/bash

pip install llm
llm install llm-openrouter
llm models default openrouter/x-ai/grok-4-fast:free

echo "Run 'llm keys set openrouter' to configure Openrouter as your default model!"
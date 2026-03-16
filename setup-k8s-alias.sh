#!/bin/bash

# 1. Install bash-completion
sudo apt update && sudo apt install -y bash-completion

# 2. Add kubectl completion logic
if ! grep -q "kubectl completion bash" ~/.bashrc; then
  echo 'source <(kubectl completion bash)' >> ~/.bashrc
fi

# 3. Add alias 'k' and its completion logic
if ! grep -q 'alias k="kubectl"' ~/.bashrc; then
  echo 'alias k="kubectl"' >> ~/.bashrc
  echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc
fi

# 4. Reload configuration
source ~/.bashrc

echo "✅ 'k' alias and autocompletion are ready!"
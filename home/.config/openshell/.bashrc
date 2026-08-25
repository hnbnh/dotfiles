# Agents run their commands through non-interactive bash, where mise's prompt
# hook never fires; shims resolve a project's tools at call time instead.
if [[ $- != *i* ]]; then
  eval "$(mise activate bash --shims)"
  return
fi

eval "$(mise activate bash)"

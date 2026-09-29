#!/bin/bash
# UserPromptSubmit hook: when the session context is large, tell the model to suggest /compact or /clear.
# Context size = input + cache_read + cache_creation tokens of the last main-thread assistant message.
limit=${CLAUDE_CONTEXT_WARN_TOKENS:-150000}
path=$(jq -r '.transcript_path // empty')
[ -r "$path" ] || exit 0
tokens=$(tail -n 200 "$path" | jq -s 'map(select(.type=="assistant" and (.isSidechain|not) and .message.usage!=null)) | last | .message.usage | (.input_tokens + .cache_read_input_tokens + .cache_creation_input_tokens) // 0' 2>/dev/null)
[ "${tokens:-0}" -gt "$limit" ] && echo "Context is about $((tokens / 1000))k tokens. Before answering, briefly tell the user to /compact (same task) or /clear (new task)."
exit 0

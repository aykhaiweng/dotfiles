# bash-lsp

Gives Claude Code a shell-script language server (bash-language-server), so it
can find function definitions and references in `.sh`/`.bash` files instead
of grepping for them. Files with no extension (`.zshrc`, `.sharedrc`) are not
matched.

The server config lives in `../../.claude-plugin/marketplace.json`; this
directory only exists because each plugin needs a source path.

Requires `bash-language-server` on `PATH` (`npm i -g bash-language-server`).
Lint warnings also need `shellcheck`. Installed by `init/64_setup_lsp_servers.sh`.

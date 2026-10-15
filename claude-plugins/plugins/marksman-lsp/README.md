# marksman-lsp

Gives Claude Code a Markdown language server, so it can jump to headings, find
every link to a section, and flag broken links instead of grepping for them.

The server config lives in `../../.claude-plugin/marketplace.json`; this
directory only exists because each plugin needs a source path.

Requires `marksman` on `PATH` (`brew install marksman`, which also pulls in
the .NET runtime). Installed by `init/64_setup_lsp_servers.sh`.

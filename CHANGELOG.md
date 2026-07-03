# Changelog

All notable changes to this template are documented here.

**Versioning:** CalVer (YY.MM). Git commits provide granularity within a release.

------------------------------------------------------------------------

- Added optional Zotero MCP integration: Librarian, Explorer, and their paired critics can now consult a connected `zotero-mcp` server as a supplementary search/verification method alongside their existing web-based search. Read-only for critics and Explorer; Librarian additionally gets user-gated add-to-library tools. See `.claude/references/zotero-search-protocol.md`. Also fixed a stale `mcp__zotero__*` tool-prefix reference in the `/discover` skill (correct prefix is `mcp__zotero-mcp__*`).

<!-- Add new entries above this line -->

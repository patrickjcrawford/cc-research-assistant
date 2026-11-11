# Zotero MCP Search Protocol

Shared reference for how the Librarian, Explorer, and their paired critics use the `zotero-mcp` server. Read this instead of re-deriving tool names or degradation behavior — each agent's own file only states its role-specific usage.

This is an **additive, supplementary** capability. It never replaces the existing web-based Search Protocol (Librarian) or Search for Data Sources (Explorer) — those always run in full regardless of whether Zotero is available.

---

## Prerequisites

Zotero MCP tools require the Zotero desktop app running with local API access enabled (`Tools → Developer → Allow other applications to communicate with Zotero`).

**ASSUMPTION (unverified):** it is not confirmed whether `zotero-mcp` can also operate against the Zotero Web API with the desktop app closed. Treat the desktop-app requirement as the known-working path; do not assert a desktop-less mode works.

**Tool prefix:** all tools are `mcp__zotero-mcp__*` (hyphenated `zotero-mcp`, matching the connected server's actual name). Do not use `mcp__zotero__*` — that prefix does not correspond to any connected server.

---

## Tool Surface by Role

| Role | Read/Search tools | Add tools | Excluded |
|------|-------------------|-----------|----------|
| **librarian** | `zotero_search_items`, `zotero_semantic_search`, `zotero_advanced_search`, `zotero_search_by_tag`, `zotero_search_by_citation_key`, `zotero_search_collections`, `zotero_get_collections`, `zotero_get_collection_items`, `zotero_get_item_metadata`, `zotero_get_item_fulltext`, `zotero_find_related_papers`, `zotero_export_bibliography`, `zotero_get_recent`, `zotero_library_coverage` | `zotero_add_by_doi`, `zotero_add_by_url` — **user-request-gated, see below** | All `zotero_create_*`, `zotero_update_*`, `zotero_delete_*`, `zotero_merge_duplicates`, `zotero_batch_update_*`, `zotero_add_by_isbn`, `zotero_add_by_bibtex`, `zotero_add_by_csl_json`, `zotero_add_from_file` |
| **librarian-critic** | `zotero_get_item_metadata`, `zotero_search_items`, `zotero_search_by_citation_key`, `zotero_find_related_papers`, `scite_check_retractions` | None | All write-capable tools, and all `*_add_*` tools |
| **explorer** | `zotero_search_items`, `zotero_search_notes`, `zotero_get_notes`, `zotero_synthesize_annotations`, `zotero_search_by_tag` | None | All write-capable tools, all `*_add_*` tools |
| **explorer-critic** | `zotero_get_item_metadata`, `zotero_search_items`, `zotero_search_by_citation_key`, `zotero_find_related_papers`, `scite_check_retractions` | None | All write-capable tools |

All tool names above take the `mcp__zotero-mcp__` prefix (e.g. `mcp__zotero-mcp__zotero_search_items`). This table must match each agent's frontmatter `tools:` grant exactly — if you add or remove a tool for a role, update both places.

---

## Graceful Degradation

If a `mcp__zotero-mcp__*` call errors, times out, or the tools are simply absent from the environment (server not connected/authorized), note **"Zotero library not available this session"** once in your output and continue with your normal method unmodified. Never block, retry indefinitely, or degrade the rest of your output because Zotero is unavailable. This mirrors the existing Obsidian MCP precedent (`.claude/state/obsidian-config.md.example`, referenced from `workflow.md`).

### Known failure signatures

| Symptom | Cause | What to do |
|---------|-------|------------|
| `[WinError 10061]` / connection refused | Zotero desktop app is closed | Ask the user to open Zotero, then retry once. Do not silently fall back to web search for a library question. |
| `zotero_read_pdf_pages` says a PDF is a "scanned image" | Many JSTOR-style PDFs have an invisible OCR text layer the tool misses (~1 in 9 items in one library) | Read the local file before accepting it: `pdftotext -enc UTF-8 ~/Zotero/storage/<KEY>/<file>.pdf -` or PyMuPDF. |
| First `zotero_semantic_search` hangs (up to the 30-minute timeout) and later calls queue behind it | Index build on first use | Prefer collection listing or keyword search; if you use semantic search, phrase specifically and judge results by relative rank — recall is weak across a multi-project library. |
| Long session memory growth | zotero-mcp process leak; each restored editor session spawns another | Mention it to the user if the machine slows; don't restart services yourself. |

### Local fallbacks (read-only)

When an MCP call times out but the desktop app is running:
- PDFs: `~/Zotero/storage/<KEY>/` — read with `pdftotext -enc UTF-8` or the Read tool.
- Local API: `curl.exe "http://127.0.0.1:23119/api/users/0/items?q=<terms>"` (PowerShell's
  `Invoke-WebRequest` fails against it on Windows).
- Better BibTeX JSON-RPC (`item.citationkey`, `item.export`) at `http://127.0.0.1:23119/better-bibtex/json-rpc`.
  Better BibTeX export output counts as "exported from Zotero" for `references.bib`.

Quote and verify from the original-language PDF, never a machine-translation attachment
(`citation-practice.md` CP-3).

---

## Generic Usage Protocol

1. **Probe:** make one lightweight, targeted call relevant to the task (e.g. `zotero_search_items` with extracted key terms, or `zotero_get_item_metadata` for a specific citation under review).
2. **Fold in on success:** merge results into your existing workflow. Dedupe against web-search hits by DOI or title — never double-report the same paper as both a web result and a Zotero result.
3. **Degrade on failure:** if the call fails or tools are absent, log unavailability once (see above) and proceed with your existing method only.
4. **Always supplementary:** Zotero is a second lookup path, never a substitute for the web-based protocol already defined in each agent's own file.

---

## Librarian Add-Only Rule

`zotero_add_by_doi` and `zotero_add_by_url` may only be invoked when the user explicitly asks, in that turn, to save a paper to their Zotero library (e.g. "add this to my Zotero" / "save these to Zotero"). Never call them proactively as part of the routine Search Protocol, no matter how relevant a newly found paper is. When in doubt, ask before adding.

---

## Relationship to `/discover` Skill-Level Zotero Sync

`.claude/skills/discover/SKILL.md` (`/discover lit` Step 0, `/discover zotero` mode) implements a separate CLI/export bridge (`zotero-cli` → `reference_docs/supporting/zotero_export.bib`) for contexts where the Librarian agent has no direct MCP tool access (e.g. a `zotero-cli`-only environment like Positron). That mechanism is unchanged by this protocol and is safe to run alongside it — downstream dedup by DOI/title handles any overlap. This protocol governs direct in-agent tool calls when the agent itself has `mcp__zotero-mcp__*` tools in its own toolset.

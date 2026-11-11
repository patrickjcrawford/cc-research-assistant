# Windows Environment — Known Quirks

Fork-owned reference. The template is developed and used on Windows (Git Bash + PowerShell tools,
Positron/VS Code). Each item below broke real work at least once. Read before running shell commands
that involve backslashes, R, Python, encodings, or LaTeX.

---

## Shells

- **Git Bash heredocs halve backslashes.** LaTeX, Lua, and regex written through `cat <<EOF` or
  `python - <<EOF` lose `\`. Write such files with the Write/Edit tools, use POSIX character classes, or
  build the backslash with `chr(92)`.
- **MSYS path conversion** mangles arguments like `branch:path/to/file` (`git show`) — prefix with
  `MSYS_NO_PATHCONV=1`.
- **PowerShell:** no `grep` (use `Select-String` or the Grep tool), no `\` line continuation (backtick),
  env vars are `$env:NAME = "x"`, and `Invoke-WebRequest` fails against local services such as Zotero —
  use `curl.exe`. PowerShell 7 (`pwsh`) cannot load `System.Drawing`; use Windows PowerShell 5.1 for that.
- Lines containing LaTeX macros can trip the delete-safety check in PowerShell; prefer the Write tool.
- `rm -f "$VAR"/*` patterns are blocked; delete named files.
- A `cd` into another session working directory persists in the Bash tool — use absolute paths or
  `cd` explicitly at the start of each command.
- The console mangles non-ASCII (umlauts, accents). Dump text to a UTF-8 file and read it with the
  Read tool instead of printing it.

## R

- `Rscript` may not be on PATH. Use the path in CLAUDE.md § Setup; when several R versions coexist,
  use the one recorded there — never guess a version folder under `C:\Program Files\R\`.
  Bash: `"/c/Program Files/R/R-x.y.z/bin/Rscript.exe"` · PowerShell: `& "C:\Program Files\R\R-x.y.z\bin\Rscript.exe"`.
- Multi-line `Rscript -e "..."` can segfault — write a scratch `.R` file and run it.
- Spatial R (`sf`, `terra`) launched from Git Bash has segfaulted (exit 139) intermittently — run it from
  the PowerShell tool.
- Check free RAM before heavy fits: `Get-CimInstance Win32_OperatingSystem | Select FreePhysicalMemory`.

## Python

- Bare `python` / `python3` may be a dead pyenv-win shim or a uv shim that is not the project
  environment. Run project code with `uv run python` (`pyproject.toml` at the root); `python3` is only
  for the template's own hook and gate scripts.
- Tests and gate scripts need `PYTHONUTF8=1` (the pre-commit hook sets it).
- Always pass `encoding="utf-8"` to `open()`; the cp1252 default silently corrupts Unicode. Notebook
  JSON: `json.dump(nb, f, ensure_ascii=False, indent=1)` with `encoding="utf-8"`.
- `huggingface-cli` is deprecated — use `hf`.

## Files and encodings

- CSVs for Excel are UTF-8 **with BOM** (`readr::write_excel_csv`, `utf-8-sig`) — EP-14.
- Some `.qmd` files are CRLF. When rewriting one in Python, open with `newline=""` and keep its endings.
- No symlinks (they need admin rights or developer mode); copy instead.

## LaTeX and editors

- Quarto renders with its own TeX (TinyTeX/TeX Live). An error mentioning **MiKTeX, latexmk, or Perl**
  never comes from Quarto — it comes from the editor's LaTeX Workshop extension auto-building a kept
  `.tex`. Do not install Perl; set `"latex-workshop.latex.autoBuild.run": "never"`.
- The first render after a TeX update can take several minutes while packages install.
- Xpdf `pdftotext` has no crop flags; use `-layout` and grep.

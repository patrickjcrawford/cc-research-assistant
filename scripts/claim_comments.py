#!/usr/bin/env python3
"""claim_comments.py — index the inline CLAIM comments in the manuscript.

clo-author: infrastructure-fork (not analysis code; explainer_status.py skips it)

Writers can record provenance next to the sentence it backs:

    ...the effect persists for a decade. <!--# CLAIM 🟢 jones2019LongRun p. 12: "..." -->

This script collects every such comment from paper/main.qmd and paper/sections/*.qmd into
quality_reports/claim_index.md (file, line, the sentence backed, marker, source note), so the
inline notes and the claim-source map (INV-22, INV-27) cannot drift apart unnoticed. It also lists
citation keys in the prose that have no CLAIM comment and no row in a claim_source_map_*.md file.

paper/claim-margin.lua renders the same comments as margin notes for a review PDF:
    quarto render paper/main.qmd -M annotate-claims:true -o main_claims.pdf

Usage:
    python3 scripts/claim_comments.py            # write quality_reports/claim_index.md
    python3 scripts/claim_comments.py --check    # exit 1 if any comment lacks a valid marker
"""
from __future__ import annotations

import argparse
import datetime as dt
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CLAIM = re.compile(r"<!--#\s*CLAIM\s*(.*?)\s*-->")
ANY_COMMENT = re.compile(r"<!--.*?-->")
CITEKEY = re.compile(r"(?<![\w.@-])@([A-Za-z][\w:.-]*\w)")
CROSSREF = re.compile(r"^(fig|tbl|sec|eq|lst|thm|lem)-")
MARKERS = {"🟢": "direct", "🟠": "synthesis", "🔵": "author-attested",
           "🟣": "author-vouched (partial support)", "⚪": "design/definition", "[NOT": "not verified"}


def manuscript_files() -> list[Path]:
    files = [ROOT / "paper" / "main.qmd"]
    files += sorted((ROOT / "paper" / "sections").glob("*.qmd"))
    return [f for f in files if f.exists()]


def last_sentence(text: str) -> str:
    text = ANY_COMMENT.sub("", text).strip()
    parts = re.split(r"(?<=[.!?])\s+", text)
    return parts[-1][:220].replace("|", "/") if parts else ""


def collect() -> list[dict]:
    rows = []
    for f in manuscript_files():
        for i, line in enumerate(f.read_text(encoding="utf-8").splitlines(), start=1):
            pieces = CLAIM.split(line)
            # split() alternates text, note, text, note, ...
            for j in range(1, len(pieces), 2):
                note = pieces[j].strip()
                marker = note.split()[0] if note else ""
                rows.append({
                    "file": f.relative_to(ROOT).as_posix(),
                    "line": i,
                    "claim": last_sentence(pieces[j - 1]),
                    "marker": marker,
                    "valid": any(marker.startswith(m) for m in MARKERS),
                    "source": note[len(marker):].strip().replace("|", "/"),
                })
    return rows


def uncovered_keys(rows: list[dict]) -> list[str]:
    prose_keys: set[str] = set()
    for f in manuscript_files():
        body = ANY_COMMENT.sub("", f.read_text(encoding="utf-8"))
        prose_keys |= {k for k in CITEKEY.findall(body) if not CROSSREF.match(k)}
    noted = {k for r in rows for k in CITEKEY.findall("@" + r["source"].replace(" ", " @"))}
    noted |= {w for r in rows for w in re.findall(r"[A-Za-z][\w:.-]*\w", r["source"])}
    mapped: set[str] = set()
    for m in (ROOT / "quality_reports").glob("claim_source_map_*.md"):
        mapped |= set(re.findall(r"[A-Za-z][\w:.-]*\w", m.read_text(encoding="utf-8")))
    return sorted(prose_keys - noted - mapped)


def write_index(rows: list[dict], missing: list[str]) -> Path:
    out = ROOT / "quality_reports" / "claim_index.md"
    lines = [
        "# Inline Claim Index",
        "",
        f"**Generated:** {dt.date.today()} by `scripts/claim_comments.py` from the `<!--# CLAIM ... -->` "
        "comments in the manuscript. Generated file — edit the comments, not this index.",
        "",
        f"**Rows:** {len(rows)} · **invalid markers:** {sum(not r['valid'] for r in rows)} · "
        f"**cited keys with no comment or map row:** {len(missing)}",
        "",
    ]
    for f in dict.fromkeys(r["file"] for r in rows):
        sub = [r for r in rows if r["file"] == f]
        lines += [f"## {f} ({len(sub)})", "", "| Line | Claim (sentence backed) | Mark | Source |",
                  "|---|---|---|---|"]
        lines += [f"| {r['line']} | {r['claim']} | {r['marker'] if r['valid'] else '**' + (r['marker'] or '—') + '?**'} | {r['source']} |"
                  for r in sub]
        lines.append("")
    if missing:
        lines += ["## Cited keys without provenance", "", ", ".join(f"`{k}`" for k in missing), ""]
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text("\n".join(lines), encoding="utf-8")
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true", help="exit 1 on comments with no valid marker")
    args = ap.parse_args()
    rows = collect()
    bad = [r for r in rows if not r["valid"]]
    if args.check:
        for r in bad:
            print(f"{r['file']}:{r['line']}: CLAIM comment without a valid marker: {r['marker'] or '(empty)'}")
        return 1 if bad else 0
    out = write_index(rows, uncovered_keys(rows))
    print(f"wrote {out.relative_to(ROOT).as_posix()}: {len(rows)} claims, {len(bad)} invalid markers")
    return 0


if __name__ == "__main__":
    sys.exit(main())

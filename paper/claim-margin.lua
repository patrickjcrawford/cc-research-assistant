-- claim-margin.lua
-- Print every <!--# ... --> claim comment as numbered margin text, using Quarto's
-- native .column-margin, in a separate "annotated" build. Does nothing unless the
-- metadata annotate-claims is true, so the normal render is untouched.
--
-- Usage:  quarto render paper/main.qmd -M annotate-claims:true -o main_claims.pdf
--
-- The annotated build only widens the PAGE to the right; the text block keeps its
-- width, so line breaks and page breaks match the normal build.
--
-- Comment syntax (the marker is the first token after CLAIM):
--   ...sentence the claim backs. <!--# CLAIM 🟢 smith2020WindPollution p. 4: "prevailing wind..." -->
-- Markers follow INV-27 / .claude/references/citation-practice.md. scripts/claim_comments.py
-- indexes the same comments into quality_reports/. Ported from a dissertation project (2026-11-11).

local BS = string.char(92)  -- literal backslash, built without escape sequences

-- Readable tags for the provenance markers (LaTeX fonts lack the emoji).
local TAGS = {
  ["\240\159\159\162"] = "[DIRECT]",      -- green circle: passage + page recorded
  ["\240\159\159\160"] = "[SYNTHESIS]",   -- orange circle: inference across sources
  ["\240\159\148\181"] = "[ATTESTED]",    -- blue circle: author-attested (user-assigned only)
  ["\226\154\160\239\184\143"] = "[WARNING]",
  ["\226\154\160"]     = "[WARNING]",
}

local function clean(s)
  for k, v in pairs(TAGS) do s = s:gsub(k, v) end
  s = s:gsub("\194\167", "Sec. ")
  s = s:gsub("\226\128\148", "--")
  s = s:gsub("\226\128[\147\146]", "-")
  s = s:gsub("\226\136\146", "-")
  s = s:gsub("[\226\128][\152\153]", "'")
  s = s:gsub("[\226\128][\156\157]", '"')
  s = s:gsub("[\240-\244][\128-\191]+", "?")
  s = s:gsub("[\226-\239][\128-\191][\128-\191]", "?")
  s = s:gsub("%s+", " ")
  return s
end

local function comment_body(text)
  return text:match("^<!%-%-#%s*(.-)%s*%-%->$")
end

local counter = 0

-- One claim comment -> a tiny red number in the text plus a native margin span.
local function claim_inlines(text)
  local body = comment_body(text)
  if not body then return nil end
  counter = counter + 1
  local n = tostring(counter)
  local marker = pandoc.RawInline("latex", BS .. "clmmark{" .. n .. "}")
  local note = pandoc.Span({
      pandoc.RawInline("latex", BS .. "textcolor{red}{" .. n .. "} "),
      pandoc.Str(clean(body)),
    }, pandoc.Attr("", { "column-margin" }))
  return { marker, note }
end

local function enabled(meta)
  local flag = meta["annotate-claims"]
  if flag == nil then return false end
  if type(flag) == "boolean" then return flag end
  local s = pandoc.utils.stringify(flag)
  return s == "true" or s == "yes" or s == "1"
end

local HEADER = table.concat({
  BS .. "usepackage{xcolor}",
  BS .. "usepackage{setspace}",
  BS .. "usepackage{etoolbox}",
  BS .. "usepackage{marginfix}",
  -- Widen the PAGE only: the text block keeps its width.
  BS .. "geometry{paperwidth=11.5in,hmargin={1in,4in},marginparwidth=3.5in,marginparsep=0.15in}",
  -- Zero-width red number raised into the line gap.
  -- The marker is a box; a box resets TeX's space factor, which would shrink the space after
  -- a sentence-ending period and change line breaks. Save and restore the space factor.
  BS .. "newcommand{" .. BS .. "clmmark}[1]{" .. BS .. "edef" .. BS .. "clmsf{" .. BS .. "the" .. BS .. "spacefactor}" ..
    BS .. "makebox[0pt][r]{" .. BS .. "raisebox{1.5ex}{" .. BS .. "textcolor{red}{" .. BS .. "tiny #1}}}" ..
    BS .. "spacefactor=" .. BS .. "clmsf" .. BS .. "relax}",
  -- Quarto's margin notes use \marginnote, which lets notes overlap. Route them through
  -- \marginpar, which stacks them, once all packages are loaded.
  -- \providecommand first: Quarto loads marginnote only when margin content exists, so a draft with
  -- no claims would otherwise fail on \renewcommand.
  BS .. "AtBeginDocument{" .. BS .. "providecommand{" .. BS .. "marginnote}{}" ..
    BS .. "renewcommand{" .. BS .. "marginnote}[2][]{" .. BS .. "marginpar{" ..
    BS .. "raggedright" .. BS .. "singlespacing" .. BS .. "scriptsize #2" .. BS .. "par}}}",
  -- A margin note is illegal inside floats, captions and tables: print nothing there.
  BS .. "newcommand{" .. BS .. "clmoff}{" .. BS .. "renewcommand{" .. BS .. "clmmark}[1]{}" ..
    BS .. "renewcommand{" .. BS .. "marginnote}[2][]{}}",
  BS .. "AtBeginEnvironment{figure}{" .. BS .. "clmoff}",
  BS .. "AtBeginEnvironment{figure*}{" .. BS .. "clmoff}",
  BS .. "AtBeginEnvironment{table}{" .. BS .. "clmoff}",
  BS .. "AtBeginEnvironment{table*}{" .. BS .. "clmoff}",
  BS .. "AtBeginEnvironment{longtable}{" .. BS .. "clmoff}",
}, "\n")

-- Drop claim comments where margin text cannot live: headings and footnotes.
local function strip_in(el)
  return el:walk({
    RawInline = function(r)
      if r.format == "html" and comment_body(r.text) then return {} end
    end,
    RawBlock = function(r)
      if r.format == "html" and comment_body(r.text) then return {} end
    end })
end

local INLINE_CONTAINERS = { Emph = true, Strong = true, Span = true, Link = true,
  Quoted = true, SmallCaps = true, Underline = true, Strikeout = true,
  Superscript = true, Subscript = true }

-- Convert comments in document order so the numbers run 1, 2, 3, ... down the paper.
local conv_blocks

local function conv_inlines(inls)
  local out = pandoc.Inlines({})
  for _, el in ipairs(inls) do
    if el.t == "RawInline" and el.format == "html" and comment_body(el.text) then
      for _, p in ipairs(claim_inlines(el.text)) do out:insert(p) end
    elseif INLINE_CONTAINERS[el.t] then
      el.content = conv_inlines(el.content)
      out:insert(el)
    else
      out:insert(el)
    end
  end
  return out
end

conv_blocks = function(blocks)
  local out, pending = pandoc.Blocks({}), {}
  for _, b in ipairs(blocks) do
    local t = b.t
    if t == "RawBlock" and b.format == "html" and comment_body(b.text) then
      -- a comment on its own line: attach to the neighbouring paragraph (adds no blank line)
      local parts = claim_inlines(b.text)
      local last = out[#out]
      if last and (last.t == "Para" or last.t == "Plain") then
        for _, p in ipairs(parts) do last.content:insert(p) end
      else
        for _, p in ipairs(parts) do pending[#pending + 1] = p end
      end
    else
      if t == "Para" or t == "Plain" then
        b.content = conv_inlines(b.content)
        if #pending > 0 then
          for i = #pending, 1, -1 do b.content:insert(1, pending[i]) end
          pending = {}
        end
      elseif t == "BlockQuote" or t == "Div" then
        b.content = conv_blocks(b.content)
      elseif t == "BulletList" or t == "OrderedList" then
        for i, item in ipairs(b.content) do b.content[i] = conv_blocks(item) end
      end
      out:insert(b)
    end
  end
  return out
end

function Pandoc(doc)
  if not enabled(doc.meta) then return doc end
  quarto.doc.include_text("in-header", HEADER)
  doc = doc:walk({ Header = strip_in, Note = strip_in })
  doc.blocks = conv_blocks(doc.blocks)
  return doc
end

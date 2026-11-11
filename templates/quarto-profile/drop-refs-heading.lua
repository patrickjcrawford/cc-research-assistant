-- For natbib/BibTeX profiles: BibTeX prints the bibliography (with its own heading) at the end, so
-- drop main.qmd's own "References" heading and the empty ::: {#refs} div to avoid an empty section.
-- Matches a heading with id "sec-refs" or text "References".

local function is_refs_header(blk)
  if blk.t ~= "Header" then return false end
  return blk.identifier == "sec-refs" or pandoc.utils.stringify(blk.content) == "References"
end

function Pandoc(doc)
  local out = pandoc.List()
  for _, blk in ipairs(doc.blocks) do
    local drop = is_refs_header(blk) or (blk.t == "Div" and blk.identifier == "refs")
    if not drop then out:insert(blk) end
  end
  doc.blocks = out
  return doc
end

function Div(el)
  if el.classes:includes("warning") then
    return {
      pandoc.RawBlock("latex", "\\begin{mdframed}[backgroundcolor=yellow!20,linecolor=orange!80,linewidth=2pt,roundcorner=5pt]"),
      pandoc.RawBlock("latex", "\\textbf{\\large ! Note:}"),
      el,
      pandoc.RawBlock("latex", "\\end{mdframed}")
    }
  elseif el.classes:includes("note") then
    return {
      pandoc.RawBlock("latex", "\\begin{mdframed}[backgroundcolor=blue!5,linecolor=blue!60,roundcorner=5pt]"),
      pandoc.RawBlock("latex", "\\textbf{Note:}"),
      el,
      pandoc.RawBlock("latex", "\\end{mdframed}")
    }
  elseif el.classes:includes("info") then
    return {
      pandoc.RawBlock("latex", "\\begin{mdframed}[backgroundcolor=green!5,linecolor=green!60,roundcorner=5pt]"),
      pandoc.RawBlock("latex", "\\textbf{Info:}"),
      el,
      pandoc.RawBlock("latex", "\\end{mdframed}")
    }
  end
end

function Table(el)
  -- Worklog tables (Time | Task | Reference Material) are no longer built
  -- through Pandoc's table parser at all - convert_hugo_to_latex.py emits
  -- them as raw LaTeX before Pandoc ever sees them, specifically to avoid
  -- depending on Pandoc's per-cell column-type heuristics and Lua table
  -- AST shape (both proved version-fragile). This function now only needs
  -- to handle whatever other ordinary tables show up elsewhere.
  --
  -- Each colspec is a plain {Alignment, ColWidth} pair indexed by position
  -- (col[1], col[2]), not a named-field object - col.width is a no-op.
  --
  -- ColWidthDefault does NOT reliably produce wrapping p{width} columns:
  -- Pandoc only does that when a cell already has multi-block content
  -- (e.g. our worklog cells, which have <br>-separated bullet lines).
  -- A plain single-paragraph table with long cell text - e.g. cost/risk
  -- tables elsewhere in the report - gets non-wrapping "l" columns
  -- instead under ColWidthDefault, and long cells overflow the page
  -- outright instead of wrapping. Assigning explicit equal fractional
  -- widths forces p{width} columns (and thus wrapping) unconditionally.
  local n = #el.colspecs
  local equal_width = 1.0 / n
  for _, col in ipairs(el.colspecs) do
    col[2] = equal_width
  end
  return el
end
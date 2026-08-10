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
  -- Worklog "Time | Task | Reference Material" tables: narrow Time and
  -- Reference so Task gets most of the row. Matched by header text (not
  -- just column count) so other 3-column tables elsewhere aren't affected.
  local header_cells = {}
  if el.head and el.head.rows[1] then
    for _, cell in ipairs(el.head.rows[1].cells) do
      table.insert(header_cells, pandoc.utils.stringify(cell):lower())
    end
  end

  -- Each colspec is a plain {Alignment, ColWidth} pair indexed by position
  -- (col[1], col[2]), not a named-field object - col.width is a no-op.
  if #el.colspecs == 3 and header_cells[1] == "time" then
    local widths = {0.10, 0.68, 0.22}
    for i, col in ipairs(el.colspecs) do
      col[2] = widths[i]
    end
    return el
  end

  for _, col in ipairs(el.colspecs) do
    col[2] = pandoc.ColWidthDefault
  end
  return el
end
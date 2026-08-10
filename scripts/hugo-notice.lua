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
  -- Uses pandoc.utils.stringify on the whole head rather than indexing
  -- into row.cells/cell fields directly - those are internal, positional
  -- structures whose Lua binding shape has been observed to vary between
  -- Pandoc versions (same issue col.width vs col[2] had for ColSpec).
  -- Wrapped in pcall as a last line of defense: if some other Pandoc
  -- version quirk trips this up, fall through to the plain default-width
  -- behavior instead of failing the whole conversion.
  local is_time_table = false
  local ok, result = pcall(function()
    if el.head then
      return pandoc.utils.stringify(el.head):lower():match("^time") ~= nil
    end
    return false
  end)
  if ok then
    is_time_table = result
  end

  -- Each colspec is a plain {Alignment, ColWidth} pair indexed by position
  -- (col[1], col[2]), not a named-field object - col.width is a no-op.
  if #el.colspecs == 3 and is_time_table then
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
#set page("us-letter")

#context {
  let page_margin = 5cm
  let grid_width = page.width - page_margin
  let grid_height = page.height - page_margin

  let columns = 3
  let column_width = grid_width / columns

  let row-height = 4.0mm
  let row-gutter = 1.2mm
  let rows = calc.floor(grid_height / (row-gutter + row-height + row-gutter))

  let checkmark = circle(radius: 2pt, stroke: 0.1pt)
  let grid-items = range(columns * rows * 3)
    .map(i => calc.floor(i / columns))
    .map(row => calc.rem-euclid(row, 3) == 1)
    .map(b => if b { checkmark } else { none })
    .map(move.with(dx: 3.5pt))
    .map(block.with(width: column_width))
    .map(align.with(left + horizon))

  let grid-rows = range(rows * 3)
    .map(r => calc.rem-euclid(r, 3) == 1)
    .map(b => if b { row-height } else { row-gutter })

  grid(
    ..grid-items,
    columns: 3,
    rows: grid-rows,
    align: center,
    stroke: 0.001pt,
  )
}

// Notes:
// Do NOT set `stroke` less than 0.2pt. Tried it. Looks like shit.

#let new-grid = (
  header,
  columns: 3,
  header-size: 20pt,
  row-normal-height: 4.0mm,
  row-gutter-height: 1.2mm,
) => context {
  let header = if header == none {
    []
  } else {
    let header = align(
      center,
      text(header, size: header-size, font: "Comic Sans MS"),
    )
    block(header, width: 100%)
  }

  let header-height = measure(header).height

  let page-margin = 5cm
  let grid-width = page.width - page-margin
  let grid-height = page.height - page-margin - header-height

  let column-width = grid-width / columns

  let checkmark = circle(radius: 2pt, stroke: 0.15pt)
  let rows = calc.floor(
    grid-height / (row-gutter-height + row-normal-height + row-gutter-height),
  )

  let grid-items = range(columns * rows * 3)
    .map(i => calc.floor(i / columns))
    .map(row => calc.rem-euclid(row, 3) == 1)
    .map(b => if b { checkmark } else { none })
    .map(move.with(dx: 3.5pt))
    .map(block.with(width: column-width))
    .map(align.with(left + horizon))

  let grid-rows = range(rows * 3)
    .map(r => calc.rem-euclid(r, 3) == 1)
    .map(b => if b { row-normal-height } else { row-gutter-height })

  let grid-elem = grid(
    ..grid-items,
    columns: columns,
    rows: grid-rows,
    align: center,
    stroke: 0.2pt,
  )

  [
    #header #grid-elem #pagebreak(weak: true)
  ]
}

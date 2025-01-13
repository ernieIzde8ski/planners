#set page("us-letter")

#context {
    let page_margin = 5cm;
    let grid_width = page.width - page_margin;
    let grid_height = page.height - page_margin;

    let columns = 3;
    let column_width = grid_width / columns;

    let row_height = 4.0mm;
    let row_gutter = 1.2mm;
    let rows = calc.floor(grid_height / (row_gutter + row_height + row_gutter ))

    let checkmark = circle(radius: 2pt, stroke: 0.1pt);
    let grid-items = range(columns * rows * 3)
        .map(i => calc.floor(i / columns))
        .map(row => calc.rem-euclid(row, 3) == 1)
        .map(b => if b { checkmark } else { [~] })
        .map(c => move(c, dx: 3.5pt))
        .map(m => block(m, width: column_width))
        .map(b => align(left + horizon, b));

    let grid-rows = range(rows * 3)
        .map(r => calc.rem-euclid(r, 3) == 1)
        .map(b => if b { row_height } else { row_gutter } );

    grid(
        columns: 3,
        rows: grid-rows,
        align: center,
        stroke: 0.001pt,
        ..grid-items
    )
}

#set page(paper: "us-letter")
#set page(columns: 2)
#set text(font: "Noto Sans")
#set columns(gutter: 24pt)
#set page(margin: (top: 2cm, bottom: 2cm, left: 1.5cm, right: 1.5cm))

#place(
  top + center,
  float: true,
  scope: "parent",
  text(2.4em, weight: "bold")[First steps],
  clearance: 30pt,
  dy: 100pt,
)

#set page(background: line(angle: 90deg, length: 87%, stroke: 0.2pt + luma(200)))
#set page(numbering: "1")
#counter(page).update(1)

#text(fill: gray, baseline: 6pt)[Tuesday · November 11, 2024]
#text(fill: white)[
  #block(
    fill: blue,
    radius: 8pt,
    inset: 8pt,
    breakable: false,
  )[
    Hey — you free tonight? Thought we could
    check out that new taco place on 8th.
    #v(-6pt)
    #align(right)[ #text(0.8em, fill: luma(250))[09:12] ]
  ]
  #v(-24pt)
  #block(
    radius: 999pt,
    inset: 4pt,
  )[
    #text(1.15em)[😊]
  ]
]


// and the response...
#v(-12pt)
#align(right)[
  #block(
    fill: luma(230),
    radius: 8pt,
    inset: 8pt,
    breakable: false,
  )[
    Sounds perfect. What time?
    #linebreak()
    #text(0.8em, fill: luma(100))[09:14]
  ]
  #v(-24pt)
  #block(
    radius: 999pt,
    inset: 4pt,
  )[
    #text(1.15em)[😊]
  ]
]

// add a photo
#image("assets/cassie.JPG", width: 100%)

#lorem(100)

#lorem(50)

#lorem(30)

// SPDX-FileCopyrightText: 2026 Jacques Supcik <jacques.supci@hes-so.ch>
//
// SPDX-License-Identifier: MIT

// Flyer template for HEIA-FR Bachelor thesis summary
// Jacques Supcik, July 2026

#import "@preview/oxifmt:1.0.0": strfmt

#let i18n = toml("i18n.toml")
#let logos = toml("logos.toml")

#let heia_blue = rgb("#007CB7")
#let heia_grey = rgb("#ACA39A")

#let gender_code(persons: ()) = {
  let g = if persons.map(p => p.gender).all(g => g == "M") { "M" } else if persons
    .map(p => p.gender)
    .all(g => g == "F") { "F" } else { "X" }
  let c = if persons.len() <= 1 {
    "S"
  } else { "P" }
  g + c
}

#let header(
  program: "ISC",
  year: none,
  students: (),
) = [

  #let subtitle = context (
    i18n.flyer.subtitle.at(text.lang, default: i18n.flyer.subtitle.en)
  )

  #let program_label = context (
    if program not in i18n.program {
      [#highlight[UNKNOWN PROGRAM: #program]]
    } else {
      i18n.program.at(program).at(text.lang, default: i18n.program.at(program).en)
    }
  )

  #let student_label = context {
    let gc = gender_code(persons: students)
    i18n.student.at(gc).at(text.lang, default: i18n.student.at(gc).en)
  }

  #box(width: 100%, height: 16mm, fill: heia_blue, [
    #place(left + horizon, dx: 3mm, image(
      "logo-heia.svg",
      height: 12mm,
    ))
    #place(right + horizon, dx: -4mm, image(
      "logo-hesso.svg",
      height: 4.5mm,
    ))

    #if program in logos {
      place(center + horizon, dy: 8mm, image(logos.at(program), height: 18mm))
    }

  ])
  #set text(fill: heia_blue)
  #box(width: 100%, [
    #place(top + left, [
      #text(size: 8pt, weight: "bold", student_label)\
      #text(
        size: 10pt,
        weight: "black",
        students.map(s => s.first_name + " " + s.last_name).join(" / "),
      )\
    ])
    #place(top + right, [
      #text(size: 8pt, weight: "bold", [#subtitle #year])\
      #text(size: 9.5pt, weight: "regular", [#upper(program_label)])\
    ])])
]


#let footer() = [
  #set text(fill: heia_blue, size: 8.5pt)
  #line(stroke: heia_blue + 0.1mm, length: 100%)
  #context (
    eval(i18n.address.at(text.lang, default: i18n.address.en), mode: "markup")
  )
]

#let title_frame(
  professors: (),
  client: none,
  int_contact: none,
  acronym: none,
  number: none,
  theme: none,
  experts: (),
  sdg_goals: (1, 2, 3, 4, 5),
) = [
  #set text(fill: heia_blue, size: 10pt)

  #let prof_label = context {
    let gc = gender_code(persons: professors)
    i18n.professor.at(gc).at(text.lang, default: i18n.professor.at(gc).en)
  }

  #let client_label = context (
    i18n.client.at(text.lang, default: i18n.client.en)
  )


  #let int_contact_label = context (
    i18n.int_contact.at(text.lang, default: i18n.int_contact.en)
  )

  #let theme_label = context (
    i18n.theme.at(text.lang, default: i18n.theme.en)
  )

  #let acronym_label = context (
    i18n.acronym.at(text.lang, default: i18n.acronym.en)
  )

  #let number_label = context (
    i18n.number.at(text.lang, default: i18n.number.en)
  )

  #let expert_label = context {
    let gc = gender_code(persons: experts)
    i18n.expert.at(gc).at(text.lang, default: i18n.expert.at(gc).en)
  }

  #let sdg_label = context (
    i18n.sdg.at(text.lang, default: i18n.sdg.en)
  )

  #grid(
    columns: (1fr, 1fr),
    align: left + horizon,
    stroke: heia_grey + .1mm,
    inset: 2mm,

    grid.hline(stroke: heia_blue + .3mm),
    grid.vline(stroke: heia_blue + .3mm),
    grid.cell(colspan: 2, [
      #upper([#prof_label]) :
      #text(weight: "bold", professors.map(p => p.first_name + " " + p.last_name).join(", "))]),
    grid.cell(colspan: 2, [
      #upper([#client_label]) :
      #text(weight: "bold", client)]),
    grid.vline(stroke: heia_blue + .3mm),
    grid.cell(colspan: 2, [
      #upper([#int_contact_label]) :
      #text(weight: "bold", int_contact)]),

    [#upper([#acronym_label]) : #text(weight: "bold", acronym)],
    [#upper([#number_label]) : #text(weight: "bold", number)],
    [#upper([#theme_label]) : #text(weight: "bold", theme)],
    [#upper([#expert_label]) : #text(weight: "bold", experts.map(e => e.first_name + " " + e.last_name).join(", "))],

    grid.cell(colspan: 2, upper([#sdg_label :
      #box(baseline: 35%, [
        #for i in sdg_goals [
          #context (
            [
              #if text.lang == "fr" {
                box(height: 8mm, image(strfmt("sdg/fr/sdg-fr-{:#02}.jpg", i)))
              } else if text.lang == "de" {
                box(height: 8mm, image(strfmt("sdg/de/sdg-de-{:#02}.jpg", i)))
              } else {
                box(height: 8mm, image(strfmt("sdg/en/sdg-en-{:#02}.jpg", i)))
              }
            ]
          )
        ]
      ])
    ])),
    grid.hline(stroke: heia_blue + .3mm),
  )
]

#let summary(
  doc,
) = [
  #set text(fill: heia_blue, weight: "semibold", size: 11pt)
  #doc
]

#let flyer(
  program: "ISC",
  students: (),
  professors: (),
  client: none,
  year: 2025,
  int_contact: none,
  acronym: none,
  number: none,
  theme: none,
  experts: (),
  sdg_goals: (),
  title: none,
  doc,
) = [

  #set page(margin: (x: 10mm, top: 40mm))
  #set text(font: "Noto Sans")
  #set page(
    header: header(
      program: program,
      year: year,
      students: (students),
    ),
    footer: footer(),
  )

  #title_frame(
    professors: professors,
    client: client,
    int_contact: int_contact,
    acronym: acronym,
    number: number,
    theme: theme,
    experts: experts,
    sdg_goals: sdg_goals,
  )

  #show heading.where(level: 1): set text(fill: heia_blue, size: 17pt)
  #show heading.where(level: 2): set text(size: 11.5pt)

  = #title
  #v(5mm)

  #set par(justify: true)
  #doc
]

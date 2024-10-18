#import "@preview/pinit:0.1.3": *
#import "@preview/colorful-boxes:1.2.0": *
#import "@preview/mitex:0.2.0": *
#import "@preview/xarrow:0.2.0": *

#let callout(type, color: none, content) = {
    if(color == none){
      if(type in ("Definition", "Note")){
        color = "blue"
      } else if(type in ("Formula", "Lemma", "Corollary", "Proposition")){
        color = "green"
      } else if(type in ("Example")){
        color = "red"
      }
    }
      
    outlinebox(
    title: type,
    color: color,
    width: auto,
    radius: 5pt,
    centering: false,
    content)
  }


#let qbox(lstroke: 0.25em + black,fill: luma(250), content) = {
    rect(fill: fill, stroke: (left:  lstroke),width: 100%)[
    #content
  ]
}
// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(title: "", authors: (), body) = {
  // Set the document's basic properties.
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center, background: [#rect(width: 100%, height: 100%)])
  set text(font: "Linux Libertine", lang: "cn")

  // Title row.
  align(center)[
    #block(text(weight: 700, 1.75em, title))
  ]

  // Author information.
  pad(
    top: 0.5em,
    bottom: 0.5em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center, strong(author))),
    ),
  )

  // Main body.
  set par(justify: true)

  set text(font: ("Linux Libertine", "Songti SC"))
  
  body
}

#show: project.with(
  title: "Linear Algebra Exercise Collection",
  authors: ("ZAMBAR",)
)

#set heading(numbering: "1.1.")
#align(bottom, outline(indent: 1em))
#pagebreak()

= Linear System andd Matrices

= Euclidean Vector Spaces

= General Vector Space

= Linear Transformations

= Inner Product Space

== Gram–Schmidt Process; QR-Decomposition

== Orthogonal Diagonalizability

#qbox[*HW. Jan.3 Ex4. *

#mitext(`
Prove that if $A$ is any $m x n$ matrix, then
$$
A^T A
$$
has an orthonormal set of $n$ eigenvectors.
`)]

*_Solution_*

#mitext(`
Let $A$ be any $m \times n$ matrix. Then $A^T$ is $n \times m$ matrix, so $A^T A$ is $n \times n$ matrix.

Easily we can see that $A^T A$ is symmetric:
$$
\begin{aligned}
\left(A^T A\right)^T & =A^T \cdot\left(A^T\right)^T \\
& =A^T A
\end{aligned}
$$
(because $(A B)^T=B^T \cdot A^T$ )
$$
\text { (because }\left(A^T\right)^T=A \text { ) }
$$

According to *Theorem 7.2.1.*, $A^T A$ has an orthonormal set of $n$ eigenvectors.
`)
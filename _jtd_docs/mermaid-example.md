---
layout: page
title: Mermaid Example
path: /jtd/mermaid
nav_order: 12
---

# References

- [Mermaid Diagrams Syntax](https://mermaid.js.org/intro/){:target="_blank"}
- [Mermaid Examples](https://docs.mermaidchart.com/mermaid-oss/syntax/examples.html){:target="_blank"}

# Examples

```mermaid
graph TB
    sq[Square shape] --> ci((Circle shape))

    subgraph A
        od>Odd shape]-- Two line&lt;br/>edge comment --> ro
        di{Diamond with &lt;br/> line break} -.-> ro(Rounded&lt;br>square&lt;br>shape)
        di==>ro2(Rounded square shape)
    end

    %% Notice that no text in shape are added here instead that is appended further down
    e --> od3>Really long text with linebreak&lt;br>in an Odd shape]

    %% Comments after double percent signs
    e((Inner / circle&lt;br>and some odd &lt;br>special characters)) --> f(,.?!+-*ز)

    cyr[Cyrillic]-->cyr2((Circle shape Начало));

     classDef green fill:#9f6,stroke:#333,stroke-width:2px;
     classDef orange fill:#f96,stroke:#333,stroke-width:4px;
     class sq,e green
     class di orange
```

```mermaid
 graph LR
      A["$$x^2$$"] -->|"$$\sqrt{x+3}$$"| B("$$\frac{1}{2}$$")
      A -->|"$$\overbrace{a+b+c}^{\text{note}}$$"| C("$$\pi r^2$$")
      B --> D("$$x = \begin{cases} a &\text{if } b \\ c &\text{if } d \end{cases}$$")
      C --> E("$$x(t)=c_1\begin{bmatrix}-\cos{t}+\sin{t}\\ 2\cos{t} \end{bmatrix}e^{2t}$$")
```

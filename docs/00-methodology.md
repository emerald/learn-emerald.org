---
title: The Emerald Programming Methodology
---

<style>
  article svg {
    width: 100%;
    height: 500px;
  }
</style>

# The Emerald Programming Methodology

Emerald is a programming language developed in the early 1980s, in a
scientific effort to address the challenge of programming distributed
systems. Unfortunately, it gained neither popularity, nor an ongoing
development effort. As a result, it is today syntactically,
semantically, and technically tainted by some academic zeitgeist of
the late 1970s and early 1980s. Never-the-less Emerald can still bring
something to the table---its methodology for programming distributed
systems. The goal of this page is to explain this methodology in an
accessible manner.

In the Emerald world-view, a distributed system is a collection of
objects distributed across a number of nodes.

<svg id="fig1"></svg>

Although an object is instantiated on a particular node, it may move
from node to node throughout its lifetime.

<svg id="fig2"></svg>

<script src="https://d3js.org/d3.v5.js"></script>
<script src="/js/methodology.js"></script>

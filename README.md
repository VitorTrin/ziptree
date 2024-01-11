# Ziptree

## What is a zip tree?
Zip tree is a random access data structure that is equivalent to a skiplist,
but instead of being stored in multiple arrays it is stored in a binary balanced tree.

It was created in 2018 [Zip Trees, by Robert E. Tarjan, Caleb C. Levy, Stephen Timmel](https://arxiv.org/abs/1806.06726) and then futher improved
in 2023 [Zip-zip Trees: Making Zip Trees More Balanced, Biased, Compact, or Persistent by Ofek Gila, Michael T. Goodrich, Robert E. Tarjan](https://arxiv.org/abs/2307.07660)

## What is this lib?

This is a nif for the rust implementation of zip trees, more specifically the zip zip tree implementation.

Big thanks to Discord for their [sorted_set_nif](https://github.com/discord/sorted_set_nif) that is a great
tutorial in how to use rustler to export rust data types to elixir.

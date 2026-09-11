#!/bin/bash

# Randomize string (space-separated values).
function randomize_string () {
  echo $@ | tr " " "\n" | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);' | tr "\n" " "
}

# Extract a random item from a string (space-separated values).
function random_el () {
  local array=($(randomize_string $@))
  # Bash $RANDOM is terrible; use jot.
  # jot package required
  echo ${array[$(jot -r 1 0 `expr ${#array[*]} - 1`)]}
}

# Generate a random food emoji.
function random_food () {
  echo $(random_el "🍺 🍸 🍹 🍷 🍕 🍔 🍟 🍗 🍖 🍝 🍤 🍣 🍥 🍜 🍡 🍞 🍩 🍦 🍨 🍰 🍪 🍫 🍬 🍭 🍎 🍏 🍊 🍋 🍒 🍇 🍉 🍓 🍑 🍌 🍐 🍍 🍆 🍅  ")
}

random_food

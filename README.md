# Birdline.vim

My personal statusline customizations

- File status indicated by color and ascii faces
  - ![color and ascii faces](README/faces.gif?raw=true 'Ascii Faces')
- responsive based on window width

Customize colors with:

```vimscript
highlight StatusLineWhenInactive ctermbg=LightGray ctermfg=DarkGrey
highlight StatusLineWhenInactiveAndModified ctermbg=LightGray ctermfg=DarkBlue

highlight StatusLineWhenModified ctermbg=DarkGray ctermfg=Yellow
highlight StatusLineWhenUnmodified ctermbg=DarkGray ctermfg=White

highlight StatusLineWhenReadOnly ctermbg=DarkRed ctermfg=White
highlight StatusLineWhenReadOnlyAndModified ctermbg=DarkRed ctermfg=Yellow
```

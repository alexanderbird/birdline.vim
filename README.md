# Birdline.vim

My personal statusline customizations

## File status indicated by color ans ascii faces
![Color and ascii faces changing based on file status](README/faces.gif?raw=true 'Ascii faces and color change to indicate file stats')

## Status line content adjusts based on window width
![Responsive content](README/responsive.gif?raw=true 'Responsive Content')

## File path shown relative to current working directory
![File path shown relative to current working directory](README/relative-paths.gif?raw=true 'File path shown relative to current working directory')

## Customize colors with

```vimscript
highlight StatusLineWhenInactive ctermbg=LightGray ctermfg=DarkGrey
highlight StatusLineWhenInactiveAndModified ctermbg=LightGray ctermfg=DarkBlue

highlight StatusLineWhenModified ctermbg=DarkGray ctermfg=Yellow
highlight StatusLineWhenUnmodified ctermbg=DarkGray ctermfg=White

highlight StatusLineWhenReadOnly ctermbg=DarkRed ctermfg=White
highlight StatusLineWhenReadOnlyAndModified ctermbg=DarkRed ctermfg=Yellow
```

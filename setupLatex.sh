#!/usr/bin/env bash

# texlive-binextra required for latexmk
# texlive-latex for latex format files needed by latexmk to compile LaTeX documents
# texlive-latexextra for additional LaTeX packages
# tree-sitter-cli for syntax highlighting in some editors

sudo pacman -S --needed --no-confirm texlive-binextra texlive-latex texlive-latexextra tree-sitter-cli 

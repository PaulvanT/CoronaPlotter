#!/bin/bash
# This script crops .eps files.

echo "Type the file name without the extension, followed by [ENTER]:"

read file_name

epstopdf $file_name.eps

pdfcrop $file_name.pdf  

pdftops -eps $file_name-crop.pdf $file_name.eps

rm $file_name.pdf

rm $file_name-crop.pdf

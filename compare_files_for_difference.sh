NAME
       comm - compare two sorted files line by line

SYNOPSIS
       comm [OPTION]... FILE1 FILE2

...

       -1     suppress lines unique to FILE1

       -2     suppress lines unique to FILE2

       -3     suppress lines that appear in both files
So

comm -2 -3 file1 file2 > file3
The input files must be sorted. If they are not, sort them first. This can be done with a temporary file, or...

comm -2 -3 <(sort file1) <(sort file2) > file3

Source: https://stackoverflow.com/questions/4544709/compare-two-files-line-by-line-and-generate-the-difference-in-another-file

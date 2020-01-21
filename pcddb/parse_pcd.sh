#!/bin/sh

for i in `ls *.pcd`; do
    python pcdreader.py $i
done

#!/usr/bin/env bash

subsDir="$1"

for dir in "$subsDir"/*; do
    subsCount=$(fd -t f -e srt --search-path "$dir" | wc -l)
    firstSub=$(fd -t f -e srt --search-path "$dir" | head -n 1 -)

    if [[ $subsCount -ge 1 ]]; then
        echo "Removing the first subtitle $firstSub"
        rm $firstSub

        echo "Renaming the second subtitle to $dir.srt"
        mv $dir/*.srt $dir/$(basename $dir).srt
        mv $dir/*.srt $subsDir/..
    fi
done

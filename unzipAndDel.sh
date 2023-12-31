#!/bin/bash
for f in *.zip; do
   unzip "$f";
   isOk=$?;
   if [[ $isOk -eq 0 ]]; then
     rm "$f";
   fi;
done

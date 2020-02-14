#!/bin/bash

for file in *.sh
do
    cp "$file" "${file}.bak"
done

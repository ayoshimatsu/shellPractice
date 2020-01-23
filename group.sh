#!/bin/bash

{
    date +%X-%m-%d
    echo '/usr list'
    ls /usr
} > result.txt

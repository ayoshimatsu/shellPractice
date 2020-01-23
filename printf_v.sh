#!/bin/bash

value=250
printf -v message 'value = 0x%x' "$value"
echo "message = [$message]"

#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage $1 mutex-name"
    exit 5
else
    rm -d -R "$1-lock"
    exit 0
fi
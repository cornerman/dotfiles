#!/bin/bash

name=$(echo $QUTE_URL | awk -F/ '{print $3}' | awk -F. '{print $(NF-1)}')
pw $name

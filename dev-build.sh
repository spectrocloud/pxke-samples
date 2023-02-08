#!/bin/bash

set -o allexport
source .local.env
set +o allexport

bash build.sh


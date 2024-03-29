#!/bin/sh
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set -e
currentDir="$(cd "$(dirname "$0")"; pwd)"

numOfActions=10

# Host to use. Needs to include the protocol.
host=$1
# Credentials to use for the test. USER:PASS format.
credentials=$2
# concurrency level of the throughput test: How many requests should
# open in parallel.
concurrency=$3
# How many threads to utilize, directly correlates to the number
# of CPU cores
threads=${4:-4}
# How long to run the test
duration=${5:-30s}

"$currentDir/create.sh" "$host" "$credentials" "$numOfActions"

# run throughput tests
encodedAuth=$(echo "$credentials" | tr -d '\n' | base64 | tr -d '\n')
wrk --threads "$threads" \
  --connections "$concurrency" \
  --duration "$duration" \
  --header "Authorization: basic $encodedAuth" \
  "$host" \
  --latency \
  --timeout 10s \
  --script multi-post.lua

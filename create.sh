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

# Host to use. Needs to include the protocol.
host=$1
# Credentials to use for the test. USER:PASS format.
credentials=$2
# Number of noop actions to create
numOfActions=$3

for ((i = 1; i <= $numOfActions; i++))
do
  echo "Creating action noop-$i"
  # create a noop action
  echo "Creating action noop-$i"
  curl -k -u "$credentials" "$host/api/v1/namespaces/_/actions/noop-$i" -XPUT -d '{"namespace":"_","name":"test","exec":{"kind":"nodejs:default","code":"function main(){return {};}"}}' -H "Content-Type: application/json"

  # run the noop action
  echo "Running action noop-$i once to assert an intact system"
  curl -k -u "$credentials" "$host/api/v1/namespaces/_/actions/noop-$i?blocking=true" -XPOST
done

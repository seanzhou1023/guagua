#!/bin/bash
#
#
# Copyright [2013-2014] eBay Software Foundation
#  
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#  
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# please follow ../README.md to run this demo shell.

# Comments for all parameters:
#  '../mapreduce-lib/guagua-mapreduce-examples-0.5.0-SNAPSHOT.jar': Jar files include master, worker and user intercepters
#  '-i kmeans': '-i' means guagua application input, should be HDFS input file or folder
#  '-z ${ZOOKEEPER_SERVERS}': '-z' is used to configure zookeeper server, this should be placed by real zookeeper server
#                            The format is like '<zkServer1:zkPort1,zkServer2:zkPort2>'
#  '-w ml.shifu.guagua.mapreduce.example.kmeans.KMeansWorker': Worker computable implementation class setting
#  '-m ml.shifu.guagua.mapreduce.example.kmeans.KMeansMaster': Master computable implementation class setting
#  '-c 10': Total iteration number setting
#  '-n Guagua-Sum-Master-Workers-Job': Hadoop job name or YARN application name specified
#  '-mr ml.shifu.guagua.mapreduce.example.kmeans.KMeansMasterParams': Master result class setting
#  '-wr ml.shifu.guagua.mapreduce.example.kmeans.KMeansWorkerParams': Worker result class setting
#  '-Dmapred.job.queue.name=default': Queue name setting
#  '-Dkmeans.k.number=2': set k
#  '-Dkmeans.data.seperator="|"': data input separator
#  '-Dkmeans.column.number': Columns used in kmeans
#  '-Dkmeans.k.number=2': set k
#  '-Dkmeans.centers.output=kmeans-centers': new centers output file in HDFS
#  '-Dkmeans.data.output=kmeans-tags': new data file folder with tag at last column
#  '-Dkmeans.k.centers=${KMEANS_INIT_CENTERS}': initial centers
#  '-Dguagua.master.intercepters=ml.shifu.guagua.mapreduce.example.kmeans.KMeansCentersOutput': User master interceptors

ZOOKEEPER_SERVERS=
if [ "${ZOOKEEPER_SERVERS}X" == "X" ] ; then
  echo "Zookeeper server should be provided for guagua coordination. Set 'ZOOKEEPER_SERVERS' at first please."
  exit 1
fi

KMEANS_INIT_CENTERS=1,1:-1,-1
if [ "${KMEANS_INIT_CENTERS}X" == "X" ] ; then
  echo "Kmeans initial centers should be set firstly. Set 'KMEANS.INIT.CENTERS' at first please."
  exit 1
fi

./guagua jar ../mapreduce-lib/guagua-mapreduce-examples-0.5.0-SNAPSHOT.jar \
        -i kmeans  \
        -z ${ZOOKEEPER_SERVERS}  \
        -w ml.shifu.guagua.mapreduce.example.kmeans.KMeansWorker  \
        -m ml.shifu.guagua.mapreduce.example.kmeans.KMeansMaster  \
        -c 10 \
        -n "Guagua-KMeans-Master-Workers-Job" \
        -mr ml.shifu.guagua.mapreduce.example.kmeans.KMeansMasterParams \
        -wr ml.shifu.guagua.mapreduce.example.kmeans.KMeansWorkerParams \
        -Dmapred.job.queue.name=default \
        -Dkmeans.k.number=2 \
        -Dkmeans.data.seperator="|" \
        -Dkmeans.column.number=2 \
        -Dkmeans.centers.output=kmeans-centers \
        -Dkmeans.data.output=kmeans-tags \
        -Dkmeans.k.centers=${KMEANS_INIT_CENTERS} \
        -Dguagua.master.intercepters=ml.shifu.guagua.mapreduce.example.kmeans.KMeansCentersOutput \
        -Dguagua.worker.intercepters=ml.shifu.guagua.mapreduce.example.kmeans.KMeansDataOutput
        
        
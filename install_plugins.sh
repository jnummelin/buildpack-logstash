#!/bin/bash
# assumes folders 'amazon_es', 'jsqs' already exists

LOGSTASH_VERSION="logstash-5.0.0"
REMOTE_LOGSTASH_ZIP="https://artifacts.elastic.co/downloads/logstash/$LOGSTASH_VERSION.zip"
LOCAL_LOGSTASH_DIR="$HOME/dev"
LOGSTASH_INSTALL_DIR="$HOME/logstash/$LOGSTASH_VERSION"

if [ ! -e "$LOCAL_LOGSTASH_DIR" ]; then
	mkdir -p "$LOCAL_LOGSTASH_DIR"
else
	echo "Not installing $LOCAL_LOGSTASH_DIR because it already exists"
fi

cd $LOCAL_LOGSTASH_DIR
echo "Installing $REMOTE_LOGSTASH_ZIP to $LOCAL_LOGSTASH_DIR"
curl -O https://artifacts.elastic.co/downloads/logstash/logstash-5.0.0.zip
unzip $LOGSTASH_VERSION.zip

# Install Filter prune logstash plugin
$LOCAL_LOGSTASH_DIR/$LOGSTASH_VERSION/bin/logstash-plugin install logstash-filter-prune

# Install Kinesis logstash plugin
$LOCAL_LOGSTASH_DIR/$LOGSTASH_VERSION/bin/logstash-plugin install logstash-input-kinesis

# Install Amazon Elasticsearh logstash plugin
AMAZON_ES_REPO="https://github.com/awslabs/logstash-output-amazon_es.git"
AMAZON_ES_LOCAL="$HOME/dev/amazon_es"
git clone "$AMAZON_ES_REPO" "$AMAZON_ES_LOCAL"
$LOCAL_LOGSTASH_DIR/$LOGSTASH_VERSION/bin/logstash-plugin install logstash-output-amazon_es

# Install JSQS logstash plugin
JSQS_REPO="https://github.com/JamieCressey/logstash-input-jsqs"
JSQS_LOCAL="$HOME/dev/jsqs"
git clone "$JSQS_REPO" "$JSQS_LOCAL"
$LOCAL_LOGSTASH_DIR/$LOGSTASH_VERSION/bin/logstash-plugin install logstash-input-jsqs

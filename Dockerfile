FROM debian

# variables
#echo "Declare variables"
ENV logstash_directory="logstash"
ENV logstash_version="logstash-5.0.0"
ENV amazon_es_repo="https://github.com/awslabs/logstash-output-amazon_es.git"
ENV amazon_es_local="$HOME/dev/amazon_es"
ENV jsqs_es_repo="https://github.com/JamieCressey/logstash-input-jsqs"
ENV jsqs_local="$HOME/dev/jsqs"

RUN apt-get -y update
RUN apt-get -y install oracle-java8-set-default ruby-full git
RUN git clone -b 5.2 https://github.com/elastic/logstash.git
WORKDIR /${logstash_directory}

# install prune plugin
RUN bin/logstash-plugin install logstash-filter-prune

# install kinesis plugin
RUN bin/logstash-plugin install logstash-input-kinesis

# Install Amazon Elasticsearch logstash plugin
RUN git clone "${amazon_es_repo}" "${amazon_es_local}"
RUN bin/logstash-plugin install logstash-output-amazon_es

# Install jsqs logstash plugin
RUN git clone "${jsqs_repo}" "${jsqs_local}"
RUN bin/logstash-plugin install logstash-input-jsqs

# install rspec
RUN gem install rake
RUN gem install bundler
RUN rake bootstrap
RUN rake test:install-core
RUN bin/logstash-plugin install --development

CMD ["/logstash/bin/rspec", "/logstash/${test_directory}/${test_file}"]

FROM docker.elastic.co/logstash/logstash:7.10.0

RUN set -ex; \
  ./bin/logstash-plugin install logstash-output-google_cloud_storage

CMD ["./bin/logstash", "-f", "/usr/share/logstash/pipeline/logstash.conf"]

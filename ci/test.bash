set -e

apt-get install -y git ruby2.1-dev libxslt1-dev libxml2-dev

bundle install
bundle exec rake spec:unit
bundle exec rake spec:integration:prepare
bundle exec rake spec:integration



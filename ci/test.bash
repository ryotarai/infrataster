set -e

bundle install
bundle exec rake spec:unit
bundle exec rake spec:integration:prepare
bundle exec rake spec:integration



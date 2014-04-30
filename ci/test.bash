set -e

apt-get install -y git ruby2.1-dev libxslt1-dev libxml2-dev build-essential libgecode-dev mysqlclient-dev

USE_SYSTEM_GECODE=1 bundle install
bundle exec rake spec:unit
bundle exec rake spec:integration:prepare
bundle exec rake spec:integration



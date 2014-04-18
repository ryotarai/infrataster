# Infrataster Example

```
$ cd example
$ wget https://s3-us-west-1.amazonaws.com/lightbody-bmp/browsermob-proxy-2.0-beta-9-bin.zip
$ unzip browsermob-proxy-2.0-beta-9-bin.zip
$ mv browsermob-proxy-2.0-beta-9 browsermob
$ bundle install
$ bundle exec berks vendor vendor/cookbooks
$ vagrant up
$ bundle exec rspec
```


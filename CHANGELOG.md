# Infrataster Changelog

## v0.3.2

* `http` resource: `faraday_middlewares` option
* `http` resource: `follow_redirects` option

## v0.3.1

* Accept DNS name as server address.

## v0.3.0

* [Fix deprecation of example_group in metadata (by @otahi)](https://github.com/ryotarai/infrataster/pull/64)

## v0.2.6

* [Inflate response body by gzip if inflate_gzip of http resource is true.]

## v0.2.5

* [body option of http resource](https://github.com/ryotarai/infrataster/pull/57)

## v0.2.4

* [Consider how to fetch the current example in RSpec v2.14.x (by @gongo)](https://github.com/ryotarai/infrataster/pull/56)

## v0.2.3

* [http resource supports basic auth. (by @winebarrel)](https://github.com/ryotarai/infrataster/pull/54)

## v0.2.2

* Server can be defined by block. (https://github.com/ryotarai/infrataster/pull/51 by @otahi)

## v0.2.1

* `http` resource support `ssl` option which is passed to Faraday.new (by @SnehaM)

## v0.2.0

* No change

## v0.2.0.beta1

* Support RSpec 3.x
  * Some deprecation warnings remain.
  * RSpec 2.x is supported too.

## v0.1.13

* Make Infrataster's methods available in before(:all) block. (by @KitaitiMakoto)

## v0.1.12

* Add infrataster command to create template directory.
* Specify host in a option passed to Server.define. (by @KitaitiMakoto)
* Add Server#ssh method. (by @KitaitiMakoto)

## v0.1.11

* Slight bug fixes

## v0.1.10

* rspec ~> 2.0

## v0.1.9

* Add "fuzzy IP address" feature which determine IP address by CIDR or netmask.

## v0.1.8

* Use Poltergeist's header manipulation instead of BrowserMob Proxy. Remove BrowserMob Proxy dependency.

## v0.1.7

* Fix a key name in a config passed to Net::SSH.start. (by @rrreeeyyy)

## v0.1.6

* Implement `Server#ssh_exec` which executes a command on the server via SSH.

## v0.1.5

* Extract mysql resource to [infrataster-plugin-mysql](https://github.com/ryotarai/infrataster-plugin-mysql).

## v0.1.4

* Include RSpec::Matchers to use be_xxx matchers. (by @KitaitiMakoto)
* Don't raise any error for subjects which is not related to Infrataster. (by @KitaitiMakoto)

## v0.1.3

* Don't create multiple phantomjs and browsermob proxy. `capybara` resources become faster.

## v0.1.2

* Use poltergeist (PhantomJS) as capybara driver instead of selenium-webdriver.

## v0.1.1

* Http resources accept `method`, `params` and `headers` options. (Issue #7)

## v0.1.0

* Initial release

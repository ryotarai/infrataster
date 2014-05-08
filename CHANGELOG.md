# Infrataster Changelog

## v0.1.6

* Implement `Server#ssh\_exec` which executes a command on the server via SSH.

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


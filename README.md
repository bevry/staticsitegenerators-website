<!-- TITLE/ -->

<h1>Static Site Generators Website</h1>

<!-- /TITLE -->


<!-- BADGES/ -->

<span class="badge-travisci"><a href="http://travis-ci.org/bevry/staticsitegenerators-website" title="Check this project's build status on TravisCI"><img src="https://img.shields.io/travis/bevry/staticsitegenerators-website/master.svg" alt="Travis CI Build Status" /></a></span>
<br class="badge-separator" />
<span class="badge-patreon"><a href="https://patreon.com/bevry" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-yellow.svg" alt="Patreon donate button" /></a></span>
<span class="badge-opencollective"><a href="https://opencollective.com/bevry" title="Donate to this project using Open Collective"><img src="https://img.shields.io/badge/open%20collective-donate-yellow.svg" alt="Open Collective donate button" /></a></span>
<span class="badge-gratipay"><a href="https://www.gratipay.com/bevry" title="Donate weekly to this project using Gratipay"><img src="https://img.shields.io/badge/gratipay-donate-yellow.svg" alt="Gratipay donate button" /></a></span>
<span class="badge-flattr"><a href="https://flattr.com/profile/balupton" title="Donate to this project using Flattr"><img src="https://img.shields.io/badge/flattr-donate-yellow.svg" alt="Flattr donate button" /></a></span>
<span class="badge-paypal"><a href="https://bevry.me/paypal" title="Donate to this project using Paypal"><img src="https://img.shields.io/badge/paypal-donate-yellow.svg" alt="PayPal donate button" /></a></span>
<span class="badge-bitcoin"><a href="https://bevry.me/bitcoin" title="Donate once-off to this project using Bitcoin"><img src="https://img.shields.io/badge/bitcoin-donate-yellow.svg" alt="Bitcoin donate button" /></a></span>
<span class="badge-wishlist"><a href="https://bevry.me/wishlist" title="Buy an item on our wishlist for us"><img src="https://img.shields.io/badge/wishlist-donate-yellow.svg" alt="Wishlist browse button" /></a></span>
<br class="badge-separator" />
<span class="badge-slackin"><a href="https://slack.bevry.me" title="Join this project's slack community"><img src="https://slack.bevry.me/badge.svg" alt="Slack community badge" /></a></span>

<!-- /BADGES -->


<!-- DESCRIPTION/ -->

The definitive listing of Static Site Generators

<!-- /DESCRIPTION -->


## How it works

This is a [DocPad](http://docpad.org) website that automatically pulls in the latest listing data from [bevry/staticsitegenerators-list](https://github.com/bevry/staticsitegenerators-list) and renders it nicely.

In the future we'd like to add the following to the listing:

- Project Maturity
	- Contributors
	- Commits

As well as add a link to the [Go Static Campaign](https://github.com/bevry/gostatic) to help educate people about the benefits of Static Site Generators.


## Getting Started

1. [Install DocPad](http://docpad.org/install)

1. Clone the project and run the server

	``` bash
	git clone git://github.com/bevry/staticsitegenerators-website.git
	cd staticsitegenerators-website
	npm install
	docpad run
	```

1. [Open http://localhost:9778/](http://localhost:9778/)

1. Start hacking away by modifying the `src` directory


## FAQ

### My favourite SSG is not listed!
[Add it here](https://github.com/bevry/staticsitegenerators-list/edit/master/list.yaml)

### This website sucks, I could do better!
Please do, but please do it as part of this community effort. This effort has only just begun, and we need as little fragmentation in the community as possible if we are to get more people onboard the static site generator movement. Please provide your suggestions in the issue tracker, as well as submit your pull requests. We'd be hugely appreciative! Together, we can create something great.

### Why did you create this?
There are so many SSG listings across the web, but we needed to have one that automatically stayed up to date as changes happened. The DocPad dynamic infrastructure here will allow that to happen. We've also come to find the SSG movement is struggling to get enterprise clients onboard, because they are all trying to create their own fragmented listings pitching their own static site generators, which doesn't help anyone. We need one listing, and one effort, that the entire SSG community can get behind. As such, we will list all SSGs in the most humble of ways and not discriminate against any.


<!-- LICENSE/ -->

<h2>License</h2>

Unless stated otherwise all works are:

<ul><li>Copyright &copy; <a href="http://bevry.me">Bevry Pty Ltd</a></li></ul>

and licensed under:

<ul><li><a href="http://spdx.org/licenses/MIT.html">MIT License</a></li>
<li>and</li>
<li><a href="http://spdx.org/licenses/CC-BY-4.0.html">Creative Commons Attribution 4.0</a></li></ul>

<!-- /LICENSE -->

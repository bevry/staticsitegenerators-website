'use strict'

// Prepare
const listing = require('staticsitegenerators')
const moment = require('moment')
const websiteVersion = require('./package.json').version

// The DocPad Configuration File
// It is simply a CoffeeScript Object which is parsed by CSON
module.exports = {
	// =================================
	// Template Data
	// These are variables that will be accessible via our templates
	// To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData: {
		// Moment
		moment,

		// Add the listing
		listing: listing.hydrated,

		// Specify some site properties
		site: {
			// The production url of our website
			url: 'https://staticsitegenerators.net',

			// The default title of our website
			title: 'Static Site Generators',

			// The website description (for SEO)
			description: 'The definitive listing of Static Site Generators',

			// The website keywords (for SEO) separated by commas
			keywords:
				'static site generator, static site, static, site, web site, web app, app, application, web application, seo, search engine optimisation, fast, flat file, cms, content management system, nosql, node.js, ruby, javascript, python',

			// The website's styles
			styles: ['/vendor/normalize.css', '/styles/style.css'].map(
				url => `${url}?websiteVersion=${websiteVersion}`
			),

			// The website's scripts
			scripts: ['/vendor/sorttable.js'].map(
				url => `${url}?websiteVersion=${websiteVersion}`
			),

			services: {
				githubStarButton: 'bevry/staticsitegenerators-list'
			}
		},

		// -----------------------------
		// Helper Functions

		// Get the prepared site/document title
		// Often we would like to specify particular formatting to our page's title
		// we can apply that formatting here
		getPreparedTitle() {
			// if we have a document title, then we should use that and suffix the site's title onto it
			if (this.document.title) {
				return `${this.document.title} | ${this.site.title}`
			}
			// if our document does not have it's own title, then we should just use the site's title
			else {
				return this.site.title
			}
		},

		// Get the prepared site/document description
		getPreparedDescription() {
			// if we have a document description, then we should use that, otherwise use the site's description
			return this.document.description || this.site.description
		},

		// Get the prepared site/document keywords
		getPreparedKeywords() {
			// Merge the document keywords with the site keywords
			return this.site.keywords.concat(this.document.keywords || []).join(', ')
		}
	}
}

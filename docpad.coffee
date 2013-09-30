# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# DocPad Properties

	rengerateEvery: 1000*60*60  # hour


	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://staticsitegenerators.net"

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.staticsitegenerators.net',
				#'staticsitegenerators.herokuapp.com'
				'bevry.github.io'
			]

			# The default title of our website
			title: "Static Site Generators"

			# The website description (for SEO)
			description: """
				The ultimate crowd-sourced listing of Static Site Generators
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				static site generator, static site, static, site, web site, web app, app, application, web application, seo, search engine optimisation, fast, flat file, cms, content management system, nosql, node.js, ruby, javascript, python
				"""

			# The website's styles
			styles: [
				'/vendor/normalize.css'
				'/vendor/semanticui/css/semantic.min.css'
				'/styles/style.css'
			]

			# The website's scripts
			scripts: [
				'/vendor/semanticui/javascript/semantic.min.js'
				'/scripts/script.js'
			]

			services:
				facebookLikeButton:
					applicationId: '266367676718271'
				githubStarButton: 'bevry/staticsitegenerators'

				googleAnalytics: 'UA-35505181-5'


		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# DocPad Plugins

	plugins:
		downloader:
			downloads: [
				{
					name: 'SSG Listing'
					url: 'https://raw.github.com/jaspervdj/static-site-generator-comparison/master/list.yaml'
					path: 'src/documents/list.json.yaml'
					refresh: true
				}
			]

	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()
}

# Export our DocPad Configuration
module.exports = docpadConfig
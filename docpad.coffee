# Prepare
projects = []
websiteVersion = require('./package.json').version
lastSucessfulFeedResult = null

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# DocPad Properties

	rengerateEvery: maxAge = 1000*60*60*24  # day

	logLevel: 7


	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Moment
		moment: (try require('moment'))

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://staticsitegenerators.net"

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.staticsitegenerators.net',
				'staticsitegenerators.herokuapp.com'
				'bevry.github.io'
			]

			# The default title of our website
			title: "Static Site Generators"

			# The website description (for SEO)
			description: """
				The definitive listing of Static Site Generators
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
			].map (url) -> "#{url}?websiteVersion=#{websiteVersion}"

			# The website's scripts
			scripts: [
				'/vendor/semanticui/javascript/semantic.min.js'
				'//cdnjs.cloudflare.com/ajax/libs/floatthead/1.2.7/jquery.floatThead.min.js'
				'/scripts/tablesort.js'
				'/scripts/script.js'
			].map (url) -> "#{url}?websiteVersion=#{websiteVersion}"

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

		# Get Projects
		getProjects: -> projects


	# =================================
	# DocPad Collections

	collections:
		regenerateOnWebhook: (database) ->
			return database.findAllLive(regenerateOnWebhook:true)


	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Generate Before
		generateBefore: (opts, next) ->
			return next()  unless opts.reset is true
			docpad = @docpad

			# Fetch the latest projects
			docpad.log 'info', 'Fetching the latest static site generators'
			require('feedr').create({log: docpad.log}).readFeed 'https://raw.github.com/jaspervdj/static-site-generator-comparison/master/list.yaml', (err, data) ->

				# Handle errors kind of safely
				if err
					opts.templateData.error = err.message
					return next()

				# Prepare the entries for the projects
				# and extract the repo names
				repoFullNames = []
				projectsMap = []
				for entry in data
					repoFullNames.push(entry.github)  if entry.github
					key = (entry.github or entry.website or '').toLowerCase()
					unless key
						console.log 'missing details for:', entry
						continue
					projectsMap[key] = entry

				# Fetch the github data for the repos
				docpad.log 'info', "Fetching the github information for the static site generators, all #{repoFullNames.length} of them"
				require('getrepos').create(log: docpad.log, cache:maxAge).fetchRepos repoFullNames, (err,repos) ->
					return next(err)  if err

					# Prepare the proejcts with the github data
					for githubData in repos
						key = githubData.full_name.toLowerCase()

						# Confirm existance as name may have changed from the listing
						unless projectsMap[key]?
							console.log githubData.full_name, 'is missing'
							continue

						# Apply github data
						projectsMap[key].githubData = githubData

						# Ensure website
						if !projectsMap[key].website and githubData.homepage and githubData.homepage.toLowerCase().indexOf('github.com/'+key) is -1
							projectsMap[key].website = githubData.homepage

					# Prepare the extra data and add the projects listing
					projects = []
					for own key,project of projectsMap
						projects.push
							# Listing Only
							name: project.name
							github: project.github or null
							license: project.license or null
							# Listing or GitHub
							website: project.website or project.githubData?.homepage or null
							description: project.description or project.githubData?.description or null
							language: project.language or project.githubData?.language or null
							created_at: project.created_at or project.githubData?.created_at or null
							# GitHub only
							stars: project.githubData?.watchers or null
							updated_at: project.githubData?.pushed_at or null

					# Sort the projects
					projects = projects.sort (a,b) ->
						A = a.name.toLowerCase()
						B = b.name.toLowerCase()
						if A is B
							0
						else if A < B
							-1
						else
							1

					# Complete
					docpad.log 'info', "Fetched the github information for the static site generators, all #{repos.length} of them"
					return next()

			# Return
			return true

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

			# Redirect Hook
			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()

			# DocPad Regenerate Hook
			# Automatically regenerate when new changes are pushed to our documentation
			server.all '/regenerate', (req,res) ->
				if req.query?.key is process.env.WEBHOOK_KEY
					docpad.log('info', 'Regenerating started from webhook')
					docpad.action 'generate', {collection:docpad.getCollection('regenerateOnWebhook')}, (err) ->
						if err
							res.send(500, err?.message or err)
						else
							res.send(200, 'regenerated')
				else
					res.send(400, 'key is incorrect')

			# Return
			return true
}

# Export our DocPad Configuration
module.exports = docpadConfig

# Prepare
projects = []
websiteVersion = require('./package.json').version
lastSucessfulFeedResult = null
feedr = null
maxAge = 1000*60*60*24  # day
failOnError = true # otherwise Boolean(process.env.TRAVIS_NODE_VERSION)
handleError = (err, opts, next) ->
	errorString = (err.stack or err.message or err).toString()
	if failOnError
		# Exit with the error
		next(err)
	else
		# Output the error to the console
		console.error(errorString)
		
		# Pass the error to our template data for our template to render it
		opts.templateData.error = errorString
		
		# Continue with execution so the error can be displayed
		next()

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig =

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

				#googleAnalytics: 'UA-35505181-5'
				# ^ no more external analytics, cloudflare gives us what we need


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
	# Plugins

	# Define a custom collection for cleanurls that ignores the documents we don't want
	collections:
		cleanurls: ->
			@getCollection('html').findAllLive(cleanurls: true)

	# =================================
	# Plugins

	plugins:
		cleanurls:
			collectionName: 'cleanurls'
			advancedRedirects: [
				# Old URLs
				[/^https?:\/\/(?:www\.staticsitegenerators\.net|staticsitegenerators\.herokuapp\.com|bevry\.github\.io\/staticsitegenerators)(.*)$/, 'https://staticsitegenerators.net$1']
			]

	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Generate Before
		generateBefore: (opts, next) ->
			return next()  unless opts.reset is true
			docpad = @docpad
			feedr ?= require('feedr').create({log: docpad.log})

			# Fetch the latest projects
			docpad.log 'info', 'Fetching the latest static site generators'
			feed =
				url: 'https://raw.github.com/bevry/staticsitegenerators-list/master/list.yaml'
				parse: 'yaml'
				cache: false
			feedr.readFeed feed, (err, data) ->
				return handleError(err)  if err
				return handleError(new Error("No data was retrieved from the yaml file!"))  unless data
				
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
				getReposConfig =
					log: docpad.log
					cache: maxAge
					githubClientId: process.env.BEVRY_GITHUB_CLIENT_ID
					githubClientSecret: process.env.BEVRY_GITHUB_CLIENT_SECRET
				require('getrepos').create(getReposConfig).fetchRepos repoFullNames, (err, repos) ->
					return handleError(err)  if err

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


# Export our DocPad Configuration
module.exports = docpadConfig

# Requires
docpad = require('docpad')
express = require('express')


# =====================================
# Configuration

# Port
# Check our environment for our port number otherwise use a default port
# Usually, node.js webservers will set the process.env.PORT variable to the port we should use
# The process.env.WEBSITEPORT variable can be customised by our parent application if this site is only a module
docpadPort = process.env.WEBSITEPORT || process.env.PORT || 10113

# Create Servers
# Create our webserver to be used with DocPad
docpadServer = express.createServer()

# Prepare our DocPad configuration
docpadConfig =
	checkVersion: false
	port: docpadPort
	maxAge: 86400000  # one day
	server: docpadServer
	#templateData:
	#	require: require  # make node.js's require function available to our templates


# =====================================
# Start & Extend DocPad

# Create DocPad with our configuration, and wait for it to load
docpadInstance = docpad.createInstance docpadConfig, (err) ->
	# Prepare
	throw err  if err


	# ---------------------------------
	# Server Configuration

	# Redirect Middleware
	# Used to redirect from serveral other locations our website is accessible from
	# to another location
	docpadServer.use (req,res,next) ->
		if req.headers.host in ['www.website.com','website.herokuapp.com']  # from location
			res.redirect('http://website.com'+req.url, 301)  # to location
		else
			next()

	# Start our server, and perform an initial generation
	docpadInstance.action 'server generate', (err) ->
		throw err  if err


	# ---------------------------------
	# Server Extensions

	# Redirect /madewith to http://docpad.io
	# feel free to remove this if you don't think it is an awesome idea
	docpadServer.get '/madewith', (req, res) ->
		project = req.params[0]
		res.redirect('http://docpad.io/', 301)


# =====================================
# Exports

# Export the DocPad Server we created
module.exports = docpadServer

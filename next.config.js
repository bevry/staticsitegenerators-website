// https://spectrum.chat/zeit/general/unable-to-import-module-now-launcher-error~2662f0ba-4186-402f-b1db-2e3c43d8689a?m=MTU0NTEyNjk4ODE3Mw==
const env =
	process.env.NODE_ENV === 'development'
		? {} // We're never in "production server" phase when in development mode
		: !process.env.NOW_REGION
		? require('next/constants') // Get values from `next` package when building locally
		: require('next-server/constants') // Get values from `next-server` package when building on now v2

module.exports = (phase, { defaultConfig }) => {
	if (phase === env.PHASE_PRODUCTION_SERVER) {
		// Config used to run in production.
		return {}
	}

	const withTypescript = require('@zeit/next-typescript')
	return withTypescript()
}

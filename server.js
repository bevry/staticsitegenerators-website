require('docpad').createInstance(function(err,docpadInstance){
	if (err)  return console.log(err.stack);
	docpadInstance.action('generate server',function(err){
		if (err)  return console.log(err.stack);
		console.log('OK')
	});
});
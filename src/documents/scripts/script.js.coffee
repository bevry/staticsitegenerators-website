$ ->
	initSort = ->
		$('.table.sortable').tablesort().on('tablesort:complete', initPopups)
	initPopups = ->
		$('.project.title')
			.popup()
			.popup('setting', 'delay', 0)
			.popup('setting', 'duration', 0)
			.popup('setting', 'position', 'top left')
			.popup('setting', 'inline', false)

	initSort()
	initPopups()
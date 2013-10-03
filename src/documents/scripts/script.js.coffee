$ ->
	initSort = ->
		$('.table.sortable')
			.tablesort()
			.on('tablesort:complete', initPopups)
			.find('th.date')
				.data 'sortBy', (th, td, sorter)  ->
					console.log td.data('sort-value')
					parseInt(td.data('sort-value'), 10)
	initPopups = ->
		$('.project.title')
			.popup()
			.popup('setting', 'delay', 0)
			.popup('setting', 'duration', 0)
			.popup('setting', 'position', 'top left')
			.popup('setting', 'inline', false)

	initSort()
	initPopups()
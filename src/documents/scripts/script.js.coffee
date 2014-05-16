$ ->
	initSort = ->
		$('.table.sortable')
			.tablesort()
			.on('tablesort:complete', initPopups)
			.find('th.numeric-sort')
			.data('sortBy', (th, td, sorter)  ->
				parseInt(td.data('sort-value'), 10)
			).end()
			.floatThead(useAbsolutePositioning: false)
	initPopups = ->
		$('.project.title')
			.popup()
			.popup('setting', 'delay', 0)
			.popup('setting', 'duration', 0)
			.popup('setting', 'position', 'top left')
			.popup('setting', 'inline', false)

	initSort()
	initPopups()
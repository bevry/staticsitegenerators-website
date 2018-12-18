import Head from 'next/head'
import Project from '../components/project'
import fetch from 'isomorphic-unfetch'
import { useState } from 'react'
import moment from 'moment'

type List = Array<any>
type Direction = -1 | 1

const numericCompare = (a: number, b: number) => a - b
const alphaCompare = (a: any, b: any) => (a < b ? -1 : a > b ? 1 : 0)
const lower = (value: any) => String(value || '').toLowerCase()
const number = (value: any) => value || 0
const date = (value: any) => moment(value || 0).unix()

interface Column {
	id: string
	name: string
	parse: (value: any) => any
	compare: (a: any, b: any) => number
	direction?: Direction
}
interface Table {
	columns: Column[]
	list: List
	last?: string
}

const Index = ({ listing }: { listing: List }) => {
	const [table, setTable] = useState<Table>({
		columns: [
			{
				id: 'stars',
				name: 'Stars',
				parse: number,
				compare: numericCompare
			},
			{
				id: 'name',
				name: 'Name',
				parse: lower,
				compare: alphaCompare
			},
			{
				id: 'license',
				name: 'License',
				parse: lower,
				compare: alphaCompare
			},
			{
				id: 'language',
				name: 'Language',
				parse: lower,
				compare: alphaCompare
			},
			{
				id: 'created_at',
				name: 'Created',
				parse: date,
				compare: numericCompare
			},
			{
				id: 'updated_at',
				name: 'Updated',
				parse: date,
				compare: numericCompare
			}
		],
		list: listing
	})

	function updateOrder(key: string) {
		const columns = table.columns.slice()
		const column = columns.find(column => column.id === key)
		if (!column) throw new Error('could not find the column')
		column.direction = column.direction === -1 ? 1 : -1
		const list = table.list.sort(function(A, B) {
			const a = column.parse(A[column.id])
			const b = column.parse(B[column.id])
			const z = column.compare(a, b) * (column.direction as number)
			return z
		})
		setTable({ columns, list, last: key })
	}

	function handleOrder(key: string) {
		return () => updateOrder(key)
	}
	function getDirectionIcon(value: Direction) {
		return value === -1 ? '⬇️' : '⬆️'
	}

	const items = table.list.map(project => (
		<Project key={project.id} project={project} />
	))

	return (
		<div>
			<Head>
				<title>Static Site Generators</title>
				<meta
					name="keywords"
					content="static site generator, static site, static, site, web site, web app, app, application, web application, seo, search engine optimisation, fast, flat file, cms, content management system, nosql, node.js, ruby, javascript, python"
				/>
				<link rel="stylesheet" href="//unpkg.com/normalize.css/normalize.css" />
				<link rel="stylesheet" href="/static/style.css" />
			</Head>

			<header className="header">
				<h1>Static Site Generators</h1>
				<h2>
					The definitive listing of Static Site Generators &mdash; all{' '}
					{table.list.length} of them!
				</h2>
			</header>

			<article>
				<table>
					<thead>
						<tr>
							{table.columns.map(column => (
								<th
									key={column.id}
									className={column.id}
									onClick={handleOrder(column.id)}
								>
									{column.name}{' '}
									{table.last === column.id
										? getDirectionIcon(column.direction as Direction)
										: ''}
								</th>
							))}
						</tr>
					</thead>
					<tbody>{items}</tbody>
					<tfoot />
				</table>

				<footer>
					<a
						href="https://github.com/bevry/staticsitegenerators-list"
						title="Update this static site generator listing"
					>
						Update Listing
					</a>
					<a
						href="https://github.com/bevry/staticsitegenerators-website"
						title="Update this website&rsquo;s content"
					>
						Update Website
					</a>
					<a href="./list.json" title="Get the listing in the JSON data format">
						JSON Data
					</a>
				</footer>
			</article>
		</div>
	)
}

Index.getInitialProps = async () => {
	// const res = await fetch('/list.json')
	const res = await fetch('https://unpkg.com/staticsitegenerators@2/out.json')
	const json = await res.json()
	return { listing: json }
}

export default Index

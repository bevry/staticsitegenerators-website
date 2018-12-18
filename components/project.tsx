import moment from 'moment'
const Project = ({ project }: { project: any }) => {
	const stars = project.stars ? (
		<span>
			{project.stars}
			⭐️
		</span>
	) : (
		''
	)
	const name = project.website ? (
		<a href="{project.website}" title="Visit {project.name}&rsquo;s website">
			{project.name}
		</a>
	) : (
		project.name
	)
	const github = project.github ? (
		<a
			href="https://github.com/{project.github}"
			title="Visit {project.name}&rsquo;s GitHub repository"
		>
			<i className="icon github" />
		</a>
	) : (
		''
	)
	return (
		<tr className="project">
			<td className="stars">{stars}</td>
			<td className="name">
				<label>
					{name}
					{github}
				</label>
				<span>{project.description}</span>
			</td>
			<td className="license">{project.license || ''}</td>
			<td className="language">{project.language || ''}</td>
			<td className="created_at">
				{project.created_at ? moment(project.created_at).fromNow() : ''}
			</td>
			<td className="updated_at">
				{project.updated_at ? moment(project.updated_at).fromNow() : ''}
			</td>
		</tr>
	)
}
export default Project

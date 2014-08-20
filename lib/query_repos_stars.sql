SELECT
  repository_language
, repository_name
, repository_owner
, repository_url
, repository_description
, repository_homepage
, MAX(repository_watchers) as stars
, MAX(repository_forks) as forks
, MIN(DATE(repository_created_at)) as date
FROM [githubarchive:github.timeline]
WHERE
  PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('2014-08-01 00:00:00')
GROUP BY repository_language, repository_name, repository_owner
ORDER BY stars DESC;
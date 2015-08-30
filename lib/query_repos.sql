SELECT 
   gt.repository_name as repo_name
  ,gt.repository_owner as owner
  ,gt.repository_language as language
  ,gt.repository_created_at as created_at
  ,gt.repository_url as url
  ,gt.repository_homepage as homepage
  ,gt.repository_forks as forks
  ,gt.repository_watchers as stars
  ,gt.created_at as action_at
  ,gt.repository_description as description
FROM githubarchive:github.timeline gt
INNER JOIN EACH(
    SELECT 
      repository_name
     ,MAX(repository_watchers) as stars
     ,MAX(created_at) AS created_at
    FROM githubarchive:github.timeline 
    WHERE
      PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC("2014-01-01 00:00:00")
      AND repository_watchers > 0
    GROUP BY repository_name
    ORDER BY stars DESC
  ) top_repo
  ON top_repo.repository_name = gt.repository_name
  AND top_repo.created_at = gt.created_at
  AND top_repo.stars = gt.repository_watchers
ORDER BY stars desc
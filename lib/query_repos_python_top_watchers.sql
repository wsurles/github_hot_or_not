SELECT 
   gt.repository_name as repository_name
  ,repository_owner
  ,repository_created_at
  ,repository_url
  ,repository_description
  ,repository_homepage
  ,repository_forks
  ,gt.repository_watchers as repository_watchers
  ,gt.created_at as created_at
FROM [githubarchive:github.timeline] gt
INNER JOIN (
    SELECT 
      repository_name
     ,MAX(repository_watchers) as repository_watchers
     ,MAX(created_at) AS created_at
    FROM [githubarchive:github.timeline] 
    WHERE
      PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC("2014-01-01 00:00:00") 
      AND repository_language = 'Python'
      AND repository_watchers > 0
    GROUP BY repository_name
    ORDER BY repository_watchers DESC
    LIMIT 200
  ) top_repo
  ON top_repo.repository_name = gt.repository_name
  AND top_repo.created_at = gt.created_at
  AND top_repo.repository_watchers = gt.repository_watchers
ORDER BY repository_watchers desc
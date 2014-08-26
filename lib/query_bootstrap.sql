SELECT 
   repository_language as language
  ,repository_name as repo_name
  ,actor
  ,actor_attributes_name
  ,type
  ,created_at
FROM [githubarchive:github.timeline] gt
WHERE repository_name = 'bootstrap'
  AND created_at > '2014-08-01 00:00:00'
ORDER BY created_at desc
SELECT 
   gt.repository_language as language
  ,gt.repository_name as repo_name
  ,gt.actor as actor
  ,actor_attributes_name
  ,events
  ,actor_attributes_gravatar_id
  ,actor_attributes_company
  ,actor_attributes_location
  ,actor_attributes_blog
  ,gt.created_at as created_at
FROM [githubarchive:github.timeline] gt
INNER JOIN EACH(
    SELECT 
      actor
     ,COUNT(type) as events
     ,MAX(created_at) AS created_at
    FROM [githubarchive:github.timeline] 
    WHERE type in ('PushEvent', 'CreateEvent') 
      AND repository_name IN ('bootstrap', 'Font-Awesome','foundation', 'animate.css', 'normalize.css')
    GROUP BY actor
    ORDER BY events DESC
  ) actor_events
  ON actor_events.actor = gt.actor
  AND actor_events.created_at = gt.created_at
WHERE type in ('PushEvent', 'CreateEvent') 
ORDER BY events desc
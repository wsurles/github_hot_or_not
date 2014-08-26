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
    ,repository_name
    FROM [githubarchive:github.timeline] 
    WHERE type in ('PushEvent', 'CreateEvent') 
    AND repository_name IN ('ML_for_Hackers','ggplot2','devtools','shiny','knitr','hyperq','dplyr','slidify','plyr','swirl_courses','ggvis','ProjectTemplate','ggthemes','rplos','SparkR-pkg','Truthcoin')
    GROUP BY actor, repository_name
    ORDER BY events DESC
  ) actor_events
  ON actor_events.actor = gt.actor
  AND actor_events.created_at = gt.created_at
  WHERE type in ('PushEvent', 'CreateEvent') 
  ORDER BY events desc
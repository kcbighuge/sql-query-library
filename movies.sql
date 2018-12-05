-- movielens dataset: https://blazer.dokkuapp.com/queries/schema?data_source=movielens
-- https://blazer.dokkuapp.com/queries/new
-- For each movie genre, how many different genres are the movies in?
-- Return the average and max number of genres, ordered by the avg

-- genres per movie
select movie_id, count(genre_id)
from genres_movies
group by movie_id
limit 10;

-- movies per genre (18 genres)
select genre_id, count(movie_id)
from genres_movies
group by genre_id
limit 10;

-- genres per movie
WITH genre_ct AS (
	select movie_id, count(genre_id) 
	from genres_movies 
	group by movie_id)
select * from genre_ct
limit 10;

-- genres per movie with genre id and names
WITH g_ct AS (
	select movie_id, count(genre_id) 
	from genres_movies 
	group by movie_id)
select * from g_ct
join genres_movies gm
on gm.movie_id = g_ct.movie_id
join genres g
on g.id = gm.genre_id
order by genre_id
limit 500;

-- avg and max genres per movie
WITH g_ct AS (
	select movie_id, count(genre_id) num_genres
	from genres_movies 
	group by movie_id)

select distinct g.name, 
    avg(g_ct.num_genres) over (partition by g.name) avg_genres, 
    max(g_ct.num_genres) over (partition by g.name) max_genres
from g_ct
join genres_movies gm
on gm.movie_id = g_ct.movie_id
join genres g
on g.id = gm.genre_id
order by avg_genres desc;

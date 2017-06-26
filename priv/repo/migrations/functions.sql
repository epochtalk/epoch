SET search_path = public, pg_catalog;

--
-- Name: create_post(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION create_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- LOCKS
    PERFORM 1 FROM threads WHERE id = NEW.thread_id FOR UPDATE;
    PERFORM 1 FROM users.profiles WHERE user_id = NEW.user_id FOR UPDATE;

    -- increment users.profiles' post_count
    UPDATE users.profiles SET post_count = post_count + 1 WHERE user_id = NEW.user_id;

    -- update thread's created_at
    UPDATE threads SET created_at = (SELECT created_at FROM posts WHERE thread_id = NEW.thread_id ORDER BY created_at limit 1) WHERE id = NEW.thread_id;

    -- update thread's updated_at
    UPDATE threads SET updated_at = (SELECT created_at FROM posts WHERE thread_id = NEW.thread_id ORDER BY created_at DESC limit 1) WHERE id = NEW.thread_id;

    -- update with post position and account for deleted (hidden) posts
    UPDATE posts SET position = (SELECT post_count + 1 + (SELECT COUNT(*) FROM posts WHERE thread_id = NEW.thread_id AND deleted = true) FROM threads WHERE id = NEW.thread_id) WHERE id = NEW.id;

    -- increment metadata.threads' post_count
    UPDATE threads SET post_count = post_count + 1 WHERE id = NEW.thread_id;

    RETURN NEW;
  END;
$$;


--
-- Name: create_thread(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION create_thread() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- increment metadata.boards' thread_count
    UPDATE boards SET thread_count = thread_count + 1 WHERE id = NEW.board_id;

    RETURN NEW;
  END;
$$;


--
-- Name: delete_post(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION delete_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- LOCKS
    PERFORM 1 FROM threads WHERE id = OLD.thread_id FOR UPDATE;
    PERFORM 1 FROM users.profiles WHERE user_id = OLD.user_id FOR UPDATE;

    -- ONLY UPDATE COUNTS IF THE POST ISN'T ALREADY DELETED/HIDDEN
    IF (OLD.deleted != true) THEN
      -- decrement users.profiles' post_count
      UPDATE users.profiles SET post_count = post_count - 1 WHERE user_id = OLD.user_id;

      -- update thread's updated_at to last post available
      UPDATE threads SET updated_at = (SELECT created_at FROM posts WHERE thread_id = OLD.thread_id ORDER BY created_at DESC limit 1) WHERE id = OLD.thread_id;
    END IF;

    -- update post positions for all higher post positions
    UPDATE posts SET position = position - 1 WHERE position > OLD.position AND thread_id = OLD.thread_id;

    -- ONLY UPDATE COUNTS IF THE POST ISN'T ALREADY DELETED/HIDDEN
    IF (OLD.deleted != true) THEN
      -- decrement metadata.threads' post_count
      UPDATE threads SET post_count = post_count - 1 WHERE id = OLD.thread_id;
    END IF;

    RETURN OLD;
  END;
$$;


--
-- Name: delete_thread(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION delete_thread() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- decrement metadata.boards' thread_count and post_count
    UPDATE boards SET post_count = post_count - OLD.post_count WHERE id = OLD.board_id;

    -- decrement metadata.boards' thread_count
    UPDATE boards SET thread_count = thread_count - 1 WHERE id = OLD.board_id;

    -- update metadata.boards' last post information
    UPDATE metadata.boards
    SET last_post_username = username,
        last_post_created_at = created_at,
        last_thread_id = thread_id,
        last_thread_title = title,
        last_post_position = position
    FROM (
      SELECT pLast.username as username,
             pLast.created_at as created_at,
             t.id as thread_id,
             pFirst.title as title,
             pLast.position as position
      FROM (
        SELECT id
        FROM threads
        WHERE board_id = OLD.board_id
        ORDER BY updated_at DESC LIMIT 1
      ) t LEFT JOIN LATERAL (
        SELECT p.content ->> 'title' as title
        FROM posts p
        WHERE p.thread_id = t.id
        ORDER BY p.created_at LIMIT 1
      ) pFirst ON true LEFT JOIN LATERAL (
        SELECT u.username, p.position, p.created_at
        FROM posts p LEFT JOIN users u ON u.id = p.user_id
        WHERE p.thread_id = t.id
        ORDER BY p.created_at DESC LIMIT 1
      ) pLast ON true
    ) AS subquery
    WHERE board_id = OLD.board_id;

    RETURN OLD;
  END;
$$;


--
-- Name: hide_post(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION hide_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
      -- LOCKS
      PERFORM 1 FROM threads WHERE id = OLD.thread_id FOR UPDATE;
      PERFORM 1 FROM users.profiles WHERE user_id = OLD.user_id FOR UPDATE;

      -- decrement users.profiles' post_count
      UPDATE users.profiles SET post_count = post_count - 1 WHERE user_id = OLD.user_id;

      -- update thread's updated_at to last post available
      UPDATE threads SET updated_at = (SELECT created_at FROM posts WHERE thread_id = OLD.thread_id ORDER BY created_at DESC limit 1) WHERE id = OLD.thread_id;

      -- decrement metadata.threads' post_count
      UPDATE threads SET post_count = post_count - 1 WHERE id = OLD.thread_id;

      RETURN OLD;
  END;
$$;


--
-- Name: search_index_post(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION search_index_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- increment users.profiles' post_count
    UPDATE posts SET
        tsv = x.tsv
    FROM (
        SELECT id,
               setweight(to_tsvector('simple', COALESCE(content ->> 'title','')), 'A') ||
               setweight(to_tsvector('simple', COALESCE(content ->> 'body','')), 'B')
               AS tsv
         FROM posts WHERE id = NEW.id
    ) AS x
    WHERE x.id = posts.id;

    RETURN NEW;
  END;

$$;


--
-- Name: unhide_post(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION unhide_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
      -- LOCKS
      PERFORM 1 FROM threads WHERE id = NEW.thread_id FOR UPDATE;
      PERFORM 1 FROM users.profiles WHERE user_id = NEW.user_id FOR UPDATE;

      -- increment users.profiles' post_count
      UPDATE users.profiles SET post_count = post_count + 1 WHERE user_id = NEW.user_id;

      -- update thread's created_at
      UPDATE threads SET created_at = (SELECT created_at FROM posts WHERE thread_id = NEW.thread_id ORDER BY created_at limit 1) WHERE id = NEW.thread_id;

      -- update thread's updated_at
      UPDATE threads SET updated_at = (SELECT created_at FROM posts WHERE thread_id = NEW.thread_id ORDER BY created_at DESC limit 1) WHERE id = NEW.thread_id;

      -- increment metadata.threads' post_count
      UPDATE threads SET post_count = post_count + 1 WHERE id = NEW.thread_id;
    RETURN NEW;
  END;
$$;


--
-- Name: update_thread(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_thread() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- update metadta.board' post_count
    IF OLD.post_count < NEW.post_count THEN
      UPDATE boards SET post_count = post_count + 1 WHERE id = OLD.board_id;
    ELSE
      UPDATE boards SET post_count = post_count - 1 WHERE id = OLD.board_id;
    END IF;

    -- update metadata.boards' last post information
    UPDATE metadata.boards
    SET last_post_username = username,
        last_post_created_at = created_at,
        last_thread_id = thread_id,
        last_thread_title = title,
        last_post_position = position
    FROM (
      SELECT pLast.username as username,
             pLast.created_at as created_at,
             t.id as thread_id,
             pFirst.title as title,
             pLast.position as position
      FROM (
        SELECT id
        FROM threads
        WHERE board_id = OLD.board_id
        ORDER BY updated_at DESC LIMIT 1
      ) t LEFT JOIN LATERAL (
        SELECT p.content ->> 'title' as title
        FROM posts p
        WHERE p.thread_id = t.id
        ORDER BY p.created_at LIMIT 1
      ) pFirst ON true LEFT JOIN LATERAL (
        SELECT u.username, p.position, p.created_at
        FROM posts p LEFT JOIN users u ON u.id = p.user_id
        WHERE p.thread_id = t.id
        ORDER BY p.created_at DESC LIMIT 1
      ) pLast ON true
    ) AS subquery
    WHERE board_id = OLD.board_id;

    RETURN NEW;
  END;
$$;


--
-- Name: update_unique_authed_user_score_on_ad(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_unique_authed_user_score_on_ad() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- increment total_unique_authed_users_impressions
    UPDATE ads.analytics SET total_unique_authed_users_impressions = total_unique_authed_users_impressions + 1 WHERE ad_id = NEW.ad_id;

    RETURN NEW;
  END;
$$;


--
-- Name: update_unique_authed_user_score_on_factoid(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_unique_authed_user_score_on_factoid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- increment total_unique_authed_users_impressions
    UPDATE factoids.analytics SET total_unique_authed_users_impressions = total_unique_authed_users_impressions + 1 WHERE round = NEW.round;

    RETURN NEW;
  END;
$$;


--
-- Name: update_unique_ip_score_on_ad(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_unique_ip_score_on_ad() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- increment total_unique_ip_impressions
    UPDATE ads.analytics SET total_unique_ip_impressions = total_unique_ip_impressions + 1 WHERE ad_id = NEW.ad_id;

    RETURN NEW;
  END;
$$;


--
-- Name: update_unique_ip_score_on_factoids(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION update_unique_ip_score_on_factoids() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    -- increment total_unique_ip_impressions
    UPDATE factoids.analytics SET total_unique_ip_impressions = total_unique_ip_impressions + 1 WHERE round = NEW.round;

    RETURN NEW;
  END;
$$;

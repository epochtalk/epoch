--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: administration; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA administration;


--
-- Name: ads; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ads;


--
-- Name: factoids; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA factoids;


--
-- Name: mentions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA mentions;


--
-- Name: metadata; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA metadata;


--
-- Name: mod; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA mod;


--
-- Name: users; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA users;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: moderation_action_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE moderation_action_type AS ENUM (
    'adminBoards.updateCategories',
    'adminModerators.add',
    'adminModerators.remove',
    'adminReports.createMessageReportNote',
    'adminReports.updateMessageReportNote',
    'adminReports.createPostReportNote',
    'adminReports.updatePostReportNote',
    'adminReports.createUserReportNote',
    'adminReports.updateUserReportNote',
    'adminReports.updateMessageReport',
    'adminReports.updatePostReport',
    'adminReports.updateUserReport',
    'adminRoles.add',
    'adminRoles.remove',
    'adminRoles.update',
    'adminRoles.reprioritize',
    'adminSettings.update',
    'adminSettings.addToBlacklist',
    'adminSettings.updateBlacklist',
    'adminSettings.deleteFromBlacklist',
    'adminSettings.setTheme',
    'adminSettings.resetTheme',
    'adminUsers.update',
    'adminUsers.addRoles',
    'adminUsers.removeRoles',
    'userNotes.create',
    'userNotes.update',
    'userNotes.delete',
    'bans.ban',
    'bans.unban',
    'bans.banFromBoards',
    'bans.unbanFromBoards',
    'bans.addAddresses',
    'bans.editAddress',
    'bans.deleteAddress',
    'boards.create',
    'boards.update',
    'boards.delete',
    'threads.title',
    'threads.sticky',
    'threads.createPoll',
    'threads.lock',
    'threads.move',
    'threads.lockPoll',
    'threads.purge',
    'threads.editPoll',
    'posts.update',
    'posts.undelete',
    'posts.delete',
    'posts.purge',
    'users.update',
    'users.delete',
    'users.reactivate',
    'users.deactivate',
    'conversations.delete',
    'messages.delete',
    'reports.createMessageReportNote',
    'reports.updateMessageReportNote',
    'reports.createPostReportNote',
    'reports.updatePostReportNote',
    'reports.createUserReportNote',
    'reports.updateUserReportNote',
    'reports.updateMessageReport',
    'reports.updatePostReport',
    'reports.updateUserReport'
);


--
-- Name: polls_display_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE polls_display_enum AS ENUM (
    'always',
    'voted',
    'expired'
);


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


SET search_path = administration, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: reports_messages; Type: TABLE; Schema: administration; Owner: -
--

CREATE TABLE reports_messages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    status_id integer NOT NULL,
    reporter_user_id uuid,
    reporter_reason text DEFAULT ''::text NOT NULL,
    reviewer_user_id uuid,
    offender_message_id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reports_messages_notes; Type: TABLE; Schema: administration; Owner: -
--

CREATE TABLE reports_messages_notes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    report_id uuid NOT NULL,
    user_id uuid,
    note text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reports_posts; Type: TABLE; Schema: administration; Owner: -
--

CREATE TABLE reports_posts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    status_id integer NOT NULL,
    reporter_user_id uuid,
    reporter_reason text DEFAULT ''::text NOT NULL,
    reviewer_user_id uuid,
    offender_post_id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reports_posts_notes; Type: TABLE; Schema: administration; Owner: -
--

CREATE TABLE reports_posts_notes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    report_id uuid,
    user_id uuid,
    note text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reports_statuses; Type: TABLE; Schema: administration; Owner: -
--

CREATE TABLE reports_statuses (
    id integer NOT NULL,
    priority integer NOT NULL,
    status character varying(255) DEFAULT ''::character varying NOT NULL
);


--
-- Name: reports_statuses_id_seq; Type: SEQUENCE; Schema: administration; Owner: -
--

CREATE SEQUENCE reports_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: administration; Owner: -
--

ALTER SEQUENCE reports_statuses_id_seq OWNED BY reports_statuses.id;


--
-- Name: reports_users; Type: TABLE; Schema: administration; Owner: -
--

CREATE TABLE reports_users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    status_id integer NOT NULL,
    reporter_user_id uuid,
    reporter_reason text DEFAULT ''::text NOT NULL,
    reviewer_user_id uuid,
    offender_user_id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reports_users_notes; Type: TABLE; Schema: administration; Owner: -
--

CREATE TABLE reports_users_notes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    report_id uuid,
    user_id uuid,
    note text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


SET search_path = ads, pg_catalog;

--
-- Name: analytics; Type: TABLE; Schema: ads; Owner: -
--

CREATE TABLE analytics (
    ad_id uuid NOT NULL,
    total_impressions integer DEFAULT 0 NOT NULL,
    total_authed_impressions integer DEFAULT 0 NOT NULL,
    total_unique_ip_impressions integer DEFAULT 0 NOT NULL,
    total_unique_authed_users_impressions integer DEFAULT 0 NOT NULL
);


--
-- Name: authed_users; Type: TABLE; Schema: ads; Owner: -
--

CREATE TABLE authed_users (
    ad_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: rounds; Type: TABLE; Schema: ads; Owner: -
--

CREATE TABLE rounds (
    round integer NOT NULL,
    current boolean DEFAULT false,
    start_time timestamp without time zone,
    end_time timestamp without time zone
);


--
-- Name: rounds_round_seq; Type: SEQUENCE; Schema: ads; Owner: -
--

CREATE SEQUENCE rounds_round_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rounds_round_seq; Type: SEQUENCE OWNED BY; Schema: ads; Owner: -
--

ALTER SEQUENCE rounds_round_seq OWNED BY rounds.round;


--
-- Name: unique_ip; Type: TABLE; Schema: ads; Owner: -
--

CREATE TABLE unique_ip (
    ad_id uuid NOT NULL,
    unique_ip character varying(255) NOT NULL
);


SET search_path = factoids, pg_catalog;

--
-- Name: analytics; Type: TABLE; Schema: factoids; Owner: -
--

CREATE TABLE analytics (
    round integer NOT NULL,
    total_impressions integer DEFAULT 0 NOT NULL,
    total_authed_impressions integer DEFAULT 0 NOT NULL,
    total_unique_ip_impressions integer DEFAULT 0 NOT NULL,
    total_unique_authed_users_impressions integer DEFAULT 0 NOT NULL
);


--
-- Name: authed_users; Type: TABLE; Schema: factoids; Owner: -
--

CREATE TABLE authed_users (
    round integer NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: unique_ip; Type: TABLE; Schema: factoids; Owner: -
--

CREATE TABLE unique_ip (
    round integer NOT NULL,
    unique_ip character varying(255) NOT NULL
);


SET search_path = mentions, pg_catalog;

--
-- Name: ignored; Type: TABLE; Schema: mentions; Owner: -
--

CREATE TABLE ignored (
    user_id uuid NOT NULL,
    ignored_user_id uuid NOT NULL
);


--
-- Name: mentions; Type: TABLE; Schema: mentions; Owner: -
--

CREATE TABLE mentions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    thread_id uuid NOT NULL,
    post_id uuid NOT NULL,
    mentioner_id uuid NOT NULL,
    mentionee_id uuid NOT NULL,
    created_at timestamp without time zone
);


SET search_path = metadata, pg_catalog;

--
-- Name: boards; Type: TABLE; Schema: metadata; Owner: -
--

CREATE TABLE boards (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    board_id uuid,
    post_count integer,
    thread_count integer,
    total_post integer,
    total_thread_count integer,
    last_post_username character varying(255),
    last_post_created_at timestamp without time zone,
    last_thread_id uuid,
    last_thread_title character varying(255),
    last_post_position integer
);


--
-- Name: threads; Type: TABLE; Schema: metadata; Owner: -
--

CREATE TABLE threads (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    thread_id uuid,
    views integer DEFAULT 0
);


SET search_path = mod, pg_catalog;

--
-- Name: notes; Type: TABLE; Schema: mod; Owner: -
--

CREATE TABLE notes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    moderator_id uuid,
    subject character varying(255),
    body text DEFAULT ''::text,
    created_at timestamp without time zone,
    imported_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: reports; Type: TABLE; Schema: mod; Owner: -
--

CREATE TABLE reports (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    thread_id uuid,
    post_id uuid,
    reason_subject character varying(255),
    reason_body text DEFAULT ''::text,
    created_at timestamp without time zone,
    imported_at timestamp without time zone,
    updated_at timestamp without time zone
);


SET search_path = public, pg_catalog;

--
-- Name: ads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ads (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    round integer NOT NULL,
    html text NOT NULL,
    css text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: auto_moderation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE auto_moderation (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(1000),
    message character varying(1000),
    conditions jsonb NOT NULL,
    actions jsonb NOT NULL,
    options jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: backoff; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE backoff (
    ip character varying(40),
    route character varying(255),
    method character varying(15),
    created_at timestamp without time zone
);


--
-- Name: banned_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE banned_addresses (
    hostname character varying(255),
    ip1 integer,
    ip2 integer,
    ip3 integer,
    ip4 integer,
    weight numeric NOT NULL,
    decay boolean NOT NULL,
    created_at timestamp without time zone,
    imported_at timestamp without time zone,
    updates timestamp without time zone[] DEFAULT ARRAY[]::timestamp without time zone[],
    CONSTRAINT banned_addresses_hostname_or_ip_contraint CHECK ((((ip1 IS NOT NULL) AND (ip2 IS NOT NULL) AND (ip3 IS NOT NULL) AND (ip4 IS NOT NULL) AND (hostname IS NULL)) OR ((hostname IS NOT NULL) AND (ip1 IS NULL) AND (ip2 IS NULL) AND (ip3 IS NULL) AND (ip4 IS NULL))))
);


--
-- Name: blacklist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE blacklist (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    ip_data character varying(100) NOT NULL,
    note character varying(255)
);


--
-- Name: board_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE board_mapping (
    board_id uuid NOT NULL,
    parent_id uuid NOT NULL,
    category_id uuid,
    view_order integer NOT NULL
);


--
-- Name: board_moderators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE board_moderators (
    user_id uuid,
    board_id uuid
);


--
-- Name: boards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE boards (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255) DEFAULT ''::character varying,
    description text DEFAULT ''::text,
    post_count integer DEFAULT 0,
    thread_count integer DEFAULT 0,
    viewable_by integer,
    postable_by integer,
    created_at timestamp without time zone,
    imported_at timestamp without time zone,
    updated_at timestamp without time zone,
    meta jsonb
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255),
    view_order integer,
    viewable_by integer,
    postable_by integer,
    created_at timestamp without time zone,
    imported_at timestamp without time zone,
    updated_at timestamp without time zone,
    meta jsonb
);


--
-- Name: configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE configurations (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255),
    config jsonb
);


--
-- Name: factoids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE factoids (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    text text NOT NULL,
    enabled boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: image_expirations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE image_expirations (
    expiration timestamp without time zone,
    image_url character varying(2000) NOT NULL
);


--
-- Name: images_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE images_posts (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    post_id uuid,
    image_url character varying(255) NOT NULL
);


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invitations (
    email citext NOT NULL,
    hash character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT invitations_email_check CHECK ((length((email)::text) <= 255))
);


--
-- Name: moderation_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE moderation_log (
    mod_username character varying(40) NOT NULL,
    mod_id uuid,
    mod_ip character varying(255),
    action_api_url character varying(2000) NOT NULL,
    action_api_method character varying(25) NOT NULL,
    action_obj jsonb NOT NULL,
    action_taken_at timestamp without time zone NOT NULL,
    action_type moderation_action_type NOT NULL,
    action_display_text text NOT NULL,
    action_display_url character varying(255)
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    sender_id uuid NOT NULL,
    receiver_id uuid NOT NULL,
    data jsonb,
    created_at timestamp without time zone,
    viewed boolean DEFAULT false,
    type character varying(255)
);


--
-- Name: poll_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE poll_answers (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    poll_id uuid NOT NULL,
    answer text NOT NULL
);


--
-- Name: poll_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE poll_responses (
    answer_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: polls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE polls (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    thread_id uuid NOT NULL,
    question text NOT NULL,
    locked boolean DEFAULT false,
    max_answers integer DEFAULT 1 NOT NULL,
    expiration timestamp without time zone,
    change_vote boolean DEFAULT false NOT NULL,
    display_mode polls_display_enum DEFAULT 'always'::polls_display_enum NOT NULL
);


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE posts (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    thread_id uuid,
    user_id uuid,
    content jsonb,
    deleted boolean,
    locked boolean,
    "position" integer,
    tsv tsvector,
    created_at timestamp without time zone,
    imported_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: private_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE private_conversations (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: private_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE private_messages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    conversation_id uuid NOT NULL,
    sender_id uuid,
    receiver_id uuid,
    copied_ids uuid[],
    body text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone,
    viewed boolean DEFAULT false
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    permissions jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    lookup character varying(255) NOT NULL,
    priority integer NOT NULL,
    highlight_color character varying(255)
);


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles_users (
    role_id uuid,
    user_id uuid
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: threads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE threads (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    board_id uuid,
    locked boolean,
    sticky boolean,
    moderated boolean,
    post_count integer DEFAULT 0,
    created_at timestamp without time zone,
    imported_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: trust; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE trust (
    user_id uuid,
    user_id_trusted uuid,
    type smallint
);


--
-- Name: trust_boards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE trust_boards (
    board_id uuid
);


--
-- Name: trust_feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE trust_feedback (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id uuid,
    reporter_id uuid,
    risked_btc double precision,
    scammer boolean,
    reference text,
    comments text,
    created_at timestamp without time zone
);


--
-- Name: trust_max_depth; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE trust_max_depth (
    user_id uuid NOT NULL,
    max_depth smallint DEFAULT 2 NOT NULL
);


--
-- Name: user_activity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_activity (
    user_id uuid,
    current_period_start timestamp without time zone,
    current_period_offset timestamp without time zone,
    remaining_period_activity integer DEFAULT 14 NOT NULL,
    total_activity integer DEFAULT 0 NOT NULL
);


--
-- Name: user_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_notes (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id uuid,
    author_id uuid,
    note text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    email citext NOT NULL,
    username citext NOT NULL,
    passhash character varying(255),
    confirmation_token character varying(255),
    reset_token character varying(255),
    reset_expiration timestamp without time zone,
    created_at timestamp without time zone,
    imported_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted boolean DEFAULT false,
    malicious_score integer
);


SET search_path = users, pg_catalog;

--
-- Name: bans; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE bans (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    expiration timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: board_bans; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE board_bans (
    user_id uuid NOT NULL,
    board_id uuid NOT NULL
);


--
-- Name: ignored; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE ignored (
    user_id uuid NOT NULL,
    ignored_user_id uuid NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: ips; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE ips (
    user_id uuid NOT NULL,
    user_ip character varying(255) NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: preferences; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE preferences (
    user_id uuid NOT NULL,
    posts_per_page integer DEFAULT 25,
    threads_per_page integer DEFAULT 25,
    collapsed_categories jsonb DEFAULT '{"cats": []}'::jsonb
);


--
-- Name: profiles; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE profiles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    avatar character varying(255) DEFAULT ''::character varying,
    "position" character varying(255),
    signature text,
    post_count integer DEFAULT 0,
    fields jsonb,
    raw_signature text,
    last_active timestamp without time zone
);


--
-- Name: thread_views; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE thread_views (
    user_id uuid,
    thread_id uuid,
    "time" timestamp without time zone
);


--
-- Name: watch_boards; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE watch_boards (
    user_id uuid,
    board_id uuid
);


--
-- Name: watch_threads; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE watch_threads (
    user_id uuid,
    thread_id uuid
);


SET search_path = administration, pg_catalog;

--
-- Name: reports_statuses id; Type: DEFAULT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_statuses ALTER COLUMN id SET DEFAULT nextval('reports_statuses_id_seq'::regclass);


SET search_path = ads, pg_catalog;

--
-- Name: rounds round; Type: DEFAULT; Schema: ads; Owner: -
--

ALTER TABLE ONLY rounds ALTER COLUMN round SET DEFAULT nextval('rounds_round_seq'::regclass);


SET search_path = administration, pg_catalog;

--
-- Name: reports_messages_notes reports_messages_notes_pkey; Type: CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages_notes
    ADD CONSTRAINT reports_messages_notes_pkey PRIMARY KEY (id);


--
-- Name: reports_messages reports_messages_pkey; Type: CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT reports_messages_pkey PRIMARY KEY (id);


--
-- Name: reports_posts_notes reports_posts_notes_pkey; Type: CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_posts_notes
    ADD CONSTRAINT reports_posts_notes_pkey PRIMARY KEY (id);


--
-- Name: reports_posts reports_posts_pkey; Type: CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_posts
    ADD CONSTRAINT reports_posts_pkey PRIMARY KEY (id);


--
-- Name: reports_statuses reports_statuses_pkey; Type: CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_statuses
    ADD CONSTRAINT reports_statuses_pkey PRIMARY KEY (id);


--
-- Name: reports_users_notes reports_users_notes_pkey; Type: CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users_notes
    ADD CONSTRAINT reports_users_notes_pkey PRIMARY KEY (id);


--
-- Name: reports_users reports_users_pkey; Type: CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users
    ADD CONSTRAINT reports_users_pkey PRIMARY KEY (id);


SET search_path = ads, pg_catalog;

--
-- Name: analytics analytics_pkey; Type: CONSTRAINT; Schema: ads; Owner: -
--

ALTER TABLE ONLY analytics
    ADD CONSTRAINT analytics_pkey PRIMARY KEY (ad_id);


--
-- Name: rounds rounds_pkey; Type: CONSTRAINT; Schema: ads; Owner: -
--

ALTER TABLE ONLY rounds
    ADD CONSTRAINT rounds_pkey PRIMARY KEY (round);


SET search_path = factoids, pg_catalog;

--
-- Name: analytics analytics_pkey; Type: CONSTRAINT; Schema: factoids; Owner: -
--

ALTER TABLE ONLY analytics
    ADD CONSTRAINT analytics_pkey PRIMARY KEY (round);


SET search_path = mentions, pg_catalog;

--
-- Name: mentions mentions_pkey; Type: CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);


SET search_path = metadata, pg_catalog;

--
-- Name: boards boards_pkey; Type: CONSTRAINT; Schema: metadata; Owner: -
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: threads threads_pkey; Type: CONSTRAINT; Schema: metadata; Owner: -
--

ALTER TABLE ONLY threads
    ADD CONSTRAINT threads_pkey PRIMARY KEY (id);


SET search_path = mod, pg_catalog;

--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: mod; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: mod; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


SET search_path = public, pg_catalog;

--
-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: auto_moderation auto_moderation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY auto_moderation
    ADD CONSTRAINT auto_moderation_pkey PRIMARY KEY (id);


--
-- Name: banned_addresses banned_addresses_unique_ip_contraint; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY banned_addresses
    ADD CONSTRAINT banned_addresses_unique_ip_contraint UNIQUE (ip1, ip2, ip3, ip4);


--
-- Name: blacklist blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY blacklist
    ADD CONSTRAINT blacklist_pkey PRIMARY KEY (id);


--
-- Name: boards boards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- Name: factoids factoids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY factoids
    ADD CONSTRAINT factoids_pkey PRIMARY KEY (id);


--
-- Name: images_posts images_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images_posts
    ADD CONSTRAINT images_posts_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: poll_answers poll_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_answers
    ADD CONSTRAINT poll_answers_pkey PRIMARY KEY (id);


--
-- Name: polls polls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polls
    ADD CONSTRAINT polls_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: private_conversations private_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY private_conversations
    ADD CONSTRAINT private_conversations_pkey PRIMARY KEY (id);


--
-- Name: private_messages private_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY private_messages
    ADD CONSTRAINT private_messages_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: threads threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY threads
    ADD CONSTRAINT threads_pkey PRIMARY KEY (id);


--
-- Name: trust_feedback trust_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_feedback
    ADD CONSTRAINT trust_feedback_pkey PRIMARY KEY (id);


--
-- Name: user_notes user_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notes
    ADD CONSTRAINT user_notes_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


SET search_path = users, pg_catalog;

--
-- Name: bans bans_pkey; Type: CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY bans
    ADD CONSTRAINT bans_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


SET search_path = administration, pg_catalog;

--
-- Name: reports_messages_created_at_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_messages_created_at_index ON reports_messages USING btree (created_at);


--
-- Name: reports_messages_notes_created_at_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_messages_notes_created_at_index ON reports_messages_notes USING btree (created_at);


--
-- Name: reports_messages_notes_report_id_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_messages_notes_report_id_index ON reports_messages_notes USING btree (report_id);


--
-- Name: reports_messages_offender_message_id_reporter_user_id_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE UNIQUE INDEX reports_messages_offender_message_id_reporter_user_id_index ON reports_messages USING btree (offender_message_id, reporter_user_id);


--
-- Name: reports_messages_status_id_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_messages_status_id_index ON reports_messages USING btree (status_id);


--
-- Name: reports_posts_created_at_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_posts_created_at_index ON reports_posts USING btree (created_at);


--
-- Name: reports_posts_notes_created_at_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_posts_notes_created_at_index ON reports_posts_notes USING btree (created_at);


--
-- Name: reports_posts_notes_report_id_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_posts_notes_report_id_index ON reports_posts_notes USING btree (report_id);


--
-- Name: reports_posts_offender_post_id_reporter_user_id_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE UNIQUE INDEX reports_posts_offender_post_id_reporter_user_id_index ON reports_posts USING btree (offender_post_id, reporter_user_id);


--
-- Name: reports_posts_status_id_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_posts_status_id_index ON reports_posts USING btree (status_id);


--
-- Name: reports_users_created_at_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_users_created_at_index ON reports_users USING btree (created_at);


--
-- Name: reports_users_notes_created_at_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_users_notes_created_at_index ON reports_users_notes USING btree (created_at);


--
-- Name: reports_users_notes_report_id_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_users_notes_report_id_index ON reports_users_notes USING btree (report_id);


--
-- Name: reports_users_offender_user_id_reporter_user_id_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE UNIQUE INDEX reports_users_offender_user_id_reporter_user_id_index ON reports_users USING btree (offender_user_id, reporter_user_id);


--
-- Name: reports_users_status_id_index; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX reports_users_status_id_index ON reports_users USING btree (status_id);


SET search_path = ads, pg_catalog;

--
-- Name: authed_users_ad_id_index; Type: INDEX; Schema: ads; Owner: -
--

CREATE INDEX authed_users_ad_id_index ON authed_users USING btree (ad_id);


--
-- Name: authed_users_ad_id_user_id_index; Type: INDEX; Schema: ads; Owner: -
--

CREATE UNIQUE INDEX authed_users_ad_id_user_id_index ON authed_users USING btree (ad_id, user_id);


--
-- Name: unique_ip_ad_id_index; Type: INDEX; Schema: ads; Owner: -
--

CREATE INDEX unique_ip_ad_id_index ON unique_ip USING btree (ad_id);


--
-- Name: unique_ip_ad_id_unique_ip_index; Type: INDEX; Schema: ads; Owner: -
--

CREATE UNIQUE INDEX unique_ip_ad_id_unique_ip_index ON unique_ip USING btree (ad_id, unique_ip);


SET search_path = factoids, pg_catalog;

--
-- Name: authed_users_round_index; Type: INDEX; Schema: factoids; Owner: -
--

CREATE INDEX authed_users_round_index ON authed_users USING btree (round);


--
-- Name: authed_users_round_user_id_index; Type: INDEX; Schema: factoids; Owner: -
--

CREATE UNIQUE INDEX authed_users_round_user_id_index ON authed_users USING btree (round, user_id);


--
-- Name: unique_ip_round_index; Type: INDEX; Schema: factoids; Owner: -
--

CREATE INDEX unique_ip_round_index ON unique_ip USING btree (round);


--
-- Name: unique_ip_round_unique_ip_index; Type: INDEX; Schema: factoids; Owner: -
--

CREATE UNIQUE INDEX unique_ip_round_unique_ip_index ON unique_ip USING btree (round, unique_ip);


SET search_path = mentions, pg_catalog;

--
-- Name: ignored_ignored_user_id_index; Type: INDEX; Schema: mentions; Owner: -
--

CREATE INDEX ignored_ignored_user_id_index ON ignored USING btree (ignored_user_id);


--
-- Name: ignored_user_id_ignored_user_id_index; Type: INDEX; Schema: mentions; Owner: -
--

CREATE UNIQUE INDEX ignored_user_id_ignored_user_id_index ON ignored USING btree (user_id, ignored_user_id);


--
-- Name: ignored_user_id_index; Type: INDEX; Schema: mentions; Owner: -
--

CREATE INDEX ignored_user_id_index ON ignored USING btree (user_id);


SET search_path = metadata, pg_catalog;

--
-- Name: boards_board_id_index; Type: INDEX; Schema: metadata; Owner: -
--

CREATE UNIQUE INDEX boards_board_id_index ON boards USING btree (board_id);


--
-- Name: threads_thread_id_index; Type: INDEX; Schema: metadata; Owner: -
--

CREATE UNIQUE INDEX threads_thread_id_index ON threads USING btree (thread_id);


SET search_path = public, pg_catalog;

--
-- Name: ads_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ads_created_at_index ON ads USING btree (created_at);


--
-- Name: ads_round_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ads_round_index ON ads USING btree (round);


--
-- Name: backoff_ip_route_method_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX backoff_ip_route_method_index ON backoff USING btree (ip, route, method);


--
-- Name: banned_addresses_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX banned_addresses_created_at_index ON banned_addresses USING btree (created_at);


--
-- Name: banned_addresses_decay_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX banned_addresses_decay_index ON banned_addresses USING btree (decay);


--
-- Name: banned_addresses_hostname_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX banned_addresses_hostname_index ON banned_addresses USING btree (hostname);


--
-- Name: banned_addresses_imported_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX banned_addresses_imported_at_index ON banned_addresses USING btree (imported_at);


--
-- Name: banned_addresses_weight_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX banned_addresses_weight_index ON banned_addresses USING btree (weight);


--
-- Name: board_mapping_board_id_category_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX board_mapping_board_id_category_id_index ON board_mapping USING btree (board_id, category_id);


--
-- Name: board_mapping_board_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX board_mapping_board_id_index ON board_mapping USING btree (board_id);


--
-- Name: board_mapping_board_id_parent_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX board_mapping_board_id_parent_id_index ON board_mapping USING btree (board_id, parent_id);


--
-- Name: board_moderators_board_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX board_moderators_board_id_index ON board_moderators USING btree (board_id);


--
-- Name: board_moderators_user_id_board_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX board_moderators_user_id_board_id_index ON board_moderators USING btree (user_id, board_id);


--
-- Name: board_moderators_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX board_moderators_user_id_index ON board_moderators USING btree (user_id);


--
-- Name: configurations_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX configurations_name_index ON configurations USING btree (name);


--
-- Name: factoids_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX factoids_created_at_index ON factoids USING btree (created_at);


--
-- Name: factoids_enabled_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX factoids_enabled_index ON factoids USING btree (enabled);


--
-- Name: image_expirations_expiration_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_expirations_expiration_index ON image_expirations USING btree (expiration);


--
-- Name: image_expirations_image_url_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_expirations_image_url_index ON image_expirations USING btree (image_url);


--
-- Name: images_posts_image_url_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX images_posts_image_url_index ON images_posts USING btree (image_url);


--
-- Name: images_posts_post_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX images_posts_post_id_index ON images_posts USING btree (post_id);


--
-- Name: invitations_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX invitations_created_at_index ON invitations USING btree (created_at);


--
-- Name: invitations_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX invitations_email_index ON invitations USING btree (email);


--
-- Name: invitations_hash_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX invitations_hash_index ON invitations USING btree (hash);


--
-- Name: moderation_log_action_api_method_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX moderation_log_action_api_method_index ON moderation_log USING btree (action_api_method);


--
-- Name: moderation_log_action_api_url_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX moderation_log_action_api_url_index ON moderation_log USING btree (action_api_url);


--
-- Name: moderation_log_action_taken_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX moderation_log_action_taken_at_index ON moderation_log USING btree (action_taken_at);


--
-- Name: moderation_log_action_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX moderation_log_action_type_index ON moderation_log USING btree (action_type);


--
-- Name: moderation_log_mod_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX moderation_log_mod_id_index ON moderation_log USING btree (mod_id);


--
-- Name: moderation_log_mod_ip_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX moderation_log_mod_ip_index ON moderation_log USING btree (mod_ip);


--
-- Name: moderation_log_mod_username_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX moderation_log_mod_username_index ON moderation_log USING btree (mod_username);


--
-- Name: notifications_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notifications_type_index ON notifications USING btree (type);


--
-- Name: polls_thread_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX polls_thread_id_index ON polls USING btree (thread_id);


--
-- Name: posts_thread_id_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX posts_thread_id_created_at_index ON posts USING btree (thread_id, created_at);


--
-- Name: posts_thread_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX posts_thread_id_index ON posts USING btree (thread_id);


--
-- Name: posts_thread_id_position_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX posts_thread_id_position_index ON posts USING btree (thread_id, "position");


--
-- Name: posts_thread_id_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX posts_thread_id_user_id_index ON posts USING btree (thread_id, user_id);


--
-- Name: posts_tsv_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX posts_tsv_index ON posts USING gin (tsv);


--
-- Name: posts_user_id_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX posts_user_id_created_at_index ON posts USING btree (user_id, created_at);


--
-- Name: posts_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX posts_user_id_index ON posts USING btree (user_id);


--
-- Name: private_messages_conversation_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX private_messages_conversation_id_index ON private_messages USING btree (conversation_id);


--
-- Name: private_messages_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX private_messages_created_at_index ON private_messages USING btree (created_at);


--
-- Name: private_messages_receiver_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX private_messages_receiver_id_index ON private_messages USING btree (receiver_id);


--
-- Name: private_messages_sender_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX private_messages_sender_id_index ON private_messages USING btree (sender_id);


--
-- Name: roles_lookup_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX roles_lookup_index ON roles USING btree (lookup);


--
-- Name: threads_board_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX threads_board_id_index ON threads USING btree (board_id) WHERE (sticky = true);


--
-- Name: threads_board_id_updated_at_DESC_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "threads_board_id_updated_at_DESC_index" ON threads USING btree (board_id, updated_at DESC);


--
-- Name: threads_updated_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX threads_updated_at_index ON threads USING btree (updated_at);


--
-- Name: trust_boards_board_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX trust_boards_board_id_index ON trust_boards USING btree (board_id);


--
-- Name: trust_feedback_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trust_feedback_created_at_index ON trust_feedback USING btree (created_at);


--
-- Name: trust_feedback_reporter_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trust_feedback_reporter_id_index ON trust_feedback USING btree (reporter_id);


--
-- Name: trust_feedback_scammer_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trust_feedback_scammer_index ON trust_feedback USING btree (scammer);


--
-- Name: trust_feedback_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trust_feedback_user_id_index ON trust_feedback USING btree (user_id);


--
-- Name: trust_max_depth_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX trust_max_depth_user_id_index ON trust_max_depth USING btree (user_id);


--
-- Name: trust_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trust_type_index ON trust USING btree (type);


--
-- Name: trust_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trust_user_id_index ON trust USING btree (user_id);


--
-- Name: trust_user_id_trusted_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX trust_user_id_trusted_index ON trust USING btree (user_id_trusted);


--
-- Name: user_activity_total_activity_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_activity_total_activity_index ON user_activity USING btree (total_activity);


--
-- Name: user_activity_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_activity_user_id_index ON user_activity USING btree (user_id);


--
-- Name: user_notes_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_notes_created_at_index ON user_notes USING btree (created_at);


--
-- Name: user_notes_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_notes_user_id_index ON user_notes USING btree (user_id);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_index ON users USING btree (email);


--
-- Name: users_username_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_username_index ON users USING btree (username);


SET search_path = users, pg_catalog;

--
-- Name: bans_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX bans_user_id_index ON bans USING btree (user_id);


--
-- Name: board_bans_board_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX board_bans_board_id_index ON board_bans USING btree (board_id);


--
-- Name: board_bans_board_id_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX board_bans_board_id_user_id_index ON board_bans USING btree (board_id, user_id);


--
-- Name: board_bans_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX board_bans_user_id_index ON board_bans USING btree (user_id);


--
-- Name: ignored_ignored_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX ignored_ignored_user_id_index ON ignored USING btree (ignored_user_id);


--
-- Name: ignored_user_id_ignored_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX ignored_user_id_ignored_user_id_index ON ignored USING btree (user_id, ignored_user_id);


--
-- Name: ignored_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX ignored_user_id_index ON ignored USING btree (user_id);


--
-- Name: ips_created_at_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX ips_created_at_index ON ips USING btree (created_at);


--
-- Name: ips_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX ips_user_id_index ON ips USING btree (user_id);


--
-- Name: ips_user_id_user_ip_index; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX ips_user_id_user_ip_index ON ips USING btree (user_id, user_ip);


--
-- Name: ips_user_ip_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX ips_user_ip_index ON ips USING btree (user_ip);


--
-- Name: preferences_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX preferences_user_id_index ON preferences USING btree (user_id);


--
-- Name: profiles_last_active_DESC_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX "profiles_last_active_DESC_index" ON profiles USING btree (last_active DESC);


--
-- Name: profiles_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX profiles_user_id_index ON profiles USING btree (user_id);


--
-- Name: thread_views_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX thread_views_user_id_index ON thread_views USING btree (user_id);


--
-- Name: thread_views_user_id_thread_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX thread_views_user_id_thread_id_index ON thread_views USING btree (user_id, thread_id);


--
-- Name: watch_boards_board_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX watch_boards_board_id_index ON watch_boards USING btree (board_id);


--
-- Name: watch_boards_user_id_board_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX watch_boards_user_id_board_id_index ON watch_boards USING btree (user_id, board_id);


--
-- Name: watch_boards_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX watch_boards_user_id_index ON watch_boards USING btree (user_id);


--
-- Name: watch_threads_thread_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX watch_threads_thread_id_index ON watch_threads USING btree (thread_id);


--
-- Name: watch_threads_user_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX watch_threads_user_id_index ON watch_threads USING btree (user_id);


--
-- Name: watch_threads_user_id_thread_id_index; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX watch_threads_user_id_thread_id_index ON watch_threads USING btree (user_id, thread_id);


SET search_path = ads, pg_catalog;

--
-- Name: authed_users update_unique_authed_user_score_on_ad_trigger; Type: TRIGGER; Schema: ads; Owner: -
--

CREATE TRIGGER update_unique_authed_user_score_on_ad_trigger AFTER INSERT ON authed_users FOR EACH ROW EXECUTE PROCEDURE public.update_unique_authed_user_score_on_ad();


--
-- Name: unique_ip update_unique_ip_score_on_ad_trigger; Type: TRIGGER; Schema: ads; Owner: -
--

CREATE TRIGGER update_unique_ip_score_on_ad_trigger AFTER INSERT ON unique_ip FOR EACH ROW EXECUTE PROCEDURE public.update_unique_ip_score_on_ad();


SET search_path = factoids, pg_catalog;

--
-- Name: authed_users update_unique_authed_user_score_on_factoid_trigger; Type: TRIGGER; Schema: factoids; Owner: -
--

CREATE TRIGGER update_unique_authed_user_score_on_factoid_trigger AFTER INSERT ON authed_users FOR EACH ROW EXECUTE PROCEDURE public.update_unique_authed_user_score_on_factoid();


--
-- Name: unique_ip update_unique_ip_score_on_factoid_trigger; Type: TRIGGER; Schema: factoids; Owner: -
--

CREATE TRIGGER update_unique_ip_score_on_factoid_trigger AFTER INSERT ON unique_ip FOR EACH ROW EXECUTE PROCEDURE public.update_unique_ip_score_on_factoids();


SET search_path = public, pg_catalog;

--
-- Name: posts create_post_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER create_post_trigger AFTER INSERT ON posts FOR EACH ROW EXECUTE PROCEDURE create_post();


--
-- Name: threads create_thread_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER create_thread_trigger AFTER INSERT ON threads FOR EACH ROW EXECUTE PROCEDURE create_thread();


--
-- Name: posts delete_post_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER delete_post_trigger AFTER DELETE ON posts FOR EACH ROW EXECUTE PROCEDURE delete_post();


--
-- Name: threads delete_thread_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER delete_thread_trigger AFTER DELETE ON threads FOR EACH ROW EXECUTE PROCEDURE delete_thread();


--
-- Name: posts hide_post_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER hide_post_trigger AFTER UPDATE ON posts FOR EACH ROW WHEN (((old.deleted = false) AND (new.deleted = true))) EXECUTE PROCEDURE hide_post();


--
-- Name: posts search_index_post; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER search_index_post AFTER INSERT ON posts FOR EACH ROW EXECUTE PROCEDURE search_index_post();


--
-- Name: posts unhide_post_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER unhide_post_trigger AFTER UPDATE ON posts FOR EACH ROW WHEN (((old.deleted = true) AND (new.deleted = false))) EXECUTE PROCEDURE unhide_post();


--
-- Name: threads update_thread_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_thread_trigger AFTER UPDATE OF post_count ON threads FOR EACH ROW EXECUTE PROCEDURE update_thread();


SET search_path = administration, pg_catalog;

--
-- Name: reports_messages offender_message_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT offender_message_id_fkey FOREIGN KEY (offender_message_id) REFERENCES public.private_messages(id) ON DELETE CASCADE;


--
-- Name: reports_posts offender_post_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_posts
    ADD CONSTRAINT offender_post_id_fkey FOREIGN KEY (offender_post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: reports_users offender_user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users
    ADD CONSTRAINT offender_user_id_fkey FOREIGN KEY (offender_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reports_messages_notes report_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages_notes
    ADD CONSTRAINT report_id_fkey FOREIGN KEY (report_id) REFERENCES reports_messages(id) ON DELETE CASCADE;


--
-- Name: reports_posts reporter_user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_posts
    ADD CONSTRAINT reporter_user_id_fkey FOREIGN KEY (reporter_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_users reporter_user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users
    ADD CONSTRAINT reporter_user_id_fkey FOREIGN KEY (reporter_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_messages reporter_user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT reporter_user_id_fkey FOREIGN KEY (reporter_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_posts_notes reports_posts_notes_report_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_posts_notes
    ADD CONSTRAINT reports_posts_notes_report_id_fkey FOREIGN KEY (report_id) REFERENCES reports_posts(id) ON DELETE CASCADE;


--
-- Name: reports_users_notes reports_users_notes_report_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users_notes
    ADD CONSTRAINT reports_users_notes_report_id_fkey FOREIGN KEY (report_id) REFERENCES reports_users(id) ON DELETE CASCADE;


--
-- Name: reports_posts reviewer_user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_posts
    ADD CONSTRAINT reviewer_user_id_fkey FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_users reviewer_user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users
    ADD CONSTRAINT reviewer_user_id_fkey FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_messages reviewer_user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT reviewer_user_id_fkey FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_posts status_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_posts
    ADD CONSTRAINT status_id_fkey FOREIGN KEY (status_id) REFERENCES reports_statuses(id);


--
-- Name: reports_users status_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users
    ADD CONSTRAINT status_id_fkey FOREIGN KEY (status_id) REFERENCES reports_statuses(id);


--
-- Name: reports_messages status_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT status_id_fkey FOREIGN KEY (status_id) REFERENCES reports_statuses(id);


--
-- Name: reports_posts_notes user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_posts_notes
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_users_notes user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users_notes
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_messages_notes user_id_fkey; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages_notes
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


SET search_path = ads, pg_catalog;

--
-- Name: analytics analytics_ad_id_fkey; Type: FK CONSTRAINT; Schema: ads; Owner: -
--

ALTER TABLE ONLY analytics
    ADD CONSTRAINT analytics_ad_id_fkey FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: authed_users authed_users_ad_id_fkey; Type: FK CONSTRAINT; Schema: ads; Owner: -
--

ALTER TABLE ONLY authed_users
    ADD CONSTRAINT authed_users_ad_id_fkey FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


--
-- Name: authed_users authed_users_user_id_fkey; Type: FK CONSTRAINT; Schema: ads; Owner: -
--

ALTER TABLE ONLY authed_users
    ADD CONSTRAINT authed_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: unique_ip unique_ip_ad_id_fkey; Type: FK CONSTRAINT; Schema: ads; Owner: -
--

ALTER TABLE ONLY unique_ip
    ADD CONSTRAINT unique_ip_ad_id_fkey FOREIGN KEY (ad_id) REFERENCES public.ads(id) ON DELETE CASCADE;


SET search_path = factoids, pg_catalog;

--
-- Name: authed_users authed_users_user_id_fkey; Type: FK CONSTRAINT; Schema: factoids; Owner: -
--

ALTER TABLE ONLY authed_users
    ADD CONSTRAINT authed_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


SET search_path = mentions, pg_catalog;

--
-- Name: ignored ignored_user_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY ignored
    ADD CONSTRAINT ignored_user_id_fkey FOREIGN KEY (ignored_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentions mentions_mentionee_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_mentionee_id_fkey FOREIGN KEY (mentionee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentions mentions_mentioner_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_mentioner_id_fkey FOREIGN KEY (mentioner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentions mentions_post_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: mentions mentions_thread_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.threads(id) ON DELETE CASCADE;


--
-- Name: ignored user_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY ignored
    ADD CONSTRAINT user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


SET search_path = metadata, pg_catalog;

--
-- Name: boards boards_board_id_fkey; Type: FK CONSTRAINT; Schema: metadata; Owner: -
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: boards boards_last_thread_id_fkey; Type: FK CONSTRAINT; Schema: metadata; Owner: -
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_last_thread_id_fkey FOREIGN KEY (last_thread_id) REFERENCES public.threads(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: threads threads_thread_id_fkey; Type: FK CONSTRAINT; Schema: metadata; Owner: -
--

ALTER TABLE ONLY threads
    ADD CONSTRAINT threads_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.threads(id) ON UPDATE CASCADE ON DELETE CASCADE;


SET search_path = mod, pg_catalog;

--
-- Name: notes notes_moderator_id_fkey; Type: FK CONSTRAINT; Schema: mod; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_moderator_id_fkey FOREIGN KEY (moderator_id) REFERENCES public.users(id);


--
-- Name: reports reports_post_id_fkey; Type: FK CONSTRAINT; Schema: mod; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: reports reports_thread_id_fkey; Type: FK CONSTRAINT; Schema: mod; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.threads(id);


--
-- Name: reports reports_user_id_fkey; Type: FK CONSTRAINT; Schema: mod; Owner: -
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


SET search_path = public, pg_catalog;

--
-- Name: board_mapping board_mapping_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY board_mapping
    ADD CONSTRAINT board_mapping_board_id_fkey FOREIGN KEY (board_id) REFERENCES boards(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: board_mapping board_mapping_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY board_mapping
    ADD CONSTRAINT board_mapping_category_id_fkey FOREIGN KEY (category_id) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: board_mapping board_mapping_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY board_mapping
    ADD CONSTRAINT board_mapping_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES boards(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: board_moderators board_moderators_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY board_moderators
    ADD CONSTRAINT board_moderators_board_id_fkey FOREIGN KEY (board_id) REFERENCES boards(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: board_moderators board_moderators_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY board_moderators
    ADD CONSTRAINT board_moderators_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: images_posts images_posts_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images_posts
    ADD CONSTRAINT images_posts_post_id_fkey FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE SET NULL;


--
-- Name: notifications notifications_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES users(id);


--
-- Name: notifications notifications_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES users(id);


--
-- Name: poll_answers poll_answers_poll_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_answers
    ADD CONSTRAINT poll_answers_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES polls(id) ON DELETE CASCADE;


--
-- Name: poll_responses poll_responses_answer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_responses
    ADD CONSTRAINT poll_responses_answer_id_fkey FOREIGN KEY (answer_id) REFERENCES poll_answers(id) ON DELETE CASCADE;


--
-- Name: poll_responses poll_responses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_responses
    ADD CONSTRAINT poll_responses_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: polls polls_thread_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polls
    ADD CONSTRAINT polls_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES threads(id);


--
-- Name: posts posts_thread_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES threads(id);


--
-- Name: posts posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: private_messages private_messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY private_messages
    ADD CONSTRAINT private_messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES private_conversations(id) ON DELETE CASCADE;


--
-- Name: private_messages private_messages_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY private_messages
    ADD CONSTRAINT private_messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: private_messages private_messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY private_messages
    ADD CONSTRAINT private_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: roles_users roles_users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT roles_users_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE;


--
-- Name: roles_users roles_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT roles_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: threads threads_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY threads
    ADD CONSTRAINT threads_board_id_fkey FOREIGN KEY (board_id) REFERENCES boards(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: trust_boards trust_boards_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_boards
    ADD CONSTRAINT trust_boards_board_id_fkey FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE;


--
-- Name: trust_feedback trust_feedback_reporter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_feedback
    ADD CONSTRAINT trust_feedback_reporter_id_fkey FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: trust_feedback trust_feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_feedback
    ADD CONSTRAINT trust_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: trust_max_depth trust_max_depth_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_max_depth
    ADD CONSTRAINT trust_max_depth_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: trust trust_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust
    ADD CONSTRAINT trust_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: trust trust_user_id_trusted_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust
    ADD CONSTRAINT trust_user_id_trusted_fkey FOREIGN KEY (user_id_trusted) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: user_activity user_activity_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_activity
    ADD CONSTRAINT user_activity_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: user_notes user_notes_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notes
    ADD CONSTRAINT user_notes_author_id_fkey FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: user_notes user_notes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notes
    ADD CONSTRAINT user_notes_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


SET search_path = users, pg_catalog;

--
-- Name: bans bans_user_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY bans
    ADD CONSTRAINT bans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: board_bans board_bans_board_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY board_bans
    ADD CONSTRAINT board_bans_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: board_bans board_bans_user_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY board_bans
    ADD CONSTRAINT board_bans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: preferences preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY preferences
    ADD CONSTRAINT preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: thread_views thread_views_thread_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY thread_views
    ADD CONSTRAINT thread_views_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.threads(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: thread_views thread_views_user_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY thread_views
    ADD CONSTRAINT thread_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: watch_boards watch_boards_board_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY watch_boards
    ADD CONSTRAINT watch_boards_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: watch_boards watch_boards_user_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY watch_boards
    ADD CONSTRAINT watch_boards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: watch_threads watch_threads_thread_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY watch_threads
    ADD CONSTRAINT watch_threads_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES public.threads(id) ON DELETE CASCADE;


--
-- Name: watch_threads watch_threads_user_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY watch_threads
    ADD CONSTRAINT watch_threads_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO "schema_migrations" (version) VALUES (20161128043108), (20161128043113), (20161128110411), (20161128110632), (20161128110635), (20161128110637), (20170422030247), (20170624020344), (20170624020353), (20170624020359), (20170624020413), (20170624032125), (20170624032132), (20170624032151), (20170624032211), (20170626040044), (20170626044122), (20170626045438), (20170626052435), (20170626053401), (20170626060658), (20170626060977), (20170626063026), (20170626063032), (20170626091633), (20170626091646), (20170626091654), (20170626095320), (20170626100933), (20170626102518), (20170626112240), (20170705202124), (20170705204430), (20170705205615), (20170705210807), (20170705231842), (20170705234016), (20170706013608), (20170706014848), (20170706023451), (20170707012515);


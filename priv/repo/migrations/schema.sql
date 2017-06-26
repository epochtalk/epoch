--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;
SET search_path = public, pg_catalog;

SET search_path = administration, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

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
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: reports_users_notes; Type: TABLE; Schema: administration; Owner: -
--

CREATE TABLE reports_users_notes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    report_id uuid NOT NULL,
    user_id uuid,
    note text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
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
    start_time timestamp with time zone,
    end_time timestamp with time zone
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
    created_at timestamp with time zone
);


SET search_path = metadata, pg_catalog;

SET search_path = mod, pg_catalog;

--
-- Name: notes; Type: TABLE; Schema: mod; Owner: -
--

CREATE TABLE notes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    moderator_id uuid,
    subject character varying(255),
    body text DEFAULT ''::text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    imported_at timestamp with time zone
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
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    imported_at timestamp with time zone
);


SET search_path = public, pg_catalog;

--
-- Name: images_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE images_posts (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    post_id uuid,
    image_url text NOT NULL
);


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invitations (
    email citext NOT NULL,
    hash character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    CONSTRAINT invitations_email_check CHECK ((length((email)::text) <= 255))
);


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    run_on timestamp without time zone NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE migrations_id_seq OWNED BY migrations.id;


--
-- Name: moderation_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE moderation_log (
    mod_username character varying(50) NOT NULL,
    mod_id uuid,
    mod_ip character varying(255),
    action_api_url character varying(2000) NOT NULL,
    action_api_method character varying(25) NOT NULL,
    action_obj json NOT NULL,
    action_taken_at timestamp with time zone NOT NULL,
    action_type moderation_action_type NOT NULL,
    action_display_text text NOT NULL,
    action_display_url text
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE notifications (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    sender_id uuid NOT NULL,
    receiver_id uuid NOT NULL,
    data json,
    created_at timestamp with time zone,
    viewed boolean DEFAULT false,
    type character varying(255) NOT NULL
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
    expiration timestamp with time zone,
    change_vote boolean DEFAULT false NOT NULL,
    display_mode polls_display_enum DEFAULT 'always'::polls_display_enum NOT NULL
);

--
-- Name: posts_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE posts_history (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    post_id uuid,
    raw_body text DEFAULT ''::text,
    body text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone
);


--
-- Name: private_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE private_conversations (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone
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
    created_at timestamp with time zone,
    viewed boolean DEFAULT false
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    permissions json,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    lookup character varying(255) NOT NULL,
    priority integer NOT NULL,
    highlight_color character varying(255) DEFAULT NULL::character varying
);


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles_users (
    role_id uuid,
    user_id uuid
);

--
-- Name: trust; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE trust (
    user_id uuid NOT NULL,
    user_id_trusted uuid NOT NULL,
    type smallint
);


--
-- Name: trust_boards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE trust_boards (
    board_id uuid NOT NULL
);


--
-- Name: trust_feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE trust_feedback (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    reporter_id uuid NOT NULL,
    risked_btc double precision,
    scammer boolean,
    reference text,
    comments text,
    created_at timestamp with time zone
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
    user_id uuid NOT NULL,
    current_period_start timestamp with time zone,
    current_period_offset timestamp with time zone,
    remaining_period_activity integer DEFAULT 14 NOT NULL,
    total_activity integer DEFAULT 0 NOT NULL
);


--
-- Name: user_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_notes (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    author_id uuid NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);

SET search_path = users, pg_catalog;

--
-- Name: bans; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE bans (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    expiration timestamp with time zone NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
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
    created_at timestamp with time zone
);


--
-- Name: ips; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE ips (
    user_id uuid NOT NULL,
    user_ip character varying(255) NOT NULL,
    created_at timestamp with time zone
);


--
-- Name: preferences; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE preferences (
    user_id uuid,
    posts_per_page integer DEFAULT 25,
    threads_per_page integer DEFAULT 25,
    collapsed_categories json DEFAULT '{"cats":[]}'::json
);


--
-- Name: profiles; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE profiles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid,
    avatar character varying(255) DEFAULT '/static/img/avatar.png'::character varying,
    "position" character varying(255),
    signature text,
    post_count integer DEFAULT 0,
    fields json,
    raw_signature text,
    last_active timestamp with time zone
);


--
-- Name: thread_views; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE thread_views (
    user_id uuid,
    thread_id uuid,
    "time" timestamp with time zone
);


--
-- Name: watch_boards; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE watch_boards (
    user_id uuid NOT NULL,
    board_id uuid NOT NULL
);


--
-- Name: watch_threads; Type: TABLE; Schema: users; Owner: -
--

CREATE TABLE watch_threads (
    user_id uuid NOT NULL,
    thread_id uuid NOT NULL
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


SET search_path = public, pg_catalog;

--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY migrations ALTER COLUMN id SET DEFAULT nextval('migrations_id_seq'::regclass);


SET search_path = administration, pg_catalog;

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
-- Name: ignored ignored_user_id_ignored_user_id_key; Type: CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY ignored
    ADD CONSTRAINT ignored_user_id_ignored_user_id_key UNIQUE (user_id, ignored_user_id);


--
-- Name: mentions mentions_pkey; Type: CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);


SET search_path = metadata, pg_catalog;

--
-- Name: threads threads_thread_id_key; Type: CONSTRAINT; Schema: metadata; Owner: -
--

ALTER TABLE ONLY threads
    ADD CONSTRAINT threads_thread_id_key UNIQUE (thread_id);


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

-- ALTER TABLE ONLY ads
--     ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: auto_moderation auto_moderation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

-- ALTER TABLE ONLY auto_moderation
--     ADD CONSTRAINT auto_moderation_pkey PRIMARY KEY (id);


--
-- Name: banned_addresses banned_addresses_unique_ip_contraint; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY banned_addresses
    ADD CONSTRAINT banned_addresses_unique_ip_contraint UNIQUE (ip1, ip2, ip3, ip4);


--
-- Name: blacklist blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

-- ALTER TABLE ONLY blacklist
--     ADD CONSTRAINT blacklist_pkey PRIMARY KEY (id);


--
-- Name: trust_boards board_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_boards
    ADD CONSTRAINT board_id_unique UNIQUE (board_id);


--
-- Name: factoids factoids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

-- ALTER TABLE ONLY factoids
--     ADD CONSTRAINT factoids_pkey PRIMARY KEY (id);


--
-- Name: images_posts images_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images_posts
    ADD CONSTRAINT images_posts_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


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
-- Name: posts_history posts_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts_history
    ADD CONSTRAINT posts_history_pkey PRIMARY KEY (id);

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
-- Name: trust_feedback trust_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_feedback
    ADD CONSTRAINT trust_feedback_pkey PRIMARY KEY (id);


--
-- Name: trust_max_depth user_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_max_depth
    ADD CONSTRAINT user_id_unique UNIQUE (user_id);


--
-- Name: user_notes user_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notes
    ADD CONSTRAINT user_notes_pkey PRIMARY KEY (id);


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
-- Name: index_reports_messages_notes_on_created_at; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX index_reports_messages_notes_on_created_at ON reports_messages_notes USING btree (created_at);


--
-- Name: index_reports_messages_notes_on_report_id; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX index_reports_messages_notes_on_report_id ON reports_messages_notes USING btree (report_id);

--
-- Name: index_reports_users_notes_on_created_at; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX index_reports_users_notes_on_created_at ON reports_users_notes USING btree (created_at);


--
-- Name: index_reports_users_notes_on_report_id; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX index_reports_users_notes_on_report_id ON reports_users_notes USING btree (report_id);


--
-- Name: index_reports_users_on_created_at; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX index_reports_users_on_created_at ON reports_users USING btree (created_at);


--
-- Name: index_reports_users_on_status_id; Type: INDEX; Schema: administration; Owner: -
--

CREATE INDEX index_reports_users_on_status_id ON reports_users USING btree (status_id);


SET search_path = ads, pg_catalog;

--
-- Name: index_ads_authed_users_on_ad_id; Type: INDEX; Schema: ads; Owner: -
--

CREATE INDEX index_ads_authed_users_on_ad_id ON authed_users USING btree (ad_id);


--
-- Name: index_ads_authed_users_on_ad_id_and_user_id; Type: INDEX; Schema: ads; Owner: -
--

CREATE UNIQUE INDEX index_ads_authed_users_on_ad_id_and_user_id ON authed_users USING btree (ad_id, user_id);


--
-- Name: index_ads_unique_ip_on_ad_id; Type: INDEX; Schema: ads; Owner: -
--

CREATE INDEX index_ads_unique_ip_on_ad_id ON unique_ip USING btree (ad_id);


--
-- Name: index_ads_unique_ip_on_ad_id_and_unique_ip; Type: INDEX; Schema: ads; Owner: -
--

CREATE UNIQUE INDEX index_ads_unique_ip_on_ad_id_and_unique_ip ON unique_ip USING btree (ad_id, unique_ip);


SET search_path = factoids, pg_catalog;

--
-- Name: index_factoids_authed_users_on_round; Type: INDEX; Schema: factoids; Owner: -
--

CREATE INDEX index_factoids_authed_users_on_round ON authed_users USING btree (round);


--
-- Name: index_factoids_authed_users_on_round_and_user_id; Type: INDEX; Schema: factoids; Owner: -
--

CREATE UNIQUE INDEX index_factoids_authed_users_on_round_and_user_id ON authed_users USING btree (round, user_id);


--
-- Name: index_factoids_unique_ip_on_round; Type: INDEX; Schema: factoids; Owner: -
--

CREATE INDEX index_factoids_unique_ip_on_round ON unique_ip USING btree (round);


--
-- Name: index_factoids_unique_ip_on_round_and_unique_ip; Type: INDEX; Schema: factoids; Owner: -
--

CREATE UNIQUE INDEX index_factoids_unique_ip_on_round_and_unique_ip ON unique_ip USING btree (round, unique_ip);


SET search_path = mentions, pg_catalog;

--
-- Name: index_mentions_ignored_on_ignored_user_id; Type: INDEX; Schema: mentions; Owner: -
--

CREATE INDEX index_mentions_ignored_on_ignored_user_id ON ignored USING btree (ignored_user_id);


--
-- Name: index_mentions_ignored_on_user_id; Type: INDEX; Schema: mentions; Owner: -
--

CREATE INDEX index_mentions_ignored_on_user_id ON ignored USING btree (user_id);


--
-- Name: index_mentions_on_mentionee_id; Type: INDEX; Schema: mentions; Owner: -
--

CREATE INDEX index_mentions_on_mentionee_id ON mentions USING btree (mentionee_id);


SET search_path = metadata, pg_catalog;

--
-- Name: index_boards_on_board_id; Type: INDEX; Schema: metadata; Owner: -
--

CREATE UNIQUE INDEX index_boards_on_board_id ON boards USING btree (board_id);


--
-- Name: index_threads_on_thread_id; Type: INDEX; Schema: metadata; Owner: -
--

CREATE UNIQUE INDEX index_threads_on_thread_id ON threads USING btree (thread_id);


SET search_path = public, pg_catalog;

--
-- Name: configurations_one_row; Type: INDEX; Schema: public; Owner: -
--

-- CREATE UNIQUE INDEX configurations_one_row ON configurations USING btree (((log_enabled IS NOT NULL)));
--

--
-- Name: index_ads_on_created_at; Type: INDEX; Schema: public; Owner: -
--

-- CREATE INDEX index_ads_on_created_at ON ads USING btree (created_at);


--
-- Name: index_ads_on_round; Type: INDEX; Schema: public; Owner: -
--

-- CREATE INDEX index_ads_on_round ON ads USING btree (round);


--
-- Name: index_banned_addresses_on_created_at; Type: INDEX; Schema: public; Owner: -
--

-- CREATE INDEX index_banned_addresses_on_created_at ON banned_addresses USING btree (created_at);


--
-- Name: index_banned_addresses_on_decay; Type: INDEX; Schema: public; Owner: -
--

-- CREATE INDEX index_banned_addresses_on_decay ON banned_addresses USING btree (decay);


--
-- Name: index_banned_addresses_on_hostname; Type: INDEX; Schema: public; Owner: -
--

-- CREATE UNIQUE INDEX index_banned_addresses_on_hostname ON banned_addresses USING btree (hostname);


--
-- Name: index_banned_addresses_on_imported_at; Type: INDEX; Schema: public; Owner: -
--

-- CREATE INDEX index_banned_addresses_on_imported_at ON banned_addresses USING btree (imported_at);


--
-- Name: index_banned_addresses_on_weight; Type: INDEX; Schema: public; Owner: -
--

-- CREATE INDEX index_banned_addresses_on_weight ON banned_addresses USING btree (weight);


--
-- Name: index_board_mapping_on_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_mapping_on_board_id ON board_mapping USING btree (board_id);


--
-- Name: index_board_moderators_on_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_moderators_on_board_id ON board_moderators USING btree (board_id);


--
-- Name: index_board_moderators_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_moderators_on_user_id ON board_moderators USING btree (user_id);


--
-- Name: index_board_moderators_on_user_id_and_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_moderators_on_user_id_and_board_id ON board_moderators USING btree (user_id, board_id);


--
-- Name: index_conversation_id_on_private_messages; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_conversation_id_on_private_messages ON private_messages USING btree (conversation_id);


--
-- Name: index_created_at_on_private_messages; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_created_at_on_private_messages ON private_messages USING btree (created_at DESC);


--
-- Name: index_factoids_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_factoids_on_created_at ON factoids USING btree (created_at);


--
-- Name: index_factoids_on_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_factoids_on_enabled ON factoids USING btree (enabled);


--
-- Name: index_images_posts_on_image_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_posts_on_image_url ON images_posts USING btree (image_url);


--
-- Name: index_images_posts_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_images_posts_on_post_id ON images_posts USING btree (post_id);


--
-- Name: index_invitations_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_created_at ON invitations USING btree (created_at);


--
-- Name: index_invitations_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invitations_on_email ON invitations USING btree (email);


--
-- Name: index_invitations_on_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_hash ON invitations USING btree (hash);


--
-- Name: index_ip_route_method_on_backoff; Type: INDEX; Schema: public; Owner: -
--

-- CREATE INDEX index_ip_route_method_on_backoff ON backoff USING btree (ip, route, method);


--
-- Name: index_moderation_log_on_action_api_method; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moderation_log_on_action_api_method ON moderation_log USING btree (action_api_method);


--
-- Name: index_moderation_log_on_action_api_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moderation_log_on_action_api_url ON moderation_log USING btree (action_api_url);


--
-- Name: index_moderation_log_on_action_taken_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moderation_log_on_action_taken_at ON moderation_log USING btree (action_taken_at);


--
-- Name: index_moderation_log_on_action_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moderation_log_on_action_type ON moderation_log USING btree (action_type);


--
-- Name: index_moderation_log_on_mod_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moderation_log_on_mod_id ON moderation_log USING btree (mod_id);


--
-- Name: index_moderation_log_on_mod_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moderation_log_on_mod_ip ON moderation_log USING btree (mod_ip);


--
-- Name: index_moderation_log_on_mod_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moderation_log_on_mod_username ON moderation_log USING btree (mod_username);


--
-- Name: index_notifications_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_type ON notifications USING btree (type);


--
-- Name: index_poll_answers_on_poll_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_poll_answers_on_poll_id ON poll_answers USING btree (poll_id);


--
-- Name: index_poll_responses_on_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_poll_responses_on_answer_id ON poll_responses USING btree (answer_id);


--
-- Name: index_poll_responses_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_poll_responses_on_user_id ON poll_responses USING btree (user_id);


--
-- Name: index_polls_on_thread_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_polls_on_thread_id ON polls USING btree (thread_id);


--
-- Name: index_receiver_id_on_private_messages; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_receiver_id_on_private_messages ON private_messages USING btree (receiver_id);


--
-- Name: index_roles_on_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_roles_on_lookup ON roles USING btree (lookup);


--
-- Name: index_sender_id_on_private_messages; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sender_id_on_private_messages ON private_messages USING btree (sender_id);


--
-- Name: index_threads_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_threads_lookup ON threads USING btree (board_id, updated_at DESC);

--
-- Name: index_threads_on_sticky; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_threads_on_sticky ON threads USING btree (board_id) WHERE (sticky = true);


--
-- Name: index_threads_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_threads_on_updated_at ON threads USING btree (updated_at);


--
-- Name: index_trust_feedback_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trust_feedback_on_created_at ON trust_feedback USING btree (created_at);


--
-- Name: index_trust_feedback_on_reporter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trust_feedback_on_reporter_id ON trust_feedback USING btree (reporter_id);


--
-- Name: index_trust_feedback_on_scammer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trust_feedback_on_scammer ON trust_feedback USING btree (scammer);


--
-- Name: index_trust_feedback_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trust_feedback_on_user_id ON trust_feedback USING btree (user_id);


--
-- Name: index_trust_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trust_on_type ON trust USING btree (type);


--
-- Name: index_trust_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trust_on_user_id ON trust USING btree (user_id);


--
-- Name: index_trust_on_user_id_trusted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trust_on_user_id_trusted ON trust USING btree (user_id_trusted);


--
-- Name: index_user_activity_on_total_activity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_activity_on_total_activity ON user_activity USING btree (total_activity);


--
-- Name: index_user_activity_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_activity_on_user_id ON user_activity USING btree (user_id);


--
-- Name: index_user_notes_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_notes_on_created_at ON user_notes USING btree (created_at);


--
-- Name: index_user_notes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_notes_on_user_id ON user_notes USING btree (user_id);

SET search_path = users, pg_catalog;

--
-- Name: index_bans_on_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX index_bans_on_user_id ON bans USING btree (user_id);


--
-- Name: index_board_bans_on_board_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_board_bans_on_board_id ON board_bans USING btree (board_id);


--
-- Name: index_board_bans_on_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_board_bans_on_user_id ON board_bans USING btree (user_id);


--
-- Name: index_board_bans_on_user_id_and_board_id; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX index_board_bans_on_user_id_and_board_id ON board_bans USING btree (user_id, board_id);


--
-- Name: index_ignored_on_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_ignored_on_user_id ON ignored USING btree (user_id);


--
-- Name: index_ignored_on_user_id_ignored_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX index_ignored_on_user_id_ignored_user_id ON ignored USING btree (user_id, ignored_user_id);


--
-- Name: index_ignored_on_user_ip; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_ignored_on_user_ip ON ignored USING btree (ignored_user_id);


--
-- Name: index_ips_on_created_at; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_ips_on_created_at ON ips USING btree (created_at);


--
-- Name: index_ips_on_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_ips_on_user_id ON ips USING btree (user_id);


--
-- Name: index_ips_on_user_id_and_user_ip; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX index_ips_on_user_id_and_user_ip ON ips USING btree (user_id, user_ip);


--
-- Name: index_ips_on_user_ip; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_ips_on_user_ip ON ips USING btree (user_ip);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);


--
-- Name: index_thread_views_on_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_thread_views_on_user_id ON thread_views USING btree (user_id);


--
-- Name: index_thread_views_on_user_id_and_thread_id; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX index_thread_views_on_user_id_and_thread_id ON thread_views USING btree (user_id, thread_id);


--
-- Name: index_users_preferences_on_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_users_preferences_on_user_id ON preferences USING btree (user_id);


--
-- Name: index_users_profiles_on_last_active; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_users_profiles_on_last_active ON profiles USING btree (last_active DESC);


--
-- Name: index_watch_boards_on_board_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_watch_boards_on_board_id ON watch_boards USING btree (board_id);


--
-- Name: index_watch_boards_on_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_watch_boards_on_user_id ON watch_boards USING btree (user_id);


--
-- Name: index_watch_boards_on_user_id_and_board_id; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX index_watch_boards_on_user_id_and_board_id ON watch_boards USING btree (user_id, board_id);


--
-- Name: index_watch_threads_on_thread_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_watch_threads_on_thread_id ON watch_threads USING btree (thread_id);


--
-- Name: index_watch_threads_on_user_id; Type: INDEX; Schema: users; Owner: -
--

CREATE INDEX index_watch_threads_on_user_id ON watch_threads USING btree (user_id);


--
-- Name: index_watch_threads_on_user_id_and_thread_id; Type: INDEX; Schema: users; Owner: -
--

CREATE UNIQUE INDEX index_watch_threads_on_user_id_and_thread_id ON watch_threads USING btree (user_id, thread_id);


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
-- Name: reports_messages offender_message_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT offender_message_id_fk FOREIGN KEY (offender_message_id) REFERENCES public.private_messages(id) ON DELETE CASCADE;


--
-- Name: reports_users offender_user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users
    ADD CONSTRAINT offender_user_id_fk FOREIGN KEY (offender_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reports_users_notes report_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users_notes
    ADD CONSTRAINT report_id_fk FOREIGN KEY (report_id) REFERENCES reports_users(id) ON DELETE CASCADE;


--
-- Name: reports_messages_notes report_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages_notes
    ADD CONSTRAINT report_id_fk FOREIGN KEY (report_id) REFERENCES reports_messages(id) ON DELETE CASCADE;


--
-- Name: reports_users reporter_user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users
    ADD CONSTRAINT reporter_user_id_fk FOREIGN KEY (reporter_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_messages reporter_user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT reporter_user_id_fk FOREIGN KEY (reporter_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_users reviewer_user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users
    ADD CONSTRAINT reviewer_user_id_fk FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_messages reviewer_user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT reviewer_user_id_fk FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_users status_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users
    ADD CONSTRAINT status_id_fk FOREIGN KEY (status_id) REFERENCES reports_statuses(id);


--
-- Name: reports_messages status_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT status_id_fk FOREIGN KEY (status_id) REFERENCES reports_statuses(id);


--
-- Name: reports_users_notes user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_users_notes
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_messages_notes user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages_notes
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


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
-- Name: ignored ignored_ignored_user_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY ignored
    ADD CONSTRAINT ignored_ignored_user_id_fkey FOREIGN KEY (ignored_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ignored ignored_user_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY ignored
    ADD CONSTRAINT ignored_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentions mentions_mentionee_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_mentionee_id_fkey FOREIGN KEY (mentionee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: mentions mentions_mentioner_id_fkey; Type: FK CONSTRAINT; Schema: mentions; Owner: -
--

ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_mentioner_id_fkey FOREIGN KEY (mentioner_id) REFERENCES public.users(id);


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


SET search_path = metadata, pg_catalog;

--
-- Name: boards boards_last_thread_id_fk; Type: FK CONSTRAINT; Schema: metadata; Owner: -
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_last_thread_id_fk FOREIGN KEY (last_thread_id) REFERENCES public.threads(id) ON UPDATE CASCADE ON DELETE SET NULL;

SET search_path = public, pg_catalog;

--
-- Name: user_notes author_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notes
    ADD CONSTRAINT author_user_id_fk FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: trust_boards board_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_boards
    ADD CONSTRAINT board_id_fk FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE;


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


ALTER TABLE ONLY board_mapping
    ADD CONSTRAINT board_mapping_unique_parent UNIQUE (board_id, parent_id);

ALTER TABLE ONLY board_mapping
    ADD CONSTRAINT board_mapping_unique_category UNIQUE (board_id, category_id);

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
-- Name: configurations configurations_portal.board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY configurations
    ADD CONSTRAINT "configurations_portal.board_id_fkey" FOREIGN KEY ("portal.board_id") REFERENCES boards(id);


--
-- Name: images_posts images_posts_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images_posts
    ADD CONSTRAINT images_posts_post_id_fkey FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE SET NULL;


--
-- Name: notifications notifications_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE;


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
    ADD CONSTRAINT polls_thread_id_fkey FOREIGN KEY (thread_id) REFERENCES threads(id) ON DELETE CASCADE;


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
-- Name: trust_feedback reporter_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_feedback
    ADD CONSTRAINT reporter_id_fk FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: threads threads_board_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY threads
    ADD CONSTRAINT threads_board_id_fk FOREIGN KEY (board_id) REFERENCES boards(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_notes user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_notes
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: user_activity user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_activity
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: trust user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: trust_feedback user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_feedback
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: trust_max_depth user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust_max_depth
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: trust user_id_trusted_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trust
    ADD CONSTRAINT user_id_trusted_fk FOREIGN KEY (user_id_trusted) REFERENCES users(id) ON DELETE CASCADE;


SET search_path = users, pg_catalog;

--
-- Name: bans bans_user_id_fk; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY bans
    ADD CONSTRAINT bans_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: board_bans board_bans_board_id_fk; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY board_bans
    ADD CONSTRAINT board_bans_board_id_fk FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: board_bans board_bans_user_id_fk; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY board_bans
    ADD CONSTRAINT board_bans_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: preferences preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY preferences
    ADD CONSTRAINT preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: profiles profiles_user_id_fk; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: thread_views thread_views_thread_id_fk; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY thread_views
    ADD CONSTRAINT thread_views_thread_id_fk FOREIGN KEY (thread_id) REFERENCES public.threads(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: thread_views thread_views_user_id_fk; Type: FK CONSTRAINT; Schema: users; Owner: -
--

ALTER TABLE ONLY thread_views
    ADD CONSTRAINT thread_views_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


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


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
SET default_tablespace = '';
SET default_with_oids = false;

SET search_path = users, pg_catalog;

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


SET search_path = administration, pg_catalog;

--
-- Name: reports_messages offender_message_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT offender_message_id_fk FOREIGN KEY (offender_message_id) REFERENCES public.private_messages(id) ON DELETE CASCADE;


--
-- Name: reports_messages_notes report_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages_notes
    ADD CONSTRAINT report_id_fk FOREIGN KEY (report_id) REFERENCES reports_messages(id) ON DELETE CASCADE;


--
-- Name: reports_messages reporter_user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT reporter_user_id_fk FOREIGN KEY (reporter_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_messages reviewer_user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT reviewer_user_id_fk FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports_messages status_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages
    ADD CONSTRAINT status_id_fk FOREIGN KEY (status_id) REFERENCES reports_statuses(id);


--
-- Name: reports_messages_notes user_id_fk; Type: FK CONSTRAINT; Schema: administration; Owner: -
--

ALTER TABLE ONLY reports_messages_notes
    ADD CONSTRAINT user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;

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
-- Name: threads threads_board_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY threads
    ADD CONSTRAINT threads_board_id_fk FOREIGN KEY (board_id) REFERENCES boards(id) ON UPDATE CASCADE ON DELETE CASCADE;


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


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


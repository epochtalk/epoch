SET search_path = ads, pg_catalog;

--
-- Name: authed_users update_unique_authed_user_score_on_ad_trigger; Type: TRIGGER; Schema: ads; Owner: -
--
--
-- CREATE TRIGGER update_unique_authed_user_score_on_ad_trigger AFTER INSERT ON authed_users FOR EACH ROW EXECUTE PROCEDURE public.update_unique_authed_user_score_on_ad();


--
-- Name: unique_ip update_unique_ip_score_on_ad_trigger; Type: TRIGGER; Schema: ads; Owner: -
--

-- CREATE TRIGGER update_unique_ip_score_on_ad_trigger AFTER INSERT ON unique_ip FOR EACH ROW EXECUTE PROCEDURE public.update_unique_ip_score_on_ad();
--

SET search_path = factoids, pg_catalog;

--
-- Name: authed_users update_unique_authed_user_score_on_factoid_trigger; Type: TRIGGER; Schema: factoids; Owner: -
--

-- CREATE TRIGGER update_unique_authed_user_score_on_factoid_trigger AFTER INSERT ON authed_users FOR EACH ROW EXECUTE PROCEDURE public.update_unique_authed_user_score_on_factoid();


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


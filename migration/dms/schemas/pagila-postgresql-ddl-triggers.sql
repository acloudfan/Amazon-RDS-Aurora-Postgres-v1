CREATE TRIGGER film_fulltext_trigger BEFORE INSERT OR UPDATE ON pagila.film FOR EACH ROW EXECUTE FUNCTION tsvector_update_trigger('fulltext', 'pg_catalog.english', 'title', 'description');


--
-- Name: actor last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.actor FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: address last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.address FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: category last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.category FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: city last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.city FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: country last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.country FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: customer last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.customer FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: film last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.film FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: film_actor last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.film_actor FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: film_category last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.film_category FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: inventory last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.inventory FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: language last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.language FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: rental last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.rental FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: staff last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.staff FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


--
-- Name: store last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER last_updated BEFORE UPDATE ON pagila.store FOR EACH ROW EXECUTE FUNCTION pagila.last_updated();


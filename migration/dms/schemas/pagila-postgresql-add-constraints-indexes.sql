--
-- Name: actor actor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (actor_id);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- Name: city city_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (city_id);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: film_actor film_actor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.film_actor
    ADD CONSTRAINT film_actor_pkey PRIMARY KEY (actor_id, film_id);


--
-- Name: film_category film_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.film_category
    ADD CONSTRAINT film_category_pkey PRIMARY KEY (film_id, category_id);


--
-- Name: film film_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.film
    ADD CONSTRAINT film_pkey PRIMARY KEY (film_id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);


--
-- Name: language language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (language_id);


--
-- Name: rental rental_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.rental
    ADD CONSTRAINT rental_pkey PRIMARY KEY (rental_id);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (store_id);


--
-- Name: film_fulltext_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX film_fulltext_idx ON pagila.film USING gist (fulltext);


--
-- Name: idx_actor_last_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_actor_last_name ON pagila.actor USING btree (last_name);


--
-- Name: idx_fk_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_address_id ON pagila.customer USING btree (address_id);


--
-- Name: idx_fk_city_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_city_id ON pagila.address USING btree (city_id);


--
-- Name: idx_fk_country_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_country_id ON pagila.city USING btree (country_id);


--
-- Name: idx_fk_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_customer_id ON ONLY pagila.payment USING btree (customer_id);


--
-- Name: idx_fk_film_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_film_id ON pagila.film_actor USING btree (film_id);


--
-- Name: idx_fk_inventory_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_inventory_id ON pagila.rental USING btree (inventory_id);


--
-- Name: idx_fk_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_language_id ON pagila.film USING btree (language_id);


--
-- Name: idx_fk_original_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_original_language_id ON pagila.film USING btree (original_language_id);


--
-- Name: idx_fk_payment_p2020_01_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_01_customer_id ON pagila.payment_p2020_01 USING btree (customer_id);


--
-- Name: idx_fk_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_staff_id ON ONLY pagila.payment USING btree (staff_id);


--
-- Name: idx_fk_payment_p2020_01_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_01_staff_id ON pagila.payment_p2020_01 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2020_02_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_02_customer_id ON pagila.payment_p2020_02 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2020_02_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_02_staff_id ON pagila.payment_p2020_02 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2020_03_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_03_customer_id ON pagila.payment_p2020_03 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2020_03_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_03_staff_id ON pagila.payment_p2020_03 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2020_04_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_04_customer_id ON pagila.payment_p2020_04 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2020_04_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_04_staff_id ON pagila.payment_p2020_04 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2020_05_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_05_customer_id ON pagila.payment_p2020_05 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2020_05_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_05_staff_id ON pagila.payment_p2020_05 USING btree (staff_id);


--
-- Name: idx_fk_payment_p2020_06_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_06_customer_id ON pagila.payment_p2020_06 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2020_06_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_payment_p2020_06_staff_id ON pagila.payment_p2020_06 USING btree (staff_id);


--
-- Name: idx_fk_store_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fk_store_id ON pagila.customer USING btree (store_id);


--
-- Name: idx_last_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_last_name ON pagila.customer USING btree (last_name);


--
-- Name: idx_store_id_film_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_store_id_film_id ON pagila.inventory USING btree (store_id, film_id);


--
-- Name: idx_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_title ON pagila.film USING btree (title);


--
-- Name: idx_unq_manager_staff_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unq_manager_staff_id ON pagila.store USING btree (manager_staff_id);


--
-- Name: idx_unq_rental_rental_date_inventory_id_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unq_rental_rental_date_inventory_id_customer_id ON pagila.rental USING btree (rental_date, inventory_id, customer_id);


--
-- Name: payment_p2020_01_customer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_p2020_01_customer_id_idx ON pagila.payment_p2020_01 USING btree (customer_id);


--
-- Name: payment_p2020_02_customer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_p2020_02_customer_id_idx ON pagila.payment_p2020_02 USING btree (customer_id);


--
-- Name: payment_p2020_03_customer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_p2020_03_customer_id_idx ON pagila.payment_p2020_03 USING btree (customer_id);


--
-- Name: payment_p2020_04_customer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_p2020_04_customer_id_idx ON pagila.payment_p2020_04 USING btree (customer_id);


--
-- Name: payment_p2020_05_customer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_p2020_05_customer_id_idx ON pagila.payment_p2020_05 USING btree (customer_id);


--
-- Name: payment_p2020_06_customer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX payment_p2020_06_customer_id_idx ON pagila.payment_p2020_06 USING btree (customer_id);


--
-- Name: idx_fk_payment_p2020_01_staff_id; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_staff_id ATTACH PARTITION pagila.idx_fk_payment_p2020_01_staff_id;


--
-- Name: idx_fk_payment_p2020_02_staff_id; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_staff_id ATTACH PARTITION pagila.idx_fk_payment_p2020_02_staff_id;


--
-- Name: idx_fk_payment_p2020_03_staff_id; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_staff_id ATTACH PARTITION pagila.idx_fk_payment_p2020_03_staff_id;


--
-- Name: idx_fk_payment_p2020_04_staff_id; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_staff_id ATTACH PARTITION pagila.idx_fk_payment_p2020_04_staff_id;


--
-- Name: idx_fk_payment_p2020_05_staff_id; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_staff_id ATTACH PARTITION pagila.idx_fk_payment_p2020_05_staff_id;


--
-- Name: idx_fk_payment_p2020_06_staff_id; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_staff_id ATTACH PARTITION pagila.idx_fk_payment_p2020_06_staff_id;


--
-- Name: payment_p2020_01_customer_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_customer_id ATTACH PARTITION pagila.payment_p2020_01_customer_id_idx;


--
-- Name: payment_p2020_02_customer_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_customer_id ATTACH PARTITION pagila.payment_p2020_02_customer_id_idx;


--
-- Name: payment_p2020_03_customer_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_customer_id ATTACH PARTITION pagila.payment_p2020_03_customer_id_idx;


--
-- Name: payment_p2020_04_customer_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_customer_id ATTACH PARTITION pagila.payment_p2020_04_customer_id_idx;


--
-- Name: payment_p2020_05_customer_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_customer_id ATTACH PARTITION pagila.payment_p2020_05_customer_id_idx;


--
-- Name: payment_p2020_06_customer_id_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX pagila.idx_fk_customer_id ATTACH PARTITION pagila.payment_p2020_06_customer_id_idx;


--
-- Name: film film_fulltext_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

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


--
-- Name: address address_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.address
    ADD CONSTRAINT address_city_id_fkey FOREIGN KEY (city_id) REFERENCES pagila.city(city_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: city city_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.city
    ADD CONSTRAINT city_country_id_fkey FOREIGN KEY (country_id) REFERENCES pagila.country(country_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: customer customer_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.customer
    ADD CONSTRAINT customer_address_id_fkey FOREIGN KEY (address_id) REFERENCES pagila.address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: customer customer_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.customer
    ADD CONSTRAINT customer_store_id_fkey FOREIGN KEY (store_id) REFERENCES pagila.store(store_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_actor film_actor_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.film_actor
    ADD CONSTRAINT film_actor_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES pagila.actor(actor_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_actor film_actor_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.film_actor
    ADD CONSTRAINT film_actor_film_id_fkey FOREIGN KEY (film_id) REFERENCES pagila.film(film_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_category film_category_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.film_category
    ADD CONSTRAINT film_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES pagila.category(category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film_category film_category_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.film_category
    ADD CONSTRAINT film_category_film_id_fkey FOREIGN KEY (film_id) REFERENCES pagila.film(film_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film film_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.film
    ADD CONSTRAINT film_language_id_fkey FOREIGN KEY (language_id) REFERENCES pagila.language(language_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: film film_original_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.film
    ADD CONSTRAINT film_original_language_id_fkey FOREIGN KEY (original_language_id) REFERENCES pagila.language(language_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inventory inventory_film_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.inventory
    ADD CONSTRAINT inventory_film_id_fkey FOREIGN KEY (film_id) REFERENCES pagila.film(film_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inventory inventory_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.inventory
    ADD CONSTRAINT inventory_store_id_fkey FOREIGN KEY (store_id) REFERENCES pagila.store(store_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: payment_p2020_01 payment_p2020_01_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_01
    ADD CONSTRAINT payment_p2020_01_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES pagila.customer(customer_id);


--
-- Name: payment_p2020_01 payment_p2020_01_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_01
    ADD CONSTRAINT payment_p2020_01_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES pagila.rental(rental_id);


--
-- Name: payment_p2020_01 payment_p2020_01_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_01
    ADD CONSTRAINT payment_p2020_01_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES pagila.staff(staff_id);


--
-- Name: payment_p2020_02 payment_p2020_02_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_02
    ADD CONSTRAINT payment_p2020_02_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES pagila.customer(customer_id);


--
-- Name: payment_p2020_02 payment_p2020_02_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_02
    ADD CONSTRAINT payment_p2020_02_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES pagila.rental(rental_id);


--
-- Name: payment_p2020_02 payment_p2020_02_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_02
    ADD CONSTRAINT payment_p2020_02_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES pagila.staff(staff_id);


--
-- Name: payment_p2020_03 payment_p2020_03_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_03
    ADD CONSTRAINT payment_p2020_03_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES pagila.customer(customer_id);


--
-- Name: payment_p2020_03 payment_p2020_03_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_03
    ADD CONSTRAINT payment_p2020_03_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES pagila.rental(rental_id);


--
-- Name: payment_p2020_03 payment_p2020_03_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_03
    ADD CONSTRAINT payment_p2020_03_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES pagila.staff(staff_id);


--
-- Name: payment_p2020_04 payment_p2020_04_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_04
    ADD CONSTRAINT payment_p2020_04_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES pagila.customer(customer_id);


--
-- Name: payment_p2020_04 payment_p2020_04_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_04
    ADD CONSTRAINT payment_p2020_04_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES pagila.rental(rental_id);


--
-- Name: payment_p2020_04 payment_p2020_04_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_04
    ADD CONSTRAINT payment_p2020_04_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES pagila.staff(staff_id);


--
-- Name: payment_p2020_05 payment_p2020_05_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_05
    ADD CONSTRAINT payment_p2020_05_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES pagila.customer(customer_id);


--
-- Name: payment_p2020_05 payment_p2020_05_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_05
    ADD CONSTRAINT payment_p2020_05_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES pagila.rental(rental_id);


--
-- Name: payment_p2020_05 payment_p2020_05_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_05
    ADD CONSTRAINT payment_p2020_05_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES pagila.staff(staff_id);


--
-- Name: payment_p2020_06 payment_p2020_06_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_06
    ADD CONSTRAINT payment_p2020_06_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES pagila.customer(customer_id);


--
-- Name: payment_p2020_06 payment_p2020_06_rental_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_06
    ADD CONSTRAINT payment_p2020_06_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES pagila.rental(rental_id);


--
-- Name: payment_p2020_06 payment_p2020_06_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.payment_p2020_06
    ADD CONSTRAINT payment_p2020_06_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES pagila.staff(staff_id);


--
-- Name: rental rental_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.rental
    ADD CONSTRAINT rental_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES pagila.customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rental rental_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.rental
    ADD CONSTRAINT rental_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES pagila.inventory(inventory_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rental rental_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.rental
    ADD CONSTRAINT rental_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES pagila.staff(staff_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: staff staff_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.staff
    ADD CONSTRAINT staff_address_id_fkey FOREIGN KEY (address_id) REFERENCES pagila.address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: staff staff_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.staff
    ADD CONSTRAINT staff_store_id_fkey FOREIGN KEY (store_id) REFERENCES pagila.store(store_id);


--
-- Name: store store_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pagila.store
    ADD CONSTRAINT store_address_id_fkey FOREIGN KEY (address_id) REFERENCES pagila.address(address_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

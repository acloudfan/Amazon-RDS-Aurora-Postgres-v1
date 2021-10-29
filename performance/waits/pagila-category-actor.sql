--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: postgres
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.actor DISABLE TRIGGER ALL;

INSERT INTO public.actor VALUES (1, 'PENELOPE', 'GUINESS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (2, 'NICK', 'WAHLBERG', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (3, 'ED', 'CHASE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (4, 'JENNIFER', 'DAVIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (5, 'JOHNNY', 'LOLLOBRIGIDA', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (6, 'BETTE', 'NICHOLSON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (7, 'GRACE', 'MOSTEL', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (8, 'MATTHEW', 'JOHANSSON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (9, 'JOE', 'SWANK', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (10, 'CHRISTIAN', 'GABLE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (11, 'ZERO', 'CAGE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (12, 'KARL', 'BERRY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (13, 'UMA', 'WOOD', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (14, 'VIVIEN', 'BERGEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (15, 'CUBA', 'OLIVIER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (16, 'FRED', 'COSTNER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (17, 'HELEN', 'VOIGHT', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (18, 'DAN', 'TORN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (19, 'BOB', 'FAWCETT', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (20, 'LUCILLE', 'TRACY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (21, 'KIRSTEN', 'PALTROW', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (22, 'ELVIS', 'MARX', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (23, 'SANDRA', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (24, 'CAMERON', 'STREEP', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (25, 'KEVIN', 'BLOOM', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (26, 'RIP', 'CRAWFORD', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (27, 'JULIA', 'MCQUEEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (28, 'WOODY', 'HOFFMAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (29, 'ALEC', 'WAYNE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (30, 'SANDRA', 'PECK', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (31, 'SISSY', 'SOBIESKI', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (32, 'TIM', 'HACKMAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (33, 'MILLA', 'PECK', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (34, 'AUDREY', 'OLIVIER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (35, 'JUDY', 'DEAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (36, 'BURT', 'DUKAKIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (37, 'VAL', 'BOLGER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (38, 'TOM', 'MCKELLEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (39, 'GOLDIE', 'BRODY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (40, 'JOHNNY', 'CAGE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (41, 'JODIE', 'DEGENERES', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (42, 'TOM', 'MIRANDA', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (43, 'KIRK', 'JOVOVICH', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (44, 'NICK', 'STALLONE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (45, 'REESE', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (46, 'PARKER', 'GOLDBERG', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (47, 'JULIA', 'BARRYMORE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (48, 'FRANCES', 'DAY-LEWIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (49, 'ANNE', 'CRONYN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (50, 'NATALIE', 'HOPKINS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (51, 'GARY', 'PHOENIX', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (52, 'CARMEN', 'HUNT', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (53, 'MENA', 'TEMPLE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (54, 'PENELOPE', 'PINKETT', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (55, 'FAY', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (56, 'DAN', 'HARRIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (57, 'JUDE', 'CRUISE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (58, 'CHRISTIAN', 'AKROYD', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (59, 'DUSTIN', 'TAUTOU', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (60, 'HENRY', 'BERRY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (61, 'CHRISTIAN', 'NEESON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (62, 'JAYNE', 'NEESON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (63, 'CAMERON', 'WRAY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (64, 'RAY', 'JOHANSSON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (65, 'ANGELA', 'HUDSON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (66, 'MARY', 'TANDY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (67, 'JESSICA', 'BAILEY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (68, 'RIP', 'WINSLET', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (69, 'KENNETH', 'PALTROW', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (70, 'MICHELLE', 'MCCONAUGHEY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (71, 'ADAM', 'GRANT', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (72, 'SEAN', 'WILLIAMS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (73, 'GARY', 'PENN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (74, 'MILLA', 'KEITEL', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (75, 'BURT', 'POSEY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (76, 'ANGELINA', 'ASTAIRE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (77, 'CARY', 'MCCONAUGHEY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (78, 'GROUCHO', 'SINATRA', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (79, 'MAE', 'HOFFMAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (80, 'RALPH', 'CRUZ', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (81, 'SCARLETT', 'DAMON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (82, 'WOODY', 'JOLIE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (83, 'BEN', 'WILLIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (84, 'JAMES', 'PITT', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (85, 'MINNIE', 'ZELLWEGER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (86, 'GREG', 'CHAPLIN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (87, 'SPENCER', 'PECK', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (88, 'KENNETH', 'PESCI', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (89, 'CHARLIZE', 'DENCH', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (90, 'SEAN', 'GUINESS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (91, 'CHRISTOPHER', 'BERRY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (92, 'KIRSTEN', 'AKROYD', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (93, 'ELLEN', 'PRESLEY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (94, 'KENNETH', 'TORN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (95, 'DARYL', 'WAHLBERG', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (96, 'GENE', 'WILLIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (97, 'MEG', 'HAWKE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (98, 'CHRIS', 'BRIDGES', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (99, 'JIM', 'MOSTEL', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (100, 'SPENCER', 'DEPP', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (101, 'SUSAN', 'DAVIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (102, 'WALTER', 'TORN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (103, 'MATTHEW', 'LEIGH', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (104, 'PENELOPE', 'CRONYN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (105, 'SIDNEY', 'CROWE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (106, 'GROUCHO', 'DUNST', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (107, 'GINA', 'DEGENERES', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (108, 'WARREN', 'NOLTE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (109, 'SYLVESTER', 'DERN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (110, 'SUSAN', 'DAVIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (111, 'CAMERON', 'ZELLWEGER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (112, 'RUSSELL', 'BACALL', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (113, 'MORGAN', 'HOPKINS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (114, 'MORGAN', 'MCDORMAND', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (115, 'HARRISON', 'BALE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (116, 'DAN', 'STREEP', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (117, 'RENEE', 'TRACY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (118, 'CUBA', 'ALLEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (119, 'WARREN', 'JACKMAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (120, 'PENELOPE', 'MONROE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (121, 'LIZA', 'BERGMAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (122, 'SALMA', 'NOLTE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (123, 'JULIANNE', 'DENCH', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (124, 'SCARLETT', 'BENING', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (125, 'ALBERT', 'NOLTE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (126, 'FRANCES', 'TOMEI', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (127, 'KEVIN', 'GARLAND', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (128, 'CATE', 'MCQUEEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (129, 'DARYL', 'CRAWFORD', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (130, 'GRETA', 'KEITEL', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (131, 'JANE', 'JACKMAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (132, 'ADAM', 'HOPPER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (133, 'RICHARD', 'PENN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (134, 'GENE', 'HOPKINS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (135, 'RITA', 'REYNOLDS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (136, 'ED', 'MANSFIELD', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (137, 'MORGAN', 'WILLIAMS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (138, 'LUCILLE', 'DEE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (139, 'EWAN', 'GOODING', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (140, 'WHOOPI', 'HURT', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (141, 'CATE', 'HARRIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (142, 'JADA', 'RYDER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (143, 'RIVER', 'DEAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (144, 'ANGELA', 'WITHERSPOON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (145, 'KIM', 'ALLEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (146, 'ALBERT', 'JOHANSSON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (147, 'FAY', 'WINSLET', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (148, 'EMILY', 'DEE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (149, 'RUSSELL', 'TEMPLE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (150, 'JAYNE', 'NOLTE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (151, 'GEOFFREY', 'HESTON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (152, 'BEN', 'HARRIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (153, 'MINNIE', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (154, 'MERYL', 'GIBSON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (155, 'IAN', 'TANDY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (156, 'FAY', 'WOOD', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (157, 'GRETA', 'MALDEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (158, 'VIVIEN', 'BASINGER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (159, 'LAURA', 'BRODY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (160, 'CHRIS', 'DEPP', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (161, 'HARVEY', 'HOPE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (162, 'OPRAH', 'KILMER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (163, 'CHRISTOPHER', 'WEST', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (164, 'HUMPHREY', 'WILLIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (165, 'AL', 'GARLAND', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (166, 'NICK', 'DEGENERES', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (167, 'LAURENCE', 'BULLOCK', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (168, 'WILL', 'WILSON', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (169, 'KENNETH', 'HOFFMAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (170, 'MENA', 'HOPPER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (171, 'OLYMPIA', 'PFEIFFER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (172, 'GROUCHO', 'WILLIAMS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (173, 'ALAN', 'DREYFUSS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (174, 'MICHAEL', 'BENING', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (175, 'WILLIAM', 'HACKMAN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (176, 'JON', 'CHASE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (177, 'GENE', 'MCKELLEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (178, 'LISA', 'MONROE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (179, 'ED', 'GUINESS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (180, 'JEFF', 'SILVERSTONE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (181, 'MATTHEW', 'CARREY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (182, 'DEBBIE', 'AKROYD', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (183, 'RUSSELL', 'CLOSE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (184, 'HUMPHREY', 'GARLAND', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (185, 'MICHAEL', 'BOLGER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (186, 'JULIA', 'ZELLWEGER', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (187, 'RENEE', 'BALL', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (188, 'ROCK', 'DUKAKIS', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (189, 'CUBA', 'BIRCH', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (190, 'AUDREY', 'BAILEY', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (191, 'GREGORY', 'GOODING', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (192, 'JOHN', 'SUVARI', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (193, 'BURT', 'TEMPLE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (194, 'MERYL', 'ALLEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (195, 'JAYNE', 'SILVERSTONE', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (196, 'BELA', 'WALKEN', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (197, 'REESE', 'WEST', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (198, 'MARY', 'KEITEL', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (199, 'JULIA', 'FAWCETT', '2006-02-15 09:34:33');
INSERT INTO public.actor VALUES (200, 'THORA', 'TEMPLE', '2006-02-15 09:34:33');


ALTER TABLE public.actor ENABLE TRIGGER ALL;



--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.category DISABLE TRIGGER ALL;

INSERT INTO public.category VALUES (1, 'Action', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (2, 'Animation', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (3, 'Children', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (4, 'Classics', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (5, 'Comedy', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (6, 'Documentary', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (7, 'Drama', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (8, 'Family', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (9, 'Foreign', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (10, 'Games', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (11, 'Horror', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (12, 'Music', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (13, 'New', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (14, 'Sci-Fi', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (15, 'Sports', '2006-02-15 09:46:27');
INSERT INTO public.category VALUES (16, 'Travel', '2006-02-15 09:46:27');


ALTER TABLE public.category ENABLE TRIGGER ALL;



--
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.language DISABLE TRIGGER ALL;

INSERT INTO public.language VALUES (1, 'English             ', '2006-02-15 10:02:19');
INSERT INTO public.language VALUES (2, 'Italian             ', '2006-02-15 10:02:19');
INSERT INTO public.language VALUES (3, 'Japanese            ', '2006-02-15 10:02:19');
INSERT INTO public.language VALUES (4, 'Mandarin            ', '2006-02-15 10:02:19');
INSERT INTO public.language VALUES (5, 'French              ', '2006-02-15 10:02:19');
INSERT INTO public.language VALUES (6, 'German              ', '2006-02-15 10:02:19');


ALTER TABLE public.language ENABLE TRIGGER ALL;








--
-- Name: actor_actor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actor_actor_id_seq', 200, true);


--
-- Name: address_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.address_address_id_seq', 605, true);


--
-- Name: category_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_category_id_seq', 16, true);


--
-- Name: city_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.city_city_id_seq', 600, true);


--
-- Name: country_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.country_country_id_seq', 109, true);


--
-- Name: customer_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_customer_id_seq', 599, true);


--
-- Name: film_film_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.film_film_id_seq', 1000, true);


--
-- Name: inventory_inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventory_inventory_id_seq', 4581, true);


--
-- Name: language_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_language_id_seq', 6, true);


--
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_payment_id_seq', 32098, true);


--
-- Name: rental_rental_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rental_rental_id_seq', 16049, true);


--
-- Name: staff_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_staff_id_seq', 2, true);


--
-- Name: store_store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_store_id_seq', 2, true);


--
-- PostgreSQL database dump complete
--

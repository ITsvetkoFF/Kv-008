--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: activitytype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE activitytype AS ENUM (
    'ADDED',
    'REMOVED',
    'UPDATED'
);


ALTER TYPE activitytype OWNER TO postgres;

--
-- Name: modifier; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE modifier AS ENUM (
    'any',
    'own',
    'none'
);


ALTER TYPE modifier OWNER TO postgres;

--
-- Name: operation; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE operation AS ENUM (
    'get',
    'put',
    'post',
    'delete'
);


ALTER TYPE operation OWNER TO postgres;

--
-- Name: severitytypes; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE severitytypes AS ENUM (
    '1',
    '2',
    '3'
);


ALTER TYPE severitytypes OWNER TO postgres;

--
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE status AS ENUM (
    'USER',
    'ADMINISTRATOR',
    'UNREGISTERED_USER'
);


ALTER TYPE status OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    content text NOT NULL,
    user_id integer NOT NULL,
    problem_id integer NOT NULL
);


ALTER TABLE comments OWNER TO postgres;

--
-- Name: comments_activities; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comments_activities (
    id integer NOT NULL,
    problem_id integer NOT NULL,
    user_id integer NOT NULL,
    commet_id integer NOT NULL,
    date date NOT NULL,
    activity_type activitytype NOT NULL
);


ALTER TABLE comments_activities OWNER TO postgres;

--
-- Name: comments_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comments_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_activities_id_seq OWNER TO postgres;

--
-- Name: comments_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comments_activities_id_seq OWNED BY comments_activities.id;


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE permissions (
    id integer NOT NULL,
    resource_id integer NOT NULL,
    operation operation,
    modifier modifier
);


ALTER TABLE permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE permissions_id_seq OWNED BY permissions.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE photos (
    id integer NOT NULL,
    link character varying(200) NOT NULL,
    status status NOT NULL,
    coment character varying(500) NOT NULL,
    problem_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE photos OWNER TO postgres;

--
-- Name: photos_activities; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE photos_activities (
    id integer NOT NULL,
    photo_id integer NOT NULL,
    problem_id integer NOT NULL,
    user_id integer NOT NULL,
    date date NOT NULL,
    activity_type activitytype NOT NULL
);


ALTER TABLE photos_activities OWNER TO postgres;

--
-- Name: photos_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE photos_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE photos_activities_id_seq OWNER TO postgres;

--
-- Name: photos_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE photos_activities_id_seq OWNED BY photos_activities.id;


--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE photos_id_seq OWNER TO postgres;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: problem_activities; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE problem_activities (
    id integer NOT NULL,
    problem_id integer NOT NULL,
    data json NOT NULL,
    user_id integer NOT NULL,
    date date NOT NULL,
    activity_type activitytype NOT NULL
);


ALTER TABLE problem_activities OWNER TO postgres;

--
-- Name: problem_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE problem_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE problem_activities_id_seq OWNER TO postgres;

--
-- Name: problem_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE problem_activities_id_seq OWNED BY problem_activities.id;


--
-- Name: problem_types; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE problem_types (
    id integer NOT NULL,
    type character varying(100) NOT NULL
);


ALTER TABLE problem_types OWNER TO postgres;

--
-- Name: problem_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE problem_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE problem_types_id_seq OWNER TO postgres;

--
-- Name: problem_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE problem_types_id_seq OWNED BY problem_types.id;


--
-- Name: problems; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE problems (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    content character varying NOT NULL,
    proposal text NOT NULL,
    severity severitytypes NOT NULL,
    votes integer NOT NULL,
    location geometry NOT NULL,
    status status NOT NULL,
    problemtype_id integer NOT NULL,
    region_id integer NOT NULL
);


ALTER TABLE problems OWNER TO postgres;

--
-- Name: problems_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE problems_id_seq OWNER TO postgres;

--
-- Name: problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE problems_id_seq OWNED BY problems.id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE region (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    location geometry NOT NULL
);


ALTER TABLE region OWNER TO postgres;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE region_id_seq OWNER TO postgres;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE region_id_seq OWNED BY region.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE resources (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE resources OWNER TO postgres;

--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE resources_id_seq OWNER TO postgres;

--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE resources_id_seq OWNED BY resources.id;


--
-- Name: roles2permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE roles2permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE roles2permissions OWNER TO postgres;

--
-- Name: solutions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE solutions (
    problem_id integer NOT NULL,
    administrator_id integer NOT NULL,
    problemmaager_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE solutions OWNER TO postgres;

--
-- Name: solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE solutions_id_seq OWNER TO postgres;

--
-- Name: solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE solutions_id_seq OWNED BY solutions.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_roles (
    id integer NOT NULL,
    role character varying(100) NOT NULL
);


ALTER TABLE user_roles OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_roles_id_seq OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    surname character varying(64),
    email character varying(128) NOT NULL,
    password character varying NOT NULL,
    userrole_id integer NOT NULL
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: votes_activities; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE votes_activities (
    id integer NOT NULL,
    problem_id integer NOT NULL,
    user_id integer NOT NULL,
    date date NOT NULL
);


ALTER TABLE votes_activities OWNER TO postgres;

--
-- Name: votes_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE votes_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE votes_activities_id_seq OWNER TO postgres;

--
-- Name: votes_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE votes_activities_id_seq OWNED BY votes_activities.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments_activities ALTER COLUMN id SET DEFAULT nextval('comments_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permissions ALTER COLUMN id SET DEFAULT nextval('permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY photos_activities ALTER COLUMN id SET DEFAULT nextval('photos_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem_activities ALTER COLUMN id SET DEFAULT nextval('problem_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem_types ALTER COLUMN id SET DEFAULT nextval('problem_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problems ALTER COLUMN id SET DEFAULT nextval('problems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY region ALTER COLUMN id SET DEFAULT nextval('region_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY resources ALTER COLUMN id SET DEFAULT nextval('resources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solutions ALTER COLUMN id SET DEFAULT nextval('solutions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY votes_activities ALTER COLUMN id SET DEFAULT nextval('votes_activities_id_seq'::regclass);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comments (id, content, user_id, problem_id) FROM stdin;
\.


--
-- Data for Name: comments_activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY comments_activities (id, problem_id, user_id, commet_id, date, activity_type) FROM stdin;
\.


--
-- Name: comments_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('comments_activities_id_seq', 1, false);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('comments_id_seq', 1, false);


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY permissions (id, resource_id, operation, modifier) FROM stdin;
\.


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('permissions_id_seq', 1, false);


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY photos (id, link, status, coment, problem_id, user_id) FROM stdin;
\.


--
-- Data for Name: photos_activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY photos_activities (id, photo_id, problem_id, user_id, date, activity_type) FROM stdin;
\.


--
-- Name: photos_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('photos_activities_id_seq', 1, false);


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('photos_id_seq', 1, false);


--
-- Data for Name: problem_activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY problem_activities (id, problem_id, data, user_id, date, activity_type) FROM stdin;
\.


--
-- Name: problem_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('problem_activities_id_seq', 1, false);


--
-- Data for Name: problem_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY problem_types (id, type) FROM stdin;
1	проблеми лісів
2	сміттєзвалища
3	незаконна забудова
4	проблеми водойм
5	загрози біорізноманіттю
6	браконьєрство
7	інші проблеми
\.


--
-- Name: problem_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('problem_types_id_seq', 1, false);


--
-- Data for Name: problems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY problems (id, title, content, proposal, severity, votes, location, status, problemtype_id, region_id) FROM stdin;
\.


--
-- Name: problems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('problems_id_seq', 1, false);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY region (id, name, location) FROM stdin;
\.


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('region_id_seq', 1, false);


--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY resources (id, name) FROM stdin;
\.


--
-- Name: resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('resources_id_seq', 1, false);


--
-- Data for Name: roles2permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY roles2permissions (role_id, permission_id) FROM stdin;
\.


--
-- Data for Name: solutions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY solutions (problem_id, administrator_id, problemmaager_id, id) FROM stdin;
\.


--
-- Name: solutions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('solutions_id_seq', 1, false);


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY user_roles (id, role) FROM stdin;
1	administrator
2	user
\.


--
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_roles_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, name, surname, email, password, userrole_id) FROM stdin;
1	admin	\N	admin@.com	dac0d83a682e396b4208fdbd29e2afeb53caeee7	1
2	name1	\N	name1@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	2
3	name2	\N	name2@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	2
4	name3	\N	name3@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	2
5	name4	\N	name4@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	2
6	name5	\N	name5@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	2
7	name6	\N	name6@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	2
8	name7	\N	name7@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	2
9	name8	\N	name8@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	2
10	name9	\N	name9@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	2
11	gfcvhnb,mn.km	kjbj,nm,n	tsvetkoff@igyysjhb.ua	9606b4697e1c27bafc976e9a6b4a69046a71e803	2
12	day1	day1	day1@example.com	4252be270dcfc7f51e5d724b6c93d603f0fb7af0	2
13	test22	test	test@test.test	9606b4697e1c27bafc976e9a6b4a69046a71e803	2
14	123	123	cherg2009@yandex.ru	0350a27997bff20ea2aa56d42ec73cfab22b97d5	2
15	fvygbuhnjuhij	fvygbkjhnjm	vgbjhn@ljdnmd.fd	9606b4697e1c27bafc976e9a6b4a69046a71e803	2
16	fvygbuhnjuhij	fvygbkjhnjm	example1@ab.cd	9606b4697e1c27bafc976e9a6b4a69046a71e803	2
17	1234	1234	ex2@ab.cd	9606b4697e1c27bafc976e9a6b4a69046a71e803	2
18	fvygbuhnjuhij	fvygbkjhnjm	example3@ab.cd	9606b4697e1c27bafc976e9a6b4a69046a71e803	2
20	qw1	qw1	qw1@wq.qw	f1f309e03575374d7dcd3e774591f91eaf82672f	2
21	VV1	fff	map@m.com	7c392eeb8f119fa607c90973d0f37abd76791e8f	2
22	123	123	cherg2009@gmail.com	0350a27997bff20ea2aa56d42ec73cfab22b97d5	2
23	123	123	12345@67	0350a27997bff20ea2aa56d42ec73cfab22b97d5	2
24	2222	2222	test2222	249ec8d56204f971fb5aa16a13bc37f96dde6a5c	2
25	2222	2222	test@2222	0350a27997bff20ea2aa56d42ec73cfab22b97d5	2
26	1111	1111	test@1111	e7c7ceb5d5e8fb848fa6c0d5891c35674053a699	2
27	Vasyl	Vasyl	va@va.com	d312d734859a487da8c99b703f4aa6430b3da148	2
28	Vav	Vav	va1@va.com	d312d734859a487da8c99b703f4aa6430b3da148	2
29	1	1	test@3333	841f08706b7e7fdd05c9ee8dc22c422fd71152e3	2
30	Інна	Лабунська	innalabynskaya@gmail.com	e7c7ceb5d5e8fb848fa6c0d5891c35674053a699	2
31	Mikh	Prsj	ecomap@mail.ru	16f2b64f1b2f133acefb9b53a1a2c7c007424c27	2
32	Inna	Lab	in4ik19@rambler.ru	9606b4697e1c27bafc976e9a6b4a69046a71e803	2
33	Vasyl	Kotsiuba	clic@ukr.net	19806e3a38d29af5b6483ae4a0d2b7f786d76127	2
34	ert@rg.cvb	ert	ert@rg.cvb	3400a601c8e08c5222eca4fd3633bff493157354	2
35	test@t.tt	Test	test@t.tt	2585571fc191c018fe2f17e12f096ba3dc27e145	1
36	Vasua	Kotsiuba	test@t.ttt	2585571fc191c018fe2f17e12f096ba3dc27e145	2
37	Vas	VasVas	vas@vsa.dd	9a90ef5c9ff43e98ba11966ebac48e1f70bd3edd	2
38	ert	ert	ert@r.rr	5b0f249f33c399ab384238fc1a9ed1e511d3c9f5	2
39	vasa	vasaa	vasa@v.vv	ddbad3067effcb32d706787975727692e94b5a16	2
40	tre	tre	tre@tr.rr	85da5c489c4d33cd032927d9fb8517c23226b23f	2
41	xcv	xcv	xcv@cxv.cc	9cdb9a43802597a008141ca14dbfb1729d7ed0ec	2
42	Alexey	Huralnyk	gambit@.com	9606b4697e1c27bafc976e9a6b4a69046a71e803	2
43	volodymyr	kashyrets	vkashyr@softserveinc.com	53851cde1ebf844c781230be20ce4432bb26cc62	2
44	Антон	Коверник	propet90@gmail.com	30eaf48569f9a407329d4be1e31a320a3001031e	2
45	Max	Kulik	maximkulik18@gmail.com	d110c8bb9f4d1fbc00915d1edf2b8ae1b915ebf5	2
46	фыв	фыв	aa@aa.aa	b8ca80558bb349bc4b1676ee5317bc9c37bca01c	2
47	Francis	Smith	flyflyerson2@gmail.com	8a8178b3d32915b9017f619d657e939d76122d7a	2
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 1, false);


--
-- Data for Name: votes_activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY votes_activities (id, problem_id, user_id, date) FROM stdin;
\.


--
-- Name: votes_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('votes_activities_id_seq', 1, false);


SET search_path = topology, pg_catalog;

--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology (id, name, srid, "precision", hasz) FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- Name: comments_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comments_activities
    ADD CONSTRAINT comments_activities_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: photos_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY photos_activities
    ADD CONSTRAINT photos_activities_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: problem_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY problem_activities
    ADD CONSTRAINT problem_activities_pkey PRIMARY KEY (id);


--
-- Name: problem_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY problem_types
    ADD CONSTRAINT problem_types_pkey PRIMARY KEY (id);


--
-- Name: problems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_pkey PRIMARY KEY (id);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: resources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: roles2permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY roles2permissions
    ADD CONSTRAINT roles2permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY votes_activities
    ADD CONSTRAINT votes_activities_pkey PRIMARY KEY (id);


--
-- Name: comments_activities_commet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments_activities
    ADD CONSTRAINT comments_activities_commet_id_fkey FOREIGN KEY (commet_id) REFERENCES comments(id);


--
-- Name: comments_activities_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments_activities
    ADD CONSTRAINT comments_activities_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id);


--
-- Name: comments_activities_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments_activities
    ADD CONSTRAINT comments_activities_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: comments_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id);


--
-- Name: comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: permissions_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resources(id);


--
-- Name: photos_activities_photo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY photos_activities
    ADD CONSTRAINT photos_activities_photo_id_fkey FOREIGN KEY (photo_id) REFERENCES photos(id);


--
-- Name: photos_activities_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY photos_activities
    ADD CONSTRAINT photos_activities_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id);


--
-- Name: photos_activities_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY photos_activities
    ADD CONSTRAINT photos_activities_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: photos_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id);


--
-- Name: photos_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: problem_activities_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem_activities
    ADD CONSTRAINT problem_activities_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id);


--
-- Name: problem_activities_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problem_activities
    ADD CONSTRAINT problem_activities_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: problems_problemtype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_problemtype_id_fkey FOREIGN KEY (problemtype_id) REFERENCES problem_types(id);


--
-- Name: problems_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_region_id_fkey FOREIGN KEY (region_id) REFERENCES region(id);


--
-- Name: roles2permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY roles2permissions
    ADD CONSTRAINT roles2permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES permissions(id);


--
-- Name: roles2permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY roles2permissions
    ADD CONSTRAINT roles2permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES user_roles(id);


--
-- Name: solutions_administrator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_administrator_id_fkey FOREIGN KEY (administrator_id) REFERENCES users(id);


--
-- Name: solutions_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id);


--
-- Name: solutions_problemmaager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_problemmaager_id_fkey FOREIGN KEY (problemmaager_id) REFERENCES users(id);


--
-- Name: users_userrole_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_userrole_id_fkey FOREIGN KEY (userrole_id) REFERENCES user_roles(id);


--
-- Name: votes_activities_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY votes_activities
    ADD CONSTRAINT votes_activities_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id);


--
-- Name: votes_activities_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY votes_activities
    ADD CONSTRAINT votes_activities_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


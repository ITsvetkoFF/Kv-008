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
    'None',
    '1',
    '2',
    '3',
    '4',
    '5'
);


ALTER TYPE severitytypes OWNER TO postgres;

--
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE status AS ENUM (
    'solved',
    'unsolved'
);


ALTER TYPE status OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    content text,
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
    status status,
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
    data json,
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
    title character varying(130) NOT NULL,
    content text,
    proposal text,
    severity severitytypes,
    votes integer,
    location geometry NOT NULL,
    status status,
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
2456	1	null	2	2014-02-18	ADDED
2457	2	null	2	2014-02-19	ADDED
2458	3	null	2	2014-02-26	ADDED
2459	4	null	2	2014-02-26	ADDED
2460	5	null	2	2014-02-27	ADDED
2461	6	null	2	2014-02-18	ADDED
2462	7	null	2	2014-02-27	ADDED
2463	8	null	2	2014-02-27	ADDED
2464	9	null	2	2014-02-27	ADDED
2465	10	null	2	2014-02-27	ADDED
2466	11	null	2	2014-02-27	ADDED
2467	12	null	2	2014-03-02	ADDED
2468	13	null	2	2014-03-02	ADDED
2469	15	null	2	2014-03-03	ADDED
2470	16	null	2	2014-03-03	ADDED
2471	17	null	2	2014-03-03	ADDED
2472	18	null	2	2014-03-03	ADDED
2473	19	null	2	2014-03-03	ADDED
2474	20	null	2	2014-03-06	ADDED
2475	21	null	2	2014-03-06	ADDED
2476	22	null	2	2014-03-11	ADDED
2477	23	null	2	2014-03-13	ADDED
2478	24	null	2	2014-03-13	ADDED
2479	25	null	2	2014-03-14	ADDED
2480	26	null	2	2014-03-17	ADDED
2481	27	null	2	2014-03-17	ADDED
2482	28	null	2	2014-03-17	ADDED
2483	29	null	2	2014-03-17	ADDED
2484	30	null	2	2014-03-17	ADDED
2485	31	null	2	2014-03-18	ADDED
2486	32	null	2	2014-03-18	ADDED
2487	33	null	2	2014-03-18	ADDED
2488	34	null	2	2014-03-18	ADDED
2489	35	null	2	2014-03-18	ADDED
2490	36	null	2	2014-03-18	ADDED
2491	37	null	2	2014-03-18	ADDED
2492	38	null	2	2014-03-18	ADDED
2493	39	null	2	2014-03-18	ADDED
2494	40	null	2	2014-03-18	ADDED
2495	41	null	2	2014-03-18	ADDED
2496	42	null	2	2014-03-18	ADDED
2497	44	null	2	2014-03-19	ADDED
2498	45	null	2	2014-03-19	ADDED
2499	46	null	2	2014-03-20	ADDED
2500	47	null	2	2014-03-22	ADDED
2501	48	null	2	2014-03-25	ADDED
2502	49	null	2	2014-03-25	ADDED
2503	50	null	2	2014-03-25	ADDED
2504	51	null	2	2014-03-25	ADDED
2505	52	null	2	2014-03-25	ADDED
2506	53	null	2	2014-03-25	ADDED
2507	54	null	2	2014-03-26	ADDED
2508	55	null	2	2014-03-26	ADDED
2509	57	null	2	2014-03-26	ADDED
2510	58	null	2	2014-03-26	ADDED
2511	59	null	2	2014-03-26	ADDED
2512	60	null	2	2014-03-26	ADDED
2513	61	null	2	2014-03-26	ADDED
2514	62	null	2	2014-03-26	ADDED
2515	63	null	2	2014-03-26	ADDED
2516	64	null	2	2014-03-26	ADDED
2517	65	null	2	2014-03-26	ADDED
2518	66	null	2	2014-03-26	ADDED
2519	67	null	2	2014-03-26	ADDED
2520	68	null	2	2014-03-26	ADDED
2521	69	null	2	2014-03-26	ADDED
2522	70	null	2	2014-03-26	ADDED
2523	71	null	2	2014-03-26	ADDED
2524	72	null	2	2014-03-26	ADDED
2525	73	null	2	2014-03-26	ADDED
2526	74	null	2	2014-03-26	ADDED
2527	75	null	2	2014-03-26	ADDED
2528	76	null	2	2014-03-26	ADDED
2529	78	null	2	2014-03-26	ADDED
2530	79	null	2	2014-03-26	ADDED
2531	80	null	2	2014-03-26	ADDED
2532	81	null	2	2014-03-26	ADDED
2533	82	null	2	2014-03-26	ADDED
2534	83	null	2	2014-03-26	ADDED
2535	84	null	2	2014-03-26	ADDED
2536	85	null	2	2014-03-26	ADDED
2537	86	null	2	2014-03-26	ADDED
2538	87	null	2	2014-03-26	ADDED
2539	89	null	2	2014-03-26	ADDED
2540	90	null	2	2014-03-26	ADDED
2541	91	null	2	2014-03-26	ADDED
2542	92	null	2	2014-03-27	ADDED
2543	93	null	2	2014-03-27	ADDED
2544	94	null	2	2014-03-27	ADDED
2545	95	null	2	2014-03-27	ADDED
2546	96	null	2	2014-03-27	ADDED
2547	97	null	2	2014-03-27	ADDED
2548	98	null	2	2014-03-27	ADDED
2549	99	null	2	2014-03-27	ADDED
2550	100	null	2	2014-03-27	ADDED
2551	101	null	2	2014-03-27	ADDED
2552	102	null	2	2014-03-27	ADDED
2553	103	null	2	2014-03-27	ADDED
2554	104	null	2	2014-03-27	ADDED
2555	105	null	2	2014-03-27	ADDED
2556	106	null	2	2014-03-27	ADDED
2557	107	null	2	2014-03-27	ADDED
2558	108	null	2	2014-03-27	ADDED
2559	109	null	2	2014-03-27	ADDED
2560	110	null	2	2014-03-27	ADDED
2561	111	null	2	2014-03-27	ADDED
2562	112	null	2	2014-03-27	ADDED
2563	113	null	2	2014-03-27	ADDED
2564	114	null	2	2014-03-27	ADDED
2565	115	null	2	2014-03-27	ADDED
2566	116	null	2	2014-03-27	ADDED
2567	118	null	2	2014-03-27	ADDED
2568	119	null	2	2014-03-27	ADDED
2569	120	null	2	2014-03-27	ADDED
2570	121	null	2	2014-03-27	ADDED
2571	122	null	2	2014-03-27	ADDED
2572	123	null	2	2014-03-27	ADDED
2573	124	null	2	2014-03-27	ADDED
2574	125	null	2	2014-03-27	ADDED
2575	126	null	2	2014-03-27	ADDED
2576	127	null	2	2014-03-27	ADDED
2577	128	null	2	2014-03-27	ADDED
2578	129	null	2	2014-03-27	ADDED
2579	130	null	2	2014-03-27	ADDED
2580	131	null	2	2014-03-27	ADDED
2581	132	null	2	2014-03-27	ADDED
2582	133	null	2	2014-03-27	ADDED
2583	134	null	2	2014-03-27	ADDED
2584	135	null	2	2014-03-27	ADDED
2585	136	null	2	2014-03-27	ADDED
2586	137	null	2	2014-03-27	ADDED
2587	138	null	2	2014-03-27	ADDED
2588	139	null	2	2014-03-27	ADDED
2589	140	null	2	2014-03-27	ADDED
2590	141	null	2	2014-03-27	ADDED
2591	142	null	2	2014-03-28	ADDED
2592	143	null	2	2014-03-28	ADDED
2593	144	null	2	2014-03-28	ADDED
2594	145	null	2	2014-03-28	ADDED
2595	146	null	2	2014-03-28	ADDED
2596	147	null	2	2014-03-28	ADDED
2597	148	null	2	2014-03-28	ADDED
2598	149	null	2	2014-03-28	ADDED
2599	150	null	2	2014-03-28	ADDED
2600	151	null	2	2014-03-28	ADDED
2601	152	null	2	2014-03-29	ADDED
2602	153	null	2	2014-03-29	ADDED
2603	154	null	2	2014-03-29	ADDED
2604	155	null	2	2014-03-29	ADDED
2605	156	null	2	2014-03-29	ADDED
2606	157	null	2	2014-03-29	ADDED
2607	158	null	2	2014-03-29	ADDED
2608	159	null	2	2014-03-29	ADDED
2609	160	null	2	2014-03-29	ADDED
2610	161	null	2	2014-03-30	ADDED
2611	162	null	2	2014-03-30	ADDED
2612	163	null	2	2014-03-30	ADDED
2613	164	null	2	2014-04-02	ADDED
2614	165	null	2	2014-04-02	ADDED
2615	166	null	2	2014-04-06	ADDED
2616	167	null	2	2014-04-06	ADDED
2617	168	null	2	2014-04-08	ADDED
2618	169	null	2	2014-04-09	ADDED
2619	170	null	2	2014-04-09	ADDED
2620	171	null	2	2014-04-09	ADDED
2621	172	null	2	2014-04-11	ADDED
2622	173	null	2	2014-04-12	ADDED
2623	174	null	2	2014-04-14	ADDED
2624	176	null	2	2014-04-24	ADDED
2625	177	null	2	2014-04-24	ADDED
2626	178	null	2	2014-04-25	ADDED
2627	179	null	2	2014-05-06	ADDED
2628	180	null	2	2014-05-14	ADDED
2629	181	null	2	2014-05-16	ADDED
2630	183	null	2	2014-05-17	ADDED
2631	184	null	2	2014-05-18	ADDED
2632	185	null	2	2014-05-21	ADDED
2633	186	null	2	2014-05-24	ADDED
2634	187	null	2	2014-05-25	ADDED
2635	188	null	2	2014-05-26	ADDED
2636	2	null	1	2015-01-30	ADDED
2637	3	null	1	2015-01-30	ADDED
2638	3	null	1	2015-01-30	ADDED
2639	4	null	1	2015-01-30	ADDED
2640	214	null	13	2015-02-03	ADDED
2641	217	null	2	2015-02-06	ADDED
2642	218	null	2	2015-02-06	ADDED
2643	219	null	2	2015-02-06	ADDED
2644	220	null	1	2015-02-06	ADDED
2645	221	null	1	2015-02-06	ADDED
2646	222	null	1	2015-02-06	ADDED
2647	223	null	1	2015-02-06	ADDED
2648	224	null	1	2015-02-06	ADDED
2649	225	null	1	2015-02-06	ADDED
2650	226	null	1	2015-02-06	ADDED
2651	227	null	1	2015-02-06	ADDED
2652	89	null	1	2015-02-16	ADDED
2653	185	null	1	2015-02-16	ADDED
2654	99	null	1	2015-02-17	ADDED
2655	99	null	1	2015-02-17	ADDED
2656	140	null	1	2015-02-17	ADDED
2657	140	null	1	2015-02-17	ADDED
2658	72	null	1	2015-02-17	ADDED
2659	72	null	1	2015-02-17	ADDED
2660	72	null	1	2015-02-17	ADDED
2661	71	null	1	2015-02-17	ADDED
2662	71	null	1	2015-02-17	ADDED
2663	71	null	1	2015-02-17	ADDED
2664	74	null	1	2015-02-17	ADDED
2665	74	null	1	2015-02-17	ADDED
2666	74	null	1	2015-02-17	ADDED
2667	78	null	1	2015-02-17	ADDED
2668	78	null	1	2015-02-17	ADDED
2669	78	null	1	2015-02-17	ADDED
2670	165	null	1	2015-02-18	ADDED
2671	166	null	1	2015-02-18	ADDED
2672	167	null	1	2015-02-18	ADDED
2673	22	null	1	2015-02-18	ADDED
2674	177	null	1	2015-02-18	ADDED
2675	156	null	1	2015-02-20	ADDED
2676	236	null	2	2015-02-23	ADDED
2677	239	null	1	2015-02-24	ADDED
2678	140	null	1	2015-03-02	ADDED
2679	52	null	32	2015-03-02	ADDED
2680	87	null	32	2015-03-02	ADDED
2681	87	null	32	2015-03-02	ADDED
2682	87	null	32	2015-03-02	ADDED
2683	87	null	32	2015-03-02	ADDED
2684	87	null	32	2015-03-02	ADDED
2685	87	null	32	2015-03-02	ADDED
2686	87	null	32	2015-03-02	ADDED
2687	87	null	32	2015-03-02	ADDED
2688	132	null	32	2015-03-02	ADDED
2689	132	null	32	2015-03-02	ADDED
2690	52	null	32	2015-03-04	ADDED
2691	52	null	32	2015-03-04	ADDED
2692	52	null	32	2015-03-04	ADDED
2693	52	null	32	2015-03-04	ADDED
2694	132	null	32	2015-03-04	ADDED
2695	132	null	32	2015-03-04	ADDED
2696	183	null	32	2015-03-04	ADDED
2697	183	null	32	2015-03-04	ADDED
2698	142	null	32	2015-03-04	ADDED
2699	142	null	32	2015-03-04	ADDED
2700	98	null	32	2015-03-05	ADDED
2701	98	null	32	2015-03-05	ADDED
2702	98	null	32	2015-03-05	ADDED
2703	87	null	32	2015-03-05	ADDED
2704	87	null	32	2015-03-05	ADDED
2705	87	null	32	2015-03-05	ADDED
2706	98	null	32	2015-03-05	ADDED
2707	242	null	1	2015-03-05	ADDED
2708	242	null	1	2015-03-05	ADDED
2709	243	null	1	2015-03-05	ADDED
2710	87	null	32	2015-03-05	ADDED
2711	52	null	1	2015-03-05	ADDED
2712	87	null	32	2015-03-05	ADDED
2713	157	null	32	2015-03-05	ADDED
2714	78	null	32	2015-03-05	ADDED
2715	183	null	32	2015-03-05	ADDED
2716	98	null	32	2015-03-05	ADDED
2717	183	null	32	2015-03-05	ADDED
2718	87	null	32	2015-03-05	ADDED
2719	52	null	1	2015-03-05	ADDED
2720	52	null	1	2015-03-05	ADDED
2721	52	null	1	2015-03-05	ADDED
2722	103	null	33	2015-03-05	ADDED
2723	74	null	32	2015-03-10	ADDED
2724	21	null	33	2015-03-10	ADDED
2725	21	null	33	2015-03-10	ADDED
2726	21	null	33	2015-03-10	ADDED
2727	21	null	33	2015-03-10	ADDED
2728	21	null	33	2015-03-10	ADDED
2729	10	null	33	2015-03-10	ADDED
2730	10	null	33	2015-03-10	ADDED
2731	10	null	33	2015-03-10	ADDED
2732	10	null	33	2015-03-10	ADDED
2733	10	null	33	2015-03-10	ADDED
2734	21	null	33	2015-03-10	ADDED
2735	21	null	33	2015-03-10	ADDED
2736	21	null	33	2015-03-10	ADDED
2737	21	null	33	2015-03-10	ADDED
2738	21	null	33	2015-03-10	ADDED
2739	21	null	33	2015-03-10	ADDED
2740	21	null	33	2015-03-10	ADDED
2741	21	null	33	2015-03-10	ADDED
2742	156	null	33	2015-03-10	ADDED
2743	183	null	33	2015-03-10	ADDED
2744	183	null	33	2015-03-10	ADDED
2745	183	null	33	2015-03-10	ADDED
2746	183	null	33	2015-03-10	ADDED
2747	183	null	32	2015-03-10	ADDED
2748	183	null	32	2015-03-10	ADDED
2749	242	null	32	2015-03-10	ADDED
2750	242	null	32	2015-03-10	ADDED
2751	176	null	1	2015-03-10	ADDED
2752	8	null	1	2015-03-10	ADDED
2753	8	null	1	2015-03-10	ADDED
2754	183	null	32	2015-03-10	ADDED
2755	152	null	1	2015-03-10	ADDED
2756	250	null	1	2015-03-10	ADDED
2757	251	null	1	2015-03-10	ADDED
2758	242	null	1	2015-03-10	ADDED
2759	242	null	1	2015-03-10	ADDED
2760	253	null	1	2015-03-10	ADDED
2761	254	null	42	2015-03-11	ADDED
2762	255	null	33	2015-03-11	ADDED
2763	255	null	1	2015-03-11	ADDED
2764	255	null	1	2015-03-11	ADDED
2765	255	null	1	2015-03-11	ADDED
2766	255	null	1	2015-03-11	ADDED
2767	54	null	1	2015-03-11	ADDED
2768	257	null	1	2015-03-11	ADDED
2769	96	null	33	2015-03-11	ADDED
2770	258	null	1	2015-03-11	ADDED
2771	259	null	32	2015-03-12	ADDED
2772	259	null	32	2015-03-12	ADDED
2773	260	null	32	2015-03-12	ADDED
2774	260	null	1	2015-03-12	ADDED
2775	254	null	1	2015-03-12	ADDED
2776	255	null	1	2015-03-13	ADDED
2777	255	null	1	2015-03-13	ADDED
2778	255	null	1	2015-03-13	ADDED
2779	255	null	1	2015-03-13	ADDED
2780	98	null	35	2015-03-13	ADDED
2781	98	null	35	2015-03-13	ADDED
2782	98	null	35	2015-03-13	ADDED
2783	261	null	1	2015-03-13	ADDED
2784	262	null	35	2015-03-13	ADDED
2785	263	null	32	2015-03-13	ADDED
2786	263	null	32	2015-03-13	ADDED
2787	264	null	1	2015-03-13	ADDED
2788	265	null	1	2015-03-13	ADDED
2789	266	null	1	2015-03-13	ADDED
2790	267	null	35	2015-03-13	ADDED
2791	268	null	33	2015-03-13	ADDED
2792	129	null	33	2015-03-13	ADDED
2793	129	null	33	2015-03-13	ADDED
2794	129	null	33	2015-03-13	ADDED
2795	129	null	33	2015-03-13	ADDED
2796	129	null	33	2015-03-13	ADDED
2797	98	null	35	2015-03-13	ADDED
2798	129	null	33	2015-03-13	ADDED
2799	41	null	35	2015-03-13	ADDED
2800	41	null	35	2015-03-13	ADDED
2801	41	null	35	2015-03-13	ADDED
2802	41	null	35	2015-03-13	ADDED
2803	41	null	35	2015-03-13	ADDED
2804	41	null	35	2015-03-13	ADDED
2805	41	null	35	2015-03-13	ADDED
2806	41	null	35	2015-03-13	ADDED
2807	271	null	35	2015-03-13	ADDED
2808	73	null	1	2015-03-16	ADDED
2809	242	null	1	2015-03-16	ADDED
2810	242	null	1	2015-03-16	ADDED
2811	264	null	1	2015-03-17	ADDED
2812	257	null	35	2015-03-27	ADDED
2813	257	null	35	2015-03-27	ADDED
2814	261	null	44	2015-03-27	ADDED
\.


--
-- Name: problem_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('problem_activities_id_seq', 2814, true);


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
1	Відновлення острова Малий Татару	Біля 50 років тому острів був віддамбований. Після осушення о. Татару став придатним для розвитку сільського та лісового господарства. Проте віддамбування острова принесло велику шкоду місцевій екосистемі: дамби, перегородивши шлях воді Дунаю, обмежили нерест риби, якість води у внутрішніх озерах знизилася без припливу свіжої дунайської води зі щорічними паводками, рослинність без природного затоплення та надходження біогенів та поживних речовин почала деградувати та перероджуватися. 	Для вирішення цих проблем представниками Ізмаїльського лісового господарства, місцевих влад та Всесвітнього фонду природи 30 жовтня 2003 року була снесена частина дамб, що оточували острів. Шлях для дунайської води був відкритий та навесні 2004 року острів пережив перший паводок за довгі 50 років. За минулі 10 років острів майже повернувся до природного стану, екосистема острова процвітає. Проект на острові М. Татару є моделлю відновлення плавнів у дельті Дунаю.	3	16	0101000000E8154F3DD2AC4640E751F17F47003D40	solved	4	999
2	Китайський мега-порт	Он может стать петлей для Крыма, он - смертный приговор для нашего любимого полуострова.	Пожалуйста, поддержите петицию о недопустимости строительства китайского мега-порта в Крыму:\nhttps://secure.avaaz.org/ru/petition/Prezidentu_Ukrai..nu_otmenit_dogovorennosti_o_stroitelstve_kitayskogo_megaporta/ 	3	26	0101000000D4D688601C9046403735D07CCECD4040	unsolved	4	999
3	Сабарівський ліс	В місті Вінниця в мікрорайоні Сабарів ліс та берег Південного Бугу просто завалений сміттям!!! І з кожним роком все більше і більше!!!	Організувати акцію по прибиранню цієї території.	3	21	010100000012876C205D984840F3AB394030733C40	unsolved	1	999
4	Спасите Древний могучий Днепр!	Река Днепр, некогда судоходная, в связи со строительством плотин, интенсивным технологическим использованием и изменениями климата, убийственно цветет в летние месяцы и убивает в себе все живое, перестает быть источником питьевой воды и колыбелью Приднепровья.	Государственная программа, выделение денег из госбюджета, чистка и углубление дна реки.	3	23	0101000000A298BC01663E484092B1DAFCBF884140	unsolved	4	999
5	Загрязнение Днепра	В городе Берислав нет очистных сооружений.		3	13	0101000000265305A3926A47406D0377A04EB54040	unsolved	4	999
6	Знищення гніздівель ластівок, Чубинське, Бориспільський район	Бориспільський район, Чубинське (колишній хутір Чубинських. Автора слів гімну України), Яблунева 6а. Зруйновані гнізда ластівки міської. За підрахунками більше  50 гнізд. Зроблено за наказом власника розважального комплексу "Чубинське". За його словами, ластівки гадять і якщо комусь не подобається, то можуть забрати всі ці гнізда додому. Залишки гнізд, між іншим, в той час вже валялись під дахом комплексу. А крановщики, які виконували наказ і, як зрозуміло, своєї думки не мали, тикали пальцями у власника: "Нічого не знаємо... наша хата з краю"	Інформацію було розповсюджено серед ЗМІ, яке активно відреагувало. Приклади новин можна знайти http://www.socportal.info/news/direktor-magazinu-vbiv-200-ptashenyat-last, http://chask.net/?p=16110, http://weather.tsn.ua/ukrayina/na-kiyivschini-budivelniki-znischili-bilshe-50-lastivchinih-gnizd-zaradi-maybutnogo-trc-298037.html, http://podrobnosti.ua/podrobnosti/2013/06/14/911232.html. На власника було подано звернення до Міністерства внутрішніх справ України з проханням порушити відповідну кримінальну справу відносно власника комплексу.  Справу "зам\\'яли", але власник ТРЦ знову гніздівлі вже не руйнував.	3	27	0101000000C443183F8D31494072FDBB3E73DA3E40	solved	5	999
7	Лиман	Нужно залить морскую воду в Куяльницкий лиман!Давайте как то соберёмся!Пока решат как провести трубу,то он уже пересохнет.А этот лиман по хим.составу как мёртвое море!У нас в стране всё так бездарно делается это ужас!!!	Предложите что то...	3	46	0101000000BDC804FC1A494740E17EC00303C03E40	unsolved	4	999
8	забор	забор стоит за красной линией прямо на тротуаре, человек незаконно присвоил себе общую территорию в свою собственность.	знести	3	21	0101000000AB9509BFD43949409DD7D825AAAB3E40	unsolved	3	999
9	Необхідність збереження пам’ятки природи місцевого значення «Тунель кохання», с. Клевань, Рівненський район Рівненської області.	Пам\\'ятка природи являє собою ботанічний феномен – зелений тунель у лісовому масиві, утворений заростями дерев та кущів, що сплелися між собою та утворили тунель точної арочної форми. Розташований на 4-кілометровому відрізку залізничної колії. Є місцевою туристичною принадою. Існують проблеми із прибиранням навколишньої території. На початку листопада 2013 року надійшла інформація про вирубку дерев навколо «Тунелю кохання» у шаховому порядку. 	Місцеві жителі періодично проводять толоки, прибирають тунель, проте існує проблема із зникненням обладнаних урн для сміття. Мешканці звернулися до мас-медіа, таких як Zik, Українська правда, 1+1. На запит журналістів заступник Рівненської ОДА О. Губанов пояснив ситуацію профілактичними роботами на залізничній гілці та впорядкуванням лісу. Кілька дерев дійсно були зрубані, однак так і залишилися лежати біля колій.   Проте після того, як подія набула розголосу в ЗМІ, вирубка дерев припинилася. Місцеві жителі досить ініціативні щодо захисту ботанічної пам’ятки, позаяк її відвідує багато туристів, в тому числі іноземних, що є джерелом прибутку. \n1.Туризм може стати джерелом фінансування робіт щодо догляду за лісом (добровільні пожертви, невеличкий збір).\n2. Можна запропонувати також надання тунелю статусу об’єкту культурної спадщини (ландшафтного, природно-антропогенного) із застосуванням відповідного режиму охорони. \n	3	22	0101000000F981AB3C816049401C2785798F033A40	unsolved	1	999
10	Необхідність створення заказника для дельфінів біля мису Айя, Сарич та узбережжя Балаклави. 	Щороку сюди припливає на зимовку велика кількість азовок, білобочок та афалін, оскільки там досить спокійно та є хороша кормова база, що дозволяє дельфінам збільшувати поголів’я та комфортно зимувати. Наразі дельфіни потерпають від риболовецьких сітей, заковтують пластикові пляшки та інше побутове сміття. 	Потрібне надання цим водам статусу охоронної території, де буде заборонена господарська діяльність. \nПротягом кількох років на мисі Айя функціонував екологічний пост, який не пускав туди туристів. Збільшилася кількість водоплавних птахів і комах, природа почала оживати. Рада громадських екологічних організацій Севастополя звертається до Мінекології із клопотанням щодо створення окремого морського заказника. Можливе також розширення території існуючого морського заказника - прибережного аквального комплексу біля мису Айя. \n	3	25	0101000000FB78E8BB5B3D4640E6965643E2CC4040	unsolved	5	999
11	Місцевість дуже забруднена, місто потерпає від сміття			3	9	0101000000F790F0BDBFD34740DD274701A24C4140	unsolved	2	999
12	с.Пожарки	Стехійні сміттєзвалища біля і в лісі.	Поставити в с.Пожарки контейнери для роздільного збору сміття.	3	5	01010000005B22179CC1F94840BBB88D06F05A3E40	unsolved	2	999
13	Сміттєзвалища 	Сміттєзвалища в лісі.	Поставити в с.Пожарки контейнери для роздільного збору сміття.	3	12	010100000041B96DDFA37C49400BED9C66813A3940	unsolved	2	999
15	Гніванський ліс	Гніванське ліснитство в районі ЖБК просто потопає у смітті!!!	Організувати акцію по прибиранню цієї території	3	6	01010000000118CFA0A18B484032FFE89B34593C40	unsolved	1	999
16	Загрози біорізноманіттю	У Чернігівській обл., ТОВ «Земля і воля», а також багато інших с/господарств по всій Україні використовують гмо-культури (з паралельним використанням агресивної с/г хімії), давно вже не в цілях "проби". 	Заборонити в Україні діяльність Монсанто, Сингента та інших компаній, що використовують ГМО-технології. \nЗаборонити використання ГМ-насіння і технологій у великому с \\ г та приватному фермерстві. \nЗробити Україну "зоною, вільною від ГМО". \nРозробку на впровадження програми провести у 2014р.\n	3	3	0101000000702711E15F5C4940E8BD310400773F40	unsolved	5	999
17	Загрози біорізноманіттю	У Чернігівській обл., ТОВ «Земля і воля», а також багато інших с/господарств по всій Україні використовують гмо-культури (з паралельним використанням агресивної с/г хімії), давно вже не в цілях "проби". 	Заборонити в Україні діяльність Монсанто, Сингента та інших компаній, що використовують ГМО-технології. \nЗаборонити використання ГМ-насіння і технологій у великому с \\ г та приватному фермерстві. \nЗробити Україну "зоною, вільною від ГМО". \nРозробку на впровадження програми провести у 2014р.	3	3	010100000085ED27637C5C494007D0EFFB377B3F40	unsolved	5	999
18	ГМО	У Чернігівській обл., ТОВ «Земля і воля», а також багато інших с/господарств по всій Україні використовують гмо-культури (з паралельним використанням агресивної с/г хімії), давно вже не в цілях "проби". 	Заборонити в Україні діяльність Монсанто, Сингента та інших компаній, що використовують ГМО-технології. \nЗаборонити використання ГМ-насіння і технологій у великому с \\ г та приватному фермерстві. \nЗробити Україну "зоною, вільною від ГМО". \nРозробку на впровадження програми провести у 2014р.	3	3	01010000008D261763605D4940289EB305847A3F40	unsolved	5	999
19	Сміттєзвалище на Гмирі 6	Велика територія бруду, пластику та іншого сміття. Також по всьому мікрорайону собачі віпорожнення.	Прибрати. Щось вирішити з незайманою територією: чи паркінг зробити (автомобілів тьма тьмуща), чи сквер, чи спортивний майданчик повноцінний (в мікрорайоні тільки дитячі майданчики), чи баскетбольне поле.	3	34	0101000000C8D0B1834A3249407E54C37E4FA03E40	unsolved	2	999
20	Сміттєзвалище	Несанкціоноване та хаотичне викидання сміття в лісосмугах та полях, що псує загальний вигляд та шкодить довкіллю. Велика кількість будматеріалів та різного пластикового сміття.	Організувати прибирання, повідомлення особам відповідальним за екологічний стан в місцевості задля подальшого недопускання викидання там сміття!	3	2	0101000000E7FD7F9C3025494007EBFF1CE6CB3E40	unsolved	2	999
21	Загроза втрати біорізноманіття акваторії навколо Тарханкутського півострова	Незаконні методи вилову риби, вилучення з природного середовища малих китоподібних, надмірне рекреаційне навантаження	Акваторії потрібно включити до складу національного природного парку "Чарівна гавань"\n	3	18	0101000000566133C005B54640A35C1ABFF03E4040	unsolved	5	999
22	НЕЗАКОНЕ СМІТТЄЗВАЛИЩЕ ОРГАНІЗОВАНЕ СІЛЬСЬКОЮ РАДОЮ	В селі Богданнівка, сільський голова організував майже в центрі села незаконне сміттєзвалище	Привернути увагу до данної проблеми жителів села і знайти рішення даної проблеми.	3	13	010100000026A8E15B584F49408B51D7DAFBE83E40	unsolved	2	999
23	мусор в Одессе	отсутствие сортировки и переработки мусора. отсутствие контроля в зоне туризма за засорением побережья и зеленых зон	1. Организация разделения бытового мусора\n2. строительство перерабатывающего завода на территории области\n3. создание экологической полиции и жесткий контроль за соблюдением чистоты в городе и зонах туризма\n4. усиление функциональной системы системы штрафов\n5. пропаганда через СМИ и школы правильного отношения к среде обитания\nwww.snd.org.ua	3	14	01010000009626A5A0DB3D4740454772F90FD13E40	unsolved	2	999
24	загрязнение воздуха	высокий уровень со2 в воздухе. являясь курортной зоной, Одесса имеет высокий уровень загрязнения воздуха. Ходить пешком по городу трудно из-за количества выбросов автотранспорта	повысить налоги на старые автомобили, автомобили с большим расходом топлива. Проводить жесткую диагностику газоанализатором согласно госту. Контролировать качество топлива. Внедрять экологичные технологии.	3	15	010100000032207BBDFB3947404149810530ED3E40	unsolved	7	999
25	Викид сажі та зниження ставків пром. викидами	Узинський цукровий комбінат забруднює місто сажею з труби заводу, а також знищив життя в кількох ставказ через стоки. Крім цього присутній постійний неприємний запах через викиди в ставки барди.	Зобов\\'язати підприємство негайно припинити роботу до встановлення очистного обладнання та очистки ставків.	3	8	01010000001327F73B14E9484078B81D1A166F3E40	unsolved	1	999
26	Проблема повiтря	Загрязнен воздух, несмотря на всевозможные фильтры на производстве	Контроль фильтров	3	43	0101000000BD1C76DF31E64740F92F1004C8AE4040	unsolved	7	999
27	Пал травы	Пал травы	Запретить пал травы	3	2	0101000000253B3602F10C4D409032E202D0983E40	unsolved	7	999
28	Забруднення ґрунтових вод	Через активну меліорацію і використання хімдобрив в радянські часи і зараз, є загроза забруднення ґрунтових вод і підтоплення (Херснська область)	Належний контроль	3	7	0101000000EA211ADD416A474032569BFF57794040	unsolved	7	999
29	стихійні сміттєзвалища	вздовж р.Уж стихійні сміттєзвалища, оскільки в даній місцевості немає спеціально відведеного місця. 	побудова сміттєпереробного заводу	3	7	0101000000A3AD4A22FB5E4840D09D60FF75823640	unsolved	2	999
30	засорение реки	Житомир-Новогуйвинское.Река Гуйва. При расчистке леса(пилили деревья),ветки и стволы сбрасывали в реку.  Результат подобной деятельности:-заторы,порча воды гниющим деревом, появление большого количества сине-зелёных водорослей,нехватка кислорода рыбам. Фото могу предоставить. Кроме того,по словам проживающей в том районе сестры,идёт браконьерский вылов раков.	Найти и наказать службы,которые виновны в болезни реки. Обязать их расчистить речку. Не знаю,есть-ли там лесничество,но если да,то поднять вопрос о халатном отношении лесника к своим обязанностям 	3	7	01010000009A7D1EA33C114940C7D9740470AF3C40	unsolved	4	999
31	Загальна системна проблема із сміттям	За сміття переплачується не менш ніж три рази. Перший сплачує величезні внески за використання неекологічного та всякого іншого упакування. Другі гроші, не менш значимі величиною, це сплати тих хто виробляє різні упакування. Третя сплата це покупець, ПРИМУШЕНИЙ сплатити за товар в упакуванні і без прав вибору. Четверта сплата це просто абсурдне примушення сплачувати за вивіз сміття, за яке вже три тази сплачено. Після візиту до магазину третина пакету становить пакування -- ОДРАЗУ як дотранспортував додому. Ціна мішечка сміття перевищує ціну деяких продуктів харчування!. Де ж ті гроші? Де переробка?  Система аж ніяк не заохочує навіть до встановлених смітників сміття переміщувати. Не всі живуть у багатоквартирних будівлях. Організація і побори для решти не просто неприйнятні, а абсурдні.\nДякую за увагу.	Встановлення організованих смітників. На розподілене сортоване збирання. Системні регулярні і сезонні заходи по збору органічних (гнилі та биті яблука, наприклад) та таких що потребують спалювання (листя та гілля) відходів та переміщення їх до організованих місць переробки, з подальшою вбудовою в екологічно корисні та прийнятні ланки. Хто живе у межах будинків з ділянкою (села, дачі, міські ітд) знає добре НАСКІЛЬКИ страждає саме та ділянка землі від тієї кількості сміття що просто не встигає саме по собі переробитися лишаючись локально. \nМаксимальне сприяння побудові переробних сміттє-заводів!!! з нормальними технологіями та вихідними продуктами.Відкрите рекламування усієї системи оббігу та оплати сміття замість пива, горілки та цигарок.\nСпасибі.	3	18	01010000002C7DE882FA36494092B1DAFCBF8A3E40	unsolved	2	999
32	Сміттєзвалище біля лісу	Між селами Грушів та Ходорів декілька років тому утворилося незаконне сміттєзвалище у зоні Ржищівського лісгоспу	Прибрати територію і не допускати її засмічення	3	11	01010000003D9B559FABF3484079B130444E3B3F40	unsolved	2	999
33	Сміттєзвалища на "Коса на Победе"	Це місце є єдиним можливим "виходом на природу" для багатьох мешканців жилмасиву Перемога, чудове місце для тренування спортсменів тощо. Але, на жаль, немає служб, що доглядають цю територію, або вони є, але абсолютно не виконують свої функції. Централізованних смитників також недостатньо. Через це  всім відома Коса перетворилась на сміттєзвалище і кожного для ця проблема лише збільшується. 	Встановлення смитників, проведення суботників, контроль роботи відповідних служб міськими головами.	3	14	0101000000876F61DD783548401BF33AE290894140	unsolved	2	999
34	сплошная вырубка леса 	сплошная вырубка леса  и вывоз на протяжении 3 последних лет	остановка сплошной вырубки остатков леса и недопущение в будущем	3	17	0101000000BB7F2C4487144940EAAF575870FB3D40	unsolved	1	999
35	чечены	самая основная проблема планеты это чечены!	всех в печь	3	5	01010000007993DFA293A745401172DEFFC7D54640	unsolved	7	999
36	Сміттєзвалище. Забруднення...	Недобудований об\\'їзд завалюють сміттям. Згодом це стане сміттєзвалище неймовірних розмірів.	Очиститит територію, перекрити всі в\\'їзди до території.	3	15	010100000093E4B9BE0F334940F2D3B837BF693E40	unsolved	2	999
37	Постійна зміна клімату, вирубка лісів, смітник	На моїх очах вирубають ліс. По дорозі на роботу я бачу навколо себе смітник	Поставити знаки штрафу, за смітник у данному місці. шробити "суботник"!!!!хай люди прибирають там, де самі і живуть!!!!	3	8	0101000000C2340C1F11154940E272BC02D15B3E40	unsolved	2	999
38	Хуже Чернобыля	У нас проблемы во всём.Особенно экология	Закрыть все заводы ,в которых нет очистных сооружений.Убрать могильник	3	12	01010000009CF9D51C20424840ACC5A700184F4140	unsolved	7	999
39	Стройка	Стоят дома, вырубают леса, гадят) 	Беречь природу!	3	12	0101000000B610E4A084454940B8CA13083B3D3E40	unsolved	3	999
40	Смітник біля будинку	Смітник біля будинку і на всій вилиці!!!	Влаштувати день прибирання	3	11	0101000000770FD07D394D4840CFF8BEB8544D3640	unsolved	2	999
41	Незаконный вывоз песка	Незаконно выкачивает песок земснаряд, а это грозит тем, что весь мост может рухнуть. 	Запретить и наказать.	3	18	01010000001FDB32E02C334940CAA31B6151993E40	unsolved	4	999
42	Загрязнение родникового водоёма	В селе Синяк, Вышгородского района, Киевской области в родниковое озеро сбрасывают отходы производства предприятия "Альянс" и канализацию жилых домов. Вода в колодцах уже дурно пахнет.	Запретиь предприятию сбрасывать отходы в озеро. Для сельской канализации построить очистные сооружения.	3	6	0101000000F5A276BF0A5649401C5DA5BBEB443E40	unsolved	4	999
44	Брудно	На вулицях валяються пакети , пусті пляшки , сміття...	Встановити якомога більше мусорних бачків	3	11	0101000000ACADD85F76CB484004E5B67D8F464140	unsolved	2	999
45	Забруднені водойоми та береги річок	Береги Дніпра, Кагамлика та інших водоймищ, забрудені різним сміттям. З берегів зливають різноманітні хімічні сполуки у водоймища, через що гине риба та влітку водоймища вкриваються зеленими воростями. Якщо б це були винні підприємства, то було б легше попередити цію проблему, але винуватцями фізичні особи.	Ввести екологічний патруль, який буде контролювати забруднення та виявляти порушників. Ввести жорсткі санкції за забруденння та заохочення за очищення території. \n	3	10	0101000000471CB28174894840B85B920376B54040	unsolved	4	999
46	Сміттєзвалище	У приватному секторі утворилося сміттєзвалище, яке, хоча і вичищається періодично установами ЖКГ, проте не упорядковане і розпорошене на 140-150 кв.м. Ще на 100-150 м у всі боки розлітається таке сміття, забруднена вся територія вулиці Фруктової та провулків.	1. Зареєструвати місце для розміщення побутових відходів.\n2. Облаштувати спеціально таке місце, оскльки продукти розкладання таких відходів потрапляють у грунти.\n3. Забезпечити можливість роздільного збирання побутових відходів та сміття.\n4. Провести розяснення серед населення щодо користування місцями розміщення відходів та роздільного збирання сміття.	3	6	0101000000C504357C0B23494044F8174163B23C40	unsolved	2	999
47	Долина нарцисів	Вчені відзначають значні зміни рослинного покрову впродовж останніх 25 років, зокрема, зменшення площ справжніх лук[8]. Колись гостролистий нарцис вкривав сотні гектарів землі, тепер щороку площа його зростання меншає. Наукові дослідження, спрямовані на покращення охорони цінних екосистем, стали можливими завдяки проекту Світового банку «Збереження біорізноманіття Карпат» (1993–1997 рр.; $ 500 000). 2006 року науковці, що досліджують цей куток природи, вдарили на сполох — нарциси почали висихати від недостатньої вологості ґрунту. Виявляється, останніми роками змінився гідрологічний режим ґрунтів, і квітам не вистачає вологи. Задля збереження долини екологи пропонують заборонити проїжджати тут автомобілями, зняти довкола асфальт, насадити дерева і зволожити землю (збудувати шлюзи і воду штучно підняти)[10]. Нарцисам буде добре, але виникає інша проблема — від підвищення вологості розростаються верби. Аби зберегти квіти, дерева вирубують[3].	Іншою серйозною проблемою для екологічного стану заповідної ділянки є масовий наплив туристів у сезон цвітіння нарцисів та варварське ставлення до квітів. У період масового цвітіння квітів «Долина нарцисів» приймає в середньому по 4—5 тис. відвідувачів на добу. На території масиву прокладені дороги, збудовані спеціальні майданчики для спостереження за квітами; у період цвітінння нарцисів охорона заповідної ділянки підсилюється лісниками з інших масивів області, але все одно цінні квіти масово зриваються та витоптуються туристами	3	14	0101000000D591239D8111484070CD1DFD2FD73640	unsolved	5	999
48	незаконне будівництво	років 20 тому вирили котлован під новий елітний будинок біля буд 83 на вул.Калинова, зараз цей покинутий котлован заріс деревами та кущами, там справжнє сміттєзвалище. Котлован обнесено парканом і його стереже охоронна фірма цілодобово. Прямо біля ЖЄКу №23. Цей ЖЄК покриває власника кієї "забудови".	засипати котлован та знову зробити там вільний під"їзд (доріжку, тротуар) до будинку №83 для машин та людей. 	3	8	01010000001348895DDB4148400DAB7823F3864140	unsolved	2	999
49	Переповнення відходами людського відпочинку	Півострів захаращений горами пластику, скла та іншого сміття, яке незаконно звозиться сюди або залишається після "відпочинку" мешканців Києва.	Зібрати актив Оболонського району для прибирання. Залучити виробника сміттєвих мішків, резинових перчаток тощо, в якості партнера/спонсора, та компанію, яка займається переробкою сміття - прибрати півострів, встановити шлагбауми, облаштувати зони відпочинку, розставити баки для сміття, та збирати по 5грн. з авто за підтримку чистоти.	3	22	0101000000789961A3AC4349402384471B47883E40	unsolved	2	999
50	Як зробити місто чистим	Проблема сортування сміття, немає контейнерів для пластика, паперу,скла і т.п.Сміттєзвалища, які роблять мешканці міста, бо немають екологічної культури. Багато реклами по телебаченню, але майже не побачиш реклами, пов`язаної з екологічними проблемами міста, країни, планети...	1. Широко і частіше освітлювати екологічні проблеми по телебаченню, в газетах, на бігбордах.\n2. Проводити масові екологічні акції с залученням шкільної та студентської молоді.\n3. Звернути увагу керівництва міста на проблему сміттєзвалищ с залученням спонсорів, партійних та громадських діячів.	3	7	01010000006DA983BC1E2648407FC0030308034340	unsolved	2	999
51	Зробити водойми екологічночистим місцем відпочинку	Забруднення водойм, не чистять , сміттєзвалища на берегах	залучити громадських діячів, студентську молодь та керівництво міста до вирішення проблеми - щорічно чистити, прибирати берег, поставити урни для сміття, обладнати берег для місця сімейного відпочинку мешканців міста	3	6	01010000004E469561DC2948407FC0030308034340	unsolved	4	999
52	незаконная стройка	строят выкидывают муссор	наказать и закрыть учириждение	3	5	0101000000D597A59D9A734C4082751C3F545C4E40	unsolved	2	999
53	Вирубка дерев	Вирубка дерев на території міста	вплив на владу, посадка садженців	3	11	01010000007E6FD39FFD00494017B7D100DE1E4240	unsolved	7	999
54	Завод з токсичними викидами в житловій зоні	В житловій зоні, в центральній частині м. Снятин, вже багато років працює завод по виготовленню оздоблювальний матеріалів з пластику (ПП «Лідер VTM»). Відповідно, завдається велика шкода здоров’ю людей, які живуть неподалік. Адже, завод постійно неофіційно спалює відходи, і цими газами мусять дихати люди (аж "горло дере"). Люди неодноразово зверталися у відповідні органи влади, але ніхто дану проблему не хоче вирішувати.	1. Закрити даний завод.\n2. Виплатити людям компенсації за завдану шкоду їхньому здоров’ю.\n3. Покарати винних підприємців та чиновників.	3	52	0101000000043C69E1B2384840707841446A923940	unsolved	3	999
55	Засмічення Вовчинецьких гір побутовим сміттям	Мешканці міста Івано-Франківськ, с.Вовчинець та с.Підлужжя скидають побітове сміття на схилах Вовчинецького пагорбу (комплексна пам\\'ятка природи місцевого значення ) та берегах річки Бистриця Надвірнянська..	Встановлення сміттєвих баків біля будинків в с.Вовчинець та с.Підлужжя, організація централізованого вивозу сміття не рідше 1 разу/тиждень, встановлення сміттєвих контейнерів при в\\'їзді в заказник "Козакова долина" та регулярний вивіз сміття (не рідше 2 разів/тиждень в період березень-листопад, не рідше 1 рази/тиждень в період грудень-січень)	3	18	0101000000CEFA9463B27A4840EB909BE106C03840	unsolved	2	999
57	Трасса здоровья и пляжи	Муниципальная территория отчуждается, передается в аренду и блокируется от свободного посещения по корупционным схемам органов областного и местного самоуправления. 	Привлечение общественных организаций, прокуратуры и т.д.	3	8	01010000001C7BF65CA63A47404C6DA983BCC23E40	unsolved	3	999
58	Свалка в карьере ракушечника	Мусоровозы возят мусор в карьер, вокруг свалки на полях и дачный участках  мусор	Закосервировать , утилизировать , засыпать	3	2	010100000085B4C6A01350474037DDB243FCE73E40	unsolved	2	999
59	Порушення підприємством санітарно-екологічних норм	Макарівська птахофабрика забруднює токсичними викидами повітря та воду. При проведенні моніторингу стану атмосферного повітря в селищі Макарів санепідемстанцією було встановлено, що концентрація двоокису азоту перевищує гранично допустиму в 1,27 разів, сірководню - в 15,38 разів, коефіцієнт комбінованої дії сірководню та аміаку перевищує норму в 16,62 рази. Це становить загрозу природі та здоров`ю людей.\nhttp://www.youtube.com/watch?v=562siiNlsfc	Необхідно примусити власників використовувати очисні технології та постійно контролювати рівень забруднення, або перенести виробництво подалі від населеного пункту.	3	11	01010000004FCE50DCF1384940BDC804FC1AD13D40	unsolved	7	999
60	Высыхает лиман	Высыхает лиман , частные домовладения по периметру водоема сливают канализацию и выкидывают мусор	Контроль , штрафы, связь с морем через существующий канал	3	5	01010000005EBEF561BD4947403CBF28417FE53E40	unsolved	4	999
61	незаконні сміттезвалища	незаконні сміттезвалища в посадках в межах города та поблизу.	 вплив на владу, громадський контроль. зміна законодавства	3	8	0101000000836C59BE2EFF4840B8E68EFE97194240	unsolved	2	999
62	Загрязнение Черного моря	Загрязнение моря сточными водами и ливневыми загрязнениями.	Ремонт ливневок, канализаций.	3	9	0101000000DDEEE53E393C474022AB5B3D27C53E40	unsolved	4	999
63	Смітник у зоні відпочинку	Гарний сосновий ліс перетворили на сміттєзвалище	Заставити відповідальних осіб прибрати територію. Побажання відпочиваючим - будьте людьми!!!	3	8	01010000006FD39FFD485B4840E9B7AF03E7283D40	unsolved	2	999
64	Незаконный вылов рыбы	Разпологаются сети браконьеров вдоль берега напротив городка , утром и вечером на надувных лодках собирают незаконный улов	Рыбнадзору и погранцам перестать брать взятки и заняться делом	3	5	01010000001669E21DE0494740CC43A67C08EE3E40	unsolved	6	999
65	Питьевая вода	Не соответствие стандартам качества питьевой воды города Одесса	Контроль за качеством воды в Днестре, применением химикатов на полях Одесской области, реконструкция водоочистительной системы города	3	9	0101000000D50627A25F3D4740BADA8AFD65B73E40	unsolved	4	999
66	экологически опасная свалка	Свалка с нарушениями всех нормативных документов в непосредственной близости к жилой зоне	Закрыть\n	3	3	01010000005CACA8C1345448408E23D6E2539C4140	unsolved	2	999
67	Заьруднення повітря	Забруднення повітря заводом "Ізоват"	Закрити, вдосконалити очисну систему	3	2	0101000000B728B341261F494047E9D2BF24BD3C40	unsolved	7	999
68	Сохранение и развитие зеленых насаждений	В Одессе незаконно вырубаются зеленые насаждения для очистки мест под строительство. Не обновляется ресурс зелених насаждений города.	Целевая програма по развитию озеленения города, обращение в прокуратуру.	3	6	010100000004C765DCD43A4740B285200725BC3E40	unsolved	1	999
69	"Сирітська хатка" на березі Південного Бугу	Побудований маєток на березі річки взагалі без врахування прибережної зони.	Бажана зацікавленність природоохоронних і юридичних органів.	3	7	0101000000702711E15FC248403F53AF5B04063C40	unsolved	3	999
70	Сміттєзвалище.	Велика купа сміття. 	Треба велика вантажівка і екскаватор. шоб вивезти сміття	3	3	0101000000C72E51BD355E49408DB7955E9B5D3E40	unsolved	2	999
71	сміттезвалища і сміття взовж річкі Ірпінь	Багато сміття викинуто вздовж річки	Сміття було вивезено на офіційний смітник за Димером за допомогою власних автівок членами клуба http://kievjeep.net/forum/index.php\nПроблему вирішено.	3	2	0101000000C710001C7B5E49400ABE69FAEC5C3E40	unsolved	2	999
72	Автозаправка напроти дев\\'ятиповерхового будинку	Замість зеленої зони збудували автозаправку напроти дев\\'ятиповерхового будинку. В будинку мешкає близько 500 мешканців, поряд ще будинки, школа дитячої творчості...\nНіяких дозволів, документів... у мешканців ніхто не питав чи хочуть вони мешкати напроти заправки і нюхати всі ці канцерогенні вихлопи.	Знести або підірвати заправку, повернути зелені насадження які були на її місці.	3	2	0101000000342F87DD770A4840779FE3A3C5094340	unsolved	7	999
73	Загрязнение местности и атмосферы	Большая свалка рядом с домами, также рядом очисная как подует от туда хоть не выходи на улицу.	Свалку перенести, построить завод переработки мусора, очистную перестроить по новым стандартам чтобы люди не задыхались от запаха что от туда идет	3	7	010100000084D89942E73D484059880E8123274040	unsolved	2	999
74	Забруднення території	Засмічення території міста самими жителями та засмічення лісів службами які відвозять сміття в ліс і там його залишають в великих кількостях	Розмістити таблички - реклами щодо чистоті в місті, це примусить задуматись принаймні більшу половину жителів. Щодо лівіс пивинна держава сама вирішувати такі питання та штрафувати тих хто відвозив ліс сміття і мало того, треба ще змусити їх його знищити аби його не перевезли в інше місце. Країна хабарництва! Ви ж для себе та своїх дітей гірше робите!	3	9	0101000000369204E10AA8494053EC681CEA973A40	unsolved	2	999
75	Мусорка	незаконная свалка мусора в лесопосадке. масштабы огромные	информирование населения	3	4	01010000001233FB3C462F4840774B72C0AE8E4140	unsolved	2	999
76	Незаконный вылов рыбы, раков	Разпологаются сети браконьеров вдоль берега, в ереках. Перекрыты каналы сетями в несколько этапов.	Контроль, извлечение сетей и порча их на берегу всеми не равнодушными.	3	6	0101000000874ECFBBB140474009A87004A90C3E40	unsolved	6	999
78	Майдуны	Нацизм и опасность для жизни	Прекратить беспорядки!	3	3	01010000008542041C42374940614F3BFC358D3E40	unsolved	1	999
79	не чистят	Озеро грязное	Убрать почистить	3	4	010100000067F16261883A49408E3C1059A4553E40	unsolved	4	999
80	выбросы в атмосферу загрязнённого воздуха с металлургических комбинатов и нехватка кислорода в воэдухе	выбросы в атмосферу загрязнённого воздуха с металлургических комбинатов и нехватка кислорода в воздухе	усилить фильтрацию выбросов и ...	3	28	0101000000560DC2DCEE8947408978EBFCDBC54240	unsolved	7	999
81	Не екологiчно чистi придприэмства якi забруднюють навколишнню середу	забрудненя повiтря	Побудувати екологiчнi придприэмства що не забруднюють навколишнiй середи	3	4	0101000000B8AD2D3C2F25484016BD5301F7044340	unsolved	7	999
82	Незаконне полювання в околицях с. Липовиця	Місцеві жителі не приховують, що в їхньому селі значна частина місцевих жителів відкрито промишляє браконьєрством. Кримінальні "мисливці" настільки нахабні, що розстрілюють охоронні знаки заповідних об\\'єктів. Особливо їх багато в малолюдних гірських районах Ґорґан.	- Операція по добровільній здачі незареєстрованої зброї\n- Інформування туристами про виявлення озброєних осіб в гірських чи лісових районах\n- Створення добровільних дружин, які патрулюватимуть в період риковиськ тощо	3	21	01010000006B2A8BC22E624840914259F8FA0A3840	unsolved	6	999
83	Греблі	Греблі призводять до обміління річок, замулення, вимирання іхтіофауни.	Необхідно поступово відмовитись від регулювання річкого стоку ха допомогою гребель.	3	3	01010000008AABCABE2BCE48402D05A4FD0F484140	unsolved	4	999
84	Велика кількість сміття	Купи сміття під метромостом	Запезбечити належний рівень якості вивозу сміття з району «Тюрінка», бо назараз це є один із найбільш забруднених районів Харкова.	3	10	01010000004CDD955D30004940A038807EDF234240	unsolved	2	999
85	Міське сміттєзвалище	Велике сміттєзвалище, яке постійно забруднює навколишнє середовище!!!	запустити існуючий неподалік завод з переробки твердих побутових відходів.	3	8	01010000005FD38382523249408F54DFF945353840	unsolved	2	999
86	Браконьерство	Вылавливают бродом и сетками всю живность в водоемах	Организовывать патруль	3	12	01010000005E4C33DDEBB4494072A8DF85ADD13E40	unsolved	6	999
87	Опасный мост	Опасный мост (после пожара) с постоянными пробками через него, в подземном переходе идет торговля, вообщем не пройти не проехать.	Полная реконструкция!!!\nhttp://kiev.vgorode.ua/news/95052/ 	3	11	0101000000261AA4E0293A4940904B1C7920723E40	unsolved	7	999
89	Вирубка лісу.	Вирубка лісу на території де знаходиться багато рідкісних рослин, в тому числі і з Червоної Книги України.	Пропоную перевірити вирубку на офіційність, якщо офіційно то звертатись з офіційними заявами до органів міського управління і т.д.\nЗазвичай вирубку проводять під ліценцією "чистки" але чистка включає в себе вирубку 1 дерева з 5, а в нас зрубуються всі.	3	5	010100000004543882543C4840486AA16472D63B40	unsolved	1	999
90	Радіаційне забруднення - База "С"	Бывший склад урановой руды. Находилось в эксплуатации с 1960 по 1991 годы. Содержит 150-300 тыс. тонн твердых радиоактивных отходов в виде полуразрушенных конструкций бункеров для урановой руды, загрязненных железнодорожных путей, грунта на поверхности и под бункерами. Объем – 0,15 млн. м3, площадь 300 тыс. м2. Максимальная мощность дозы гамма излучения на поверхности 4700 мкР/час, общая активность – 12000 Ku	Это проблема государственного масштаба, должна решаться как можно скорее на государственном уровне.	3	7	010100000083DBDAC2F33648402BDEC83CF2614140	unsolved	7	999
91	Переповнення відходами людського відпочинку	Берег захаращений горами пластику, скла та іншого сміття, яке  залишається після "відпочинку" мешканців Києва.	Прибрати, встановити шлагбауми, розставити баки для сміття, вивозити сміття.	3	5	0101000000E67805A227474940ED0F94DBF6893E40	unsolved	2	999
92	Украина?	Почему вы рисуете Крым в составе Украины?	Крым - Россия, Бандеру - геть!	3	8	0101000000DC48D922698946400C21E7FD7FF64040	unsolved	7	999
93	Сміттєзвалище переповнене.	Сміттєзвалище використовується понад нормативні строки що несе небезпеку.	Припинити використовувати сміттєзвалище.	3	8	010100000093C3279D481E49404D8578245E863E40	unsolved	1	999
94	Забруднення води	Червона вода стікає до Дніпра	Потрібні очисні споруди	3	8	010100000028F38FBE49E947409C3237DF88924140	unsolved	4	999
95	Забруднення повітря	Забруднення повітря небезпечними викидами заводів	Очисні споруди на заводах	3	3	0101000000D600A5A146ED474055A69883A0914140	unsolved	7	999
96	Незаконний вилов риби	Незаконне зайняття рибним, звіриним або іншим водним добувним промислом	У 200 разів збільшиться штраф за незаконний вилов риби.\nЗаборонити вилов риби.	3	12	0101000000F50EB743C3C64840CA4FAA7D3A624040	unsolved	6	999
97	Енергетика	Після вводу в експлуатацію нової станції метро та нової дороги, ліхтарі (6 ліхтарів) впродовж старої дороги залишилися, працюють та світять без мети.	Пропоную демонтувати непотрібні ліхтарі та спрямувати цю енергію на освітлення темної вулиці в цьому ж районі	3	4	010100000017D522A298064940A19E3E027F1A4240	unsolved	7	999
98	Зливання стычних вод у р. Хорол	Міська не очищена калінізація частково зливаеться в річку Хорол.	Потрібно вияснити чтому зливають і найти шляхи вирішення ціеї проблеми	3	7	010100000089B14CBF44FC4840E69315C3D5CD4040	solved	4	999
99	смiття	Люди кидають смiття у море, на вулицях. Навiть маленький фантик багато вирiшуе.	Не кидати смiття де заманеться. Якщо ти з\\'iв батончик i випив колу, поклади собi у сумку, якщо поряд нема смтника. З сумкою нiчого не станеться. Коли зустрiнеш смiтник- дiстань смiття та викинь його!\n	3	5	0101000000DAC70A7E1B364740E8BD310400C33E40	unsolved	2	999
100	Сміттезвалище у лісі	На очах розростається сміттєзвалище у лісі.	Обмежити рух транспорту через ліс. Вивезти сміття у спеціально відведене длля нього місце, Встановити попереджуючі знаки про штраф.	3	3	01010000009A417C60C73949404C88B9A46A573E40	unsolved	2	999
101	Уникальные водоемы.	Уникальные водоемы (часть из которых родниковые), с обильным наличием различного вида животных и птиц, зарастают и заиливаются. Животные и птицы уходят. С этими водоемами на прямую связано водообеспечение населения с использованием колодцев.	Чистка, вырубка старых (сухих, гнилых) деревьев.	3	6	0101000000552E54FEB5E448404EB9C2BB5CF03E40	unsolved	4	999
102	Сміттезвалище у лісі	На очах розростається сміттезвалище у лісі. Невідомі безперешкодно вивозять у ліс будівельне сміття та ін.	Обмежити рух транспорту через ліс, Вивезти сміття у відведене для нього місце, Встановити попереджувальні снаки про міру відповідальності за вивіз сміття та соціально направленцу агітацію за чисте довкілля.	3	2	010100000019FF3EE3C23949407808E3A771573E40	unsolved	2	999
103	Правительство Украины	Нелегитимная Власть - Правительство Украины	Вывоз на место свалки мусора.	3	7	01010000002C7DE882FA36494035289A07B07C3E40	unsolved	2	999
104	Забруднене озеро	Невелике озеро біля школи дитячого садка забруднена сміттям. Там кожен день гуляє багато молодих сімей та маленьких дітей	Собраться инициативной группе и убедить живущих там людей организовать очистку озера	3	2	0101000000F0C000C28734494079211D1EC2683E40	unsolved	4	999
105	Сміттєзвалище	Розвалена стара ферма та велика кількість сміття	Прибрати сміття та віддати територію під забудову	3	4	01010000006DE525FF93354940698B6B7C26B73940	unsolved	2	999
106	Забруднене озеро	Невелике озеро біля школи дитячого садка забруднена сміттям. Там кожен день гуляє багато молодих сімей та маленьких дітей	Собраться инициативной группе и убедить живущих там людей организовать очистку озера	3	2	0101000000E412471E88344940DA91EA3BBF683E40	unsolved	4	999
107	Незаконне вивезення сміття 	Сміттєзвалище існує вже досить довгий час, ним користуються незаконно, вивозять сміття з будівництв та інший непотріб	Необхідно обмежити проїзд автомобілів, дорога в цьому місті вузька	3	2	0101000000D7A02FBDFD414940F5D8960167BD3E40	unsolved	2	999
108	Незаконна вирубка лісів	Масово вирубуються ліси	Змінити лісника	3	3	01010000008AABCABE2B42494012C0CDE2C5BE3E40	unsolved	1	999
109	Вирубка дерев біля траси Київ - Чернігів	Проводиться повна вирубка захисних зелених насаджень біля траси Київ - Чернігів	Зупининити це! Відновити насадження!	3	6	0101000000B3CEF8BEB8424940AA61BF27D6C93E40	unsolved	1	999
110	Вирубка лісів	Незаконне вирубування лісів	Змінити лісника	3	4	01010000001A14CD03584249404A404CC285C03E40	unsolved	1	999
111	Вивезення сміття	засмічення лісів непотребом(пакети, колеса и т.д.)	обмежити проїзд в глуб лісу, суттєво збільшити штрафи, заборонити використання цилофанових пакетів	3	3	0101000000401361C3D34149405AD427B9C3BE3E40	unsolved	2	999
112	Забруднене озеро	В озеро зливаються стічні води, як результат воно заростаяє та не є придатним для людей	Організувати очистку водойми, вирішити проблему стічних вод	3	5	0101000000B8019F1F46404940A7ECF483BAC03E40	unsolved	4	999
113	Вирубка дерев	Вирубка дерев у великих масштабах, яким більше 100 років	Збільшення штрафів в 10-ки разів, кримінальна відповідальність	3	2	0101000000309E4143FF42494091B932A836BC3E40	unsolved	1	999
114	Very dirty river	В оттоку от речки сливают непонятно что, сам водоем закидан мусором и трупами умерших животных, вокруг полно мусора, битые стекла и т.д.	Если наш город слишком занят чтобы решать подобные проблемы, необходимо самоорганизоваться и хотя бы убрать территорию от мусора.	2	3	0101000000666A12BC21954840DA39CD02EDD44040	unsolved	3	999
115	Будівництво Біланівського ГЗК	Якщо Біланівський ГЗК почне діяти, весь ставок-випаровувач «Укртатнафти» інфільтрується у тіло кар’єра. Стоки, що надходитимуть до ставка, не очищуватимуться. Зате вони потраплятимуть в кар’єр – адже між ставком та кар’єром небезпечно мала відстань. А там вестимуться вибухові роботи. Виникне проблема відкачування кар’єрних вод. Кар’єрні води – це дуже солоний розчин, ропа. З ними змішаються насичені фенолами води ставка-випаровувача. Куди їх скидати? Тут варіантів кілька. Можна будувати новий ставок-відстійник – це дуже дорого. Можна скидати води в Дніпро чи Псьол. Та у такому випадку солона ропа та феноли винищать все. Як це вплине на Дніпро, можна ще думати, а Псьол – зважаючи на його малу потужність – стане мертвою рікою.	Потрібно закрити будівництво Біланівського ГЗК, щоб не було екологічної катастрофи.	3	2	0101000000666A12BC21954840DC63E94317D44040	unsolved	3	999
116	Попадання неочищених стічних вод в річку	Вже багато років в Івано-Франківську не працюють як належно очисні споруди стічних вод. Фінансування на вирішення проблеми відсутнє, стан очисних споруд жахливий, результати аналізів стічних вод які попадають в річку приховують, перевіряючі органи за замовчування питання беруть хабарі.	Показати громаді міста реальну картину, залучити довгострокові інвестиції на відновлення або переоснащення очисних споруд, виконати проект та реконтсрукцію або капітальний ремонт згідно цього проекту.	3	7	0101000000406B7EFCA58148408733BF9A03BC3840	unsolved	4	999
118	Сміттєзвалище	Сміттєзвалище	Сміттєзвалище	3	6	01010000009432A9A10D444940E2CCAFE600393E40	unsolved	2	999
119	Забруденний ставок в Козельщині	Береги ставка засмічені та вода має неприємний запах. Також навколо прилеглих територій помітні залишки сміття, що псують вигляд Козельщини.	Необхідно виділити гроші для очищення ставка і прибрати сміття навколо ставка. Зробимо Козельщину чистішою!	3	2	0101000000276BD443349C48402E8F352383EC4040	unsolved	4	999
120	Екологічний хаос	Це сміттєзвалище працює ще з того часу. За весь час на нього не було виділено ні копійки. За результати праці я думаю балакати не доведеться, тут і так все ясно. Сміття вивозять кожен день. Загортають бульдозерами в землю. Залишки намагаються спалити, але це не завжди вдається. Звідци й збираються великі кочугури сміття, яке просто не вспівають обробляти. Вивід один - постійний сморід, забруднення грунтових вод, все йде людям в криниці. Також екологічна проблема в тому, що не всі продукти підлягають процесам розпаду і переробки природнім шляхом (пластикові бутилки, пакети, одноразовий посуд та ін.)	На місцевій обласній раді не раз ставилося питання, щодо вирішення цієї проблеми. Депутати прийняли рішення знайти інвестора для будівництва переробного заводу, на території звалища. Але чомусь - руху ніякого до сих пір. Було б не погано, як би зайнялись зацікавлені люди цим питанням. Завод вироблятиме вторинну сировину, яку також можна використовувати в виробництві одноразового посуду тощо. З часом вилучені кошти від продажу продукції також можливо використати за призначенням. На мою думку рентабельність цього заводу складатиме 70-85 %, що в наш час не погано. З урахуванням кошториса та затрат на будівництво потібно 5 -7 років на повернення коштів. Це також не погаганий показник, навіть без підтримкм влади. Для підтримки необхідні зміни до діючого законодавства, щодо охорони навколишнього середовища, та притягнення до відповідальності посадових осіб за розкрадання державних коштів.	3	0	01010000001F84807C09274940A7AD11C138A43C40	unsolved	2	999
121	Остров из мусора	Искусственно созданный остров из отходов пищевой и бумажной промышленности.	Установка фильтров на предприятиях.	3	2	0101000000FA0B3D62F43C4840C2A6CEA3E2914140	unsolved	4	999
122	Окупація військами Путлєра	9 березня 2014 року російська армія, замаскована під зелених чоловічків, розпочала  військову агресію та окупувала Крим.	Вигнати окупантів з української землі.	3	27	01010000003CDD79E2399F46402635B401D8164140	unsolved	7	999
123	Екологічний хаос	Це сміттєзвалище працює ще з того часу. За весь час на нього не було виділено ні копійки. За результати праці я думаю балакати не доведеться, тут і так все ясно. Сміття вивозять кожен день. Загортають бульдозерами в землю. Залишки намагаються спалити, але це не завжди вдається. Звідци й збираються великі кочугури сміття, яке просто не вспівають обробляти. Вивід один - постійний сморід, забруднення грунтових вод, все йде людям в криниці. Також екологічна проблема в тому, що не всі продукти підлягають процесам розпаду і переробки природнім шляхом (пластикові бутилки, пакети, одноразовий посуд та ін.)	На місцевій обласній раді не раз ставилося питання, щодо вирішення цієї проблеми. Депутати прийняли рішення знайти інвестора для будівництва переробного заводу, на території звалища. Але чомусь - руху ніякого до сих пір. Було б не погано, як би зайнялись зацікавлені люди цим питанням. Завод вироблятиме вторинну сировину, яку також можна використовувати в виробництві одноразового посуду тощо. З часом вилучені кошти від продажу продукції також можливо використати за призначенням. На мою думку рентабельність цього заводу складатиме 70-85 %, що в наш час не погано. З урахуванням кошториса та затрат на будівництво потібно 5 -7 років на повернення коштів. Це також не погаганий показник, навіть без підтримкм влади. Для підтримки необхідні зміни до діючого законодавства, щодо охорони навколишнього середовища, та притягнення до відповідальності посадових осіб за розкрадання державних коштів.	3	0	010100000097FF907EFB264940D76CE525FFA33C40	unsolved	2	999
124	ставок Крива Руда	В ставок раніше викидались стічні води з цукрового заводу, а зараз в нього викидають сміття і каналізацію. Якщо глянути, то видно що вода зелена а підводою багато муляки.	\nСлужба що проводила очистку ставка перестала існувати після розпаду СССР. Потрібно створити щось подібне, щоб привести ставок до нормального виду.	3	4	0101000000D6FD63213ACC4840FA7B293C689A4040	unsolved	4	999
125	Жомова яма	Цукровий завод уже давно закрився, а жомова яма до сих пір гниє. В сонячну погоду по вулиці Транспортній нереально йти з незакритим носом!	Необхідно вивести всю цю вонь.	3	3	01010000006EC493DDCCCC4840EB8D5A61FA984040	unsolved	5	999
126	Незаконне сміттєзвалище	Сюди люди вивозять сміття.	Думаю, необхідно ще кілька сміттєвозів, щоб люди самі не вивозили своє сміття куди попало.	3	3	01010000001233FB3C46CB4840EE27637C989B4040	unsolved	2	999
127	Загрязнение воздуха предприятием  "АрселорМиталл Кривой Рог"	Загрязнение атмосферного воздуха. Отключение всех фильтров по ночам. Загрязнение водоемов. 	Штрафы и административные взыскания. Независимый экологический аудит 	3	17	01010000005776C1E09AEF47403BE0BA6246B24040	unsolved	7	999
128	Проблема вивезення сміття та культури людей	Не відомо - це мешканці села туди звозять сміття чи просто люди які зупиняються на своїх машинах , але ж блін  до заправки 100 метрів -- невже важко донести своє сміття !!!! 	Зібрати місцевих мешканців та прибрати сміття , встановити відеофіксатори - щоб виявити порушників .  Мій контактний номер : 066-846-8-555 (Ілля) 	3	4	0101000000410DDFC2BA2D49408BFCFA2136703E40	unsolved	2	999
129	Вирубка лісу	Дуже сильно незаконно вирубують ліс біля "історичного дуба".	Прийняти міри!	3	10	010100000066F4A3E1941548401DAB949EE9013A40	unsolved	1	999
130	Звалище будівельного сміття 	Стихійне звалище будівельного сміття біля грунтової дороги	Прибрати звалище. Встановити нагляд та попереджувальні знаки. Закрити або обмежити проїзд,	3	0	0101000000FCA5457D92E9474025B1A4DC7D864140	unsolved	2	999
131	Очисні споруди	В м. Борщів вже багато років не працюють очисні споруди. Вся вода з міської каналізації потрапляє в місцеву річку Нічлава.	Відновити роботу очисних споруд.	3	3	0101000000EA5DBC1FB765484057B3CEF8BE083A40	unsolved	4	999
132	Бездомные собаки	Многочисленные стаи бездомных собак!	Отловить и поместить в питомник.	3	6	0101000000D9D0CDFE403F4940F73C7FDAA8723E40	unsolved	7	999
133	Забруднення ставків.	Ці ставки - дуже популярне місце для відпочинку та зайняттям спорту, безліч сімей відпочиває на берегах цих ставків, навіть рибалки ходять сюди.\nАле, ставок з кожним роком стає все більш забрудненим. Колір води в ставку становиться все темнішим... \nАле здебільшого забруднюють самі відпочиваючи, залишають за собою велику купу сміття, деякі слухняні збирають після себе та несуть до смітнику, який стоїть на виході з лісу, але це далеко, деяким - важко стільки нести.\nВ тому році, була зроблена яма, щоб хоча б якось локалізувати сміття, але вона швидко заповнилась і ніхто її не прибирав...\nПроблема відома вже декілька років, вже й було виділено дуже багато грошей (600000грн.), для того, щоб вирішити цю проблему, але ці гроші мабуть пішли, на інші справи... \nОсь лінк: http://vpoltave.info/read/novost/id/199972117/Stavki-mezhdu-Sadami-i-Polovkami-dozhdalis-svoejj-ocheredi\nПро ситуацію: http://vpoltave.info/read/novost/id/199814170/Otdykh-na-pomojjke	Хоч і учні шкіл ходять сюди на суботники, щоб прибрати, але це не на довго, за одні вихідні - знову купа сміття.\nРоків з 10 тому, в цих ставках купались люди, а зараз і порух важко знаходитись.	3	4	0101000000473D44A33BCA48402C80290307404140	unsolved	4	999
134	Забруднена водойма	Сильно забруднена водойма. Постійно падає рівень води.	Очистка води	3	6	010100000017D86322A5354940126C5CFFAEA33E40	unsolved	4	999
135	Проблема питної води	Людям, які живуть поблизу Єрестівсього ГЗК немає де набрати питної води, так як у зв\\'язку з будівництвом кар\\'єру, у воду попали небезпечні хімічні елементи, які шкодять здоров\\'ю людей. Також в цих місцях із-за вибухів - вже стіни на хатах потріскались.	Необхідно терміново вирішити це питання, бо людям з навколишніх сіл загрожує небезпека для їх життя та здоров\\'я. Місцева влада повинно вирішити цю проблему.	3	2	0101000000753FA7203F8B4840D218ADA3AAD94040	unsolved	4	999
136	міське сміттєзвалище	1 жахливий еко стан довколишніх поселень\n2  забруднення повітря (самозаймання), \n3 забруднення грунтових вод. \nосновне накопичення сміття не контрольоване адміністрацією міста (стихійне). вибіркове вивезення сміття компанією монополістом. велика кількість сміття спалюється в межах міста - спричиняє забуднення повітря.	1 запросити декілька інших сміттєвих компаній (зруйнувати монополію на вивіз)\n2 запровадити систему сортування сміття для подальшої переробки\n3 збудувати сміттєпереробний завод 	3	2	0101000000A565A4DE53F54840C2DD59BBED8E3C40	unsolved	2	999
137	Забруднення повытря	Постійний запах тухлих яєць. Купа сміття по боках дороги.	Поставити нові очисні системи.\nПрибрати сміття.	3	0	0101000000EAB46E83DAEF4740AF7D01BD70954140	unsolved	7	999
138	Экологическая культура жителей города	Равнодушие жителей города к экологическим проблемам, оставляют мусор после семейного отдыха в лесу, парке, у водоема. Дети бросают обертки от конфет на дорогу, хотя урна находится не далеко. Выбрасывают много бумаги, хотя можно сдать макулатуру. Много отходов выброшено, а рядом бродят голодные бездомные животные.	Работаю в творческой группе учителей города по экологическому воспитанию, проводим с коллегами конференции, семинары для учителей, организовываем природоохранные акции и т.д. Хотелось бы, чтобы нам в этом помогала и городская общественность, молодежные организации, студенты.	3	3	0101000000662D05A4FD2748407FC0030308034340	unsolved	7	999
139	Сміттєзвалища на "Балка"	немає служб, що доглядають цю територію	Люди	3	3	0101000000CA37DBDC9834484080457EFD10894140	unsolved	2	999
140	 горит свалка ТБО	Уже месяц горит свалка. Дым на весь город. Все пропахло вонючий дымом. Самое печальное, что местная власть на это не реагирует.	Срочно принять меры по тушению пожара. Рекультивация земель на полигоне. Огородить территорию. Огриничить доступ посторонним лицам. Пропускной режим. Придерживаться закона об отходах.	3	7	01010000001F115322896647400475CAA31B5B4240	unsolved	2	999
141	Добыча сланцевого газа	Загрязнение подземных вод химическими смесями	Запретить добычу	3	6	01010000001BD82AC1E2464840073F7100FDA44240	unsolved	7	999
142	Хранилище радиоактивных отходов «Щербаковское»	Хранилище радиоактивных отходов гидрометаллургического завода (ГМЗ)\n На заводе была реализована следующая технологическая цепочка:разработка месторождений урановых руд открытым и шахтным способами (сопровождалась выбросами радиоактивной пыли, отвалами, выделением газа радона), производство уранового конденсата непосредственно на заводе(сопровождалось образованием огромного количества радиоактивных жидких отходов). Отходы производства в виде пульпы сбрасывались в хвостохранилище. По состоянию на конец 2010 года в хвостохранилище находится 37,4 млн.т отходов уранового производства общей активностью \n 3,89*1014 Бк.\n Площадь хвостохранилища - 25 га\n Расстояние до города - 1,5 км	Загрязнение обнаруживается не только на поверхности грунтов, но и проникает на глубину до одного метра. Причем, содержание изотопов урана, тория, полония, свинца увеличивается с глубиной.	3	2	01010000001C7E37DDB227484022E17B7F83BE4040	unsolved	7	999
143	Грязное старое русло реки Лугань	Мусор, ил	Необходима чистка реки, вывоз мусора	3	5	01010000009A7D1EA33C4B4840091B9E5E29AB4340	unsolved	4	999
144	Title	Content	Proposal	1	5	0101000000A38FF980404B4840E97E4E417EAA4340	solved	4	999
145	Экологическая культура жителей города	Экологическая культура жителей города	Перестать выбрасывать мусор на улицу	3	6	01010000002D95B7239C484840EAB46E83DAB34340	unsolved	1	999
146	Викид шкідливих речовин у повітря - застарілий сміттепереробний завод у межах міста Києва	Регулярно сміттепереробний завод викидає у повітря відходи, які майже унеможливлюють отримання повітря через вікно. Жителі масивів Позняки, Осокорки, Харківський, змушен користуватися кондиціонерам і тримати вікна зачиненими. Вважаю, що дана проблема є загрозою для здоров\\'я всього населення перелічених районів.	реконструкція заводу, переведення на сучасні європейські технології. Або перетворення  на завод з розподілу сміття, а переробка - поза межами міста!	3	11	01010000004CFE277FF7324940223999B855AC3E40	unsolved	2	999
147	Свалка в Тоннельной  балке 	Отдыхая на природе, люди не утруждаются   вывозом мусора и кидаю его на под ближайший куст.	Установка мусорных  урн, наложение штрафов, на нарушителей,  субботники 	3	2	0101000000FA0B3D62F4344840B9AAECBB22844140	unsolved	2	999
148	Свалка в Тоннельной  балке 	Проблема в массовых стихийных свалках после отдыха людей на природе. Мусор с балки не вывозится, и убирается только благодаря активистам на субботниках.	Установка мусорных  урн, наложение штрафов, на нарушителей,  субботники 	3	2	010100000044C2F7FE063548406C97361C96844140	unsolved	2	999
149	Вирубка невеликого лісу 	Раніше був невеличкий ліс, в котрому проживали зайці, у нього ходили люди на відпочинок, але його знищили та почали забудову ділянок біля траси. 	Можливо вже запізно щось робити, але можна попередити вирубки зелених насаджень у подібних ділянках.	3	1	010100000071033E3F8C324840F1F62004E4854140	unsolved	1	999
150	Жахливі руїни дому ветеранів	Руїни дому ветеранів, яки розбирають.	Прибрати руїни	3	5	0101000000459BE3DC268E47408ACC5CE0F2D64240	unsolved	2	999
151	Яценюк	Проблема выбора. Ошибся, когда связался с Европой.	Украина, возвращайся домой.	3	2	01010000007C8159A14839494093C83EC8B2883E40	unsolved	7	999
152	проблема днепровских склонов	После того как был построен вертодром и остальные высотные сооружения,  склоны Днепра находятся в критическом состоянии. Под смотровой площадкой образуются овраги, что может критично отразиться на целостности фундамента Мариинского дворца	Собрать консилиум специалистов и выбрать наиболее реалистичный проэкт по укреплению днепровских склонов	3	6	0101000000DAACFA5C6D3949404759BF99988A3E40	unsolved	7	999
153	Сміттєзвалище 	Пустая поляна , на которой постоянно собирается мусор и люди жгут костры 	Обустроить ее , построить что либо ( дет. площадку , магазины ) или хотя бы просто сделать асфальт 	3	2	010100000071218FE0469047403D5FB35C36D64240	unsolved	2	999
154	загрязнение прибрежных морских вод	Загрязнение акватории городскими сточными водами и сточными водами крупнейших промышленных предприятий. Часть загрязнения происходит в результате работы морского порта.	Контроль выполнения норм экологических требований законодательства судами, заходящими в акваторию порта. Детальное рассмотрение эффективности и аккуратности выполнения перегрузки сыпучих грузов, таких как сера, угольный пек, собственно уголь и многие другие виды  минералов. Очистка акватории.	3	1	01010000009A081B9E5E8B47408978EBFCDBC54240	unsolved	4	999
155	Огромная мусорка	Огромные горы мусора, которые лежат годами и не перерабатываются. Мусор на эту свалку сводят не только со всего города и близлежащих поселков но и с других городов. Наш город как мусорный склад.	Решение проблемы переработки мусора и отходов в стране -первоочередная задача! Никто не хочет заниматься этой грязной работой, бизнесменам не выгодно содержать перерабатываются заводы т.к нет выгоды и перспектив использования переработанных материалов.. Нужно найти применение для переработанных отходов, заинтересовать нужных людей в полезности таких предприятий.	3	1	010100000032569BFF579147405C76887FD8D04240	unsolved	2	999
156	Проблема разрушенных дамб пресноводных ставков	В степи разрушены дамбы пресноводных ставков, Вода в степи - определяющий фактор. 	Необходимо восстанавливать дамбв по примеру Акций Украинского обществыа охраны птиц летом- осенью  2013 года.	3	5	0101000000975643E21EA9464043C879FF1F374240	unsolved	4	999
157	Евромайдан	Нельзя так жить	Свалите от туда	3	5	0101000000F790F0BDBF3949407D24253D0C853E40	unsolved	2	999
158	Слив с заводского отстойника непосредственно в море	Металлургический комбинат Азовсталь имеет на своей территории отстойник промышленной воды, но вот уже долгое время отстойник прорвал и грязная, технологическая воды вылевается непосредственно в море. Это черное пятно грязной воды видно с воздуха	Потребовать у руководства комбината провести ремонтные работы отстойника и очистных сооружений для предотвращения попадания в воду промышленных, токсичных отходов	3	0	01010000007218CC5F218B47403ACB2C42B1CF4240	unsolved	5	999
159	Сміття,забруднення повітря	По вулицях розкидане сміття,повітря забруднене заводами з важкої металургії	Хочу,щоб долучали до цього людей,яким не все одно!мі зможемо ще все вирішити!!!	3	0	0101000000FEBAD39D275C4840C9586DFE5FC94240	unsolved	2	999
160	Стихійне сміттєзвалище	Стихійне сміттєзвалище на березі озера де зазвичай відпочивають кияни на Оболоні.	Прибрати територію та влаштувати смітники.	3	3	01010000004837C2A2224449405BEF37DA717F3E40	unsolved	2	999
161	Екологічне забруднення місцевості на заповідній території Апостолівського району, Дніпропетровської області	Забруднення місцевості на заповідній території Апостолівського району викидами з заводів міста Орджонікідзе, Нікопольского району, зокрема Procter & Gamble (химический комбинат). Спроби зекономити на використанні фільтрів призводить до збільшення захворювань на онкологію та респіраторні "інфекції". Нижче стаття з сайту «Город Никополь» : С конца июля жители города неоднократно жаловались на то, что в их домах и квартирах появляется пыль темного цвета с отвратительным запахом, которая к тому же почти не смывается.\nПричем подобные случаи фиксировались в разных районах города, в том районах городской больницы, и даже центральной площади им. Ивана Сирко! При этом никаких комментариев от властей по этому поводу до сих пор не последовало. Хотя с почти что 100%-й уверенностью можно говорить, что причиной загрязнения являются промышленные выбросы.	Версий об источнике загрязнения ходит несколько. Некоторые причиной выбросов называют работу местной Богдановской обогатительнйо фабрики, которая расположена относительно недалеко. Но многие кивают в сторону завода бытовой химии «Проктер энд Гембл», который также расположен на территории города. В этом плане стоит вспомнить тот факт, что феврале 2012 года в районе прилегающих к заводу автогаражей территория площадью примерно в 1 гектар была загрязнена неизвестным веществом, до безобразия похожей на стиральный порошок.	3	0	01010000008542041C42D54740637FD93D79084140	unsolved	1	999
162	екологічне забруднення заповідних територій Апостлівського та Нікопольського районів	Забруднення місцевості на заповідній території Апостолівського району викидами з заводів міста Орджонікідзе, Нікопольского району, зокрема Procter & Gamble (химический комбинат). Спроби зекономити на використанні фільтрів призводить до збільшення захворювань на онкологію та респіраторні "інфекції". Нижче стаття з сайту «Город Никополь» : С конца июля жители города неоднократно жаловались на то, что в их домах и квартирах появляется пыль темного цвета с отвратительным запахом, которая к тому же почти не смывается.\nПричем подобные случаи фиксировались в разных районах города, в том районах городской больницы, и даже центральной площади им. Ивана Сирко! При этом никаких комментариев от властей по этому поводу до сих пор не последовало. Хотя с почти что 100%-й уверенностью можно говорить, что причиной загрязнения являются промышленные выбросы.	Версий об источнике загрязнения ходит несколько. Некоторые причиной выбросов называют работу местной Богдановской обогатительнйо фабрики, которая расположена относительно недалеко. Но многие кивают в сторону завода бытовой химии «Проктер энд Гембл», который также расположен на территории города. В этом плане стоит вспомнить тот факт, что феврале 2012 года в районе прилегающих к заводу автогаражей территория площадью примерно в 1 гектар была загрязнена неизвестным веществом, до безобразия похожей на стиральный порошок.	3	0	010100000089230F4416D547405DDF878384084140	unsolved	5	999
163	Дышим хлором , берилием , бензолом , натрийдихлофокперит , и вообще проблема уже 115 лет	Заводы - 2 крупнейших металлургических комбината , которые выбрасывают   850 млн. тонн отравляющих веществ , мы тут все от рака лёгких дохнем !!!	поставить долбанные фильтры на трубы , хоть белирий с хлором вдыхать не будем , и бензола паубавится 	3	1	01010000004F1F813FFC8C4740CFDC43C2F7CC4240	unsolved	7	999
164	Озеро Снітинка біля Фастова	Нечистоти з міста Фастів, викидаються у озеро. 	Ремонт(побудова) очисних споруд.	3	4	0101000000B4CBB73EAC0D4940E466B8019FF73D40	unsolved	4	999
165	Сміття	Прикро бачити коли люди проходячи кожного дня лісосмугою викидають там сміття із дому йдучи дорогою до дому.  Підлітки підтримують таку тенденцію і теж смітять обгортками і пляшками. І як з цим боротися?!.	Напевно варто поставити бак для сміття. Але хто має оплачувати послуги ЖЕКу?	3	12	01010000001EE1B4E0459949400F09DFFB1BB43840	unsolved	2	999
166	Вирубка лісу	Йде активна вирубка лісу на горі, над селом, розбивається дорога, висохли джерела, зникли тварини, галявини всі зруйновані самоскидами...	З"ясувати до якого лісгоспу відноситься ця ділянка, вияснити хто займається вирубкою	3	4	010100000058ACE122F7584840AD342905DD663640	unsolved	1	999
167	Загрязнена річка	Із-за Корсунь-Шевченківської ГЕС рівень річки Рось значно знизився, і ріка почала заростати. Також не добросовісні житалі викидають в річку сміття, що призвело до загрязнення річки. В Росі зменшилась кількість риби майже до мінімуму.	Провести відкриття шлюзів щоб змити зарослі ділянки річки. Провести акцію по чистці річки. Посилити контроль від браконєрства. 	3	6	01010000004016A243E0B4484055FA0967B7423F40	unsolved	4	999
168	Сміттєзвалище біля джерела води	Неохайно організоване офіційне сміттєзвалище знаходиться за 40 метрів від старовинного польового джерела питної води.	\nПеренести сміттєзвалище на будь-яку відстань від даного місця (територія це дозволяє).	3	1	01010000003259DC7F643A4940EE06D15AD19E3C40	unsolved	2	999
169	Срублено здоровое дерево	Абсолютно здоровое дерево, которое только начало цвести, срубил какой-то замечательный человек 29.04.2014.	Найти и выписать солиднейший штраф: дерево не на частной территории, чтобы кто-то имел право принимать самовольное решение о его уничтожении.	3	0	01010000002CF3565D873E474014B1886187AD3E40	unsolved	1	999
170	Слив канализации в озеро	Один из частников сливает продукты своей жизнедеятельности в озеро. Если пройти от спуска с улицы Озерной вдоль ставка по узенькой тропке, рано или поздно натолкнешься на метровую "речку" отходов, идущую с частной территории.	Собрать деньги на лопату частнику, чтобы он мог вырыть себе выгребную яму, и сдать его в руки властям за преступление против общества и своих соседей.	3	0	01010000005D6A847EA64047405E4C33DDEBB03E40	unsolved	7	999
171	Сміттєзвалище	Сміттєзвалище	Впорядкувати силами місцевої громади, місцевих органів самоврядування	3	3	010100000057B5A4A31CB248404C7155D977FD3840	unsolved	2	999
172	Сміттєзвалище	Мешканці однієї з вулиць, створили власне сміттєзвалище, звісно ж несанкціоноване!\nЇдеш через це село, аж самому не приємно що на в\\'їзді таке твориться.	"Дати по дупі мешканцям цього села що сворюють це сміттєзвалище".......\nПритягнути до адміністративної відповідальності винуватців і заставити поприбирати!!! Покласти відповідальність за вирішення цього на органи місцевого самоврядування і дільничного інспектора. 	3	3	0101000000CA8B4CC0AFA948403F70952710FE3840	unsolved	2	999
173	Грибовицьке сміттєзвалище	Переповнене Грибовицьке сміттєзвалище.	Почати рекультивацію спільно з Львівською міською радою	3	5	0101000000D9B27C5D86F34840DE8D058541093840	unsolved	2	999
174	Стихійні сміттєзвалища	Стихійні сміттєзвалища на території міста	Організація прибирання	3	3	0101000000BA4C4D823708494007D0EFFB37273940	unsolved	2	999
176	Парк завалений сміттям, яке періодично залишають відпочиваючі	Парк "Перемога" завалений сміттям, яке періодично залишають відпочиваючі. В частині парку сміття ніхто не прибирає.	Ретельніше прибирати парк. Посилити відповідальність за засмічування території. 	3	4	0101000000D07CCEDDAE3B49405F61C1FD809B3E40	unsolved	2	999
177	Стихійні звалища на Вінниччині, проблема утилізації відходів	Глобальна проблема Вінниччини - більше 3000 стихійних звалищ, які шкодять природі і не відповідають санітарним нормам. В багатьх населених пунктах відсутні сміттєві баки, сміття кидають прямо на вулиці. Відсутній централізований вивіз сміття. Люди влаштовують звалища де їм заманеться.   	Посилити відповідальність за засмічування.\nПоставити сміттєві баки.\nПобудувати сміттєпереробний завод.\nВиховувати екологічну культуру.\nЗбільшити кількість прибиральників, особливо в селах	3	2	01010000008EE733A0DE3048400B2AAA7EA5DB3C40	unsolved	1	999
178	Вирубка лісу.	В с. Карпівка, Могилів-Подільського р-ну, Вінницької обл. здійснюється вирубка лісу. Законна чи ні не відомо, але її необхідно зупинити. На території лісу росте велика кількість різних рослин. Багато з яких знаходяться під охороною(Червона книга України) оскільки є рідкісними.	Я готовий почати вирішення цієї проблеми але мені необхідна юридична допомога.	3	1	0101000000DE0033DFC13D4840E012807F4ADD3B40	unsolved	1	999
179	Сміттєзвалища	Мусорная свалка в городе. Мусор разлетается на всю округу загрязняя близлежащий жилой массив и лес.	Отдать мусороперерабатывающим компаниям. Организовать новую свалку дальше от города и жилых массивов.	3	1	0101000000ED2AA4FCA47C464028F04E3E3D164140	unsolved	1	999
180	утилізація побутових відходів	У місті система вивозу та утилізації сміття працює на дуже низькому рівні. Міська влада не забезпечує стабільну роботу комунальних служб та вивіз побутових відходів, не створює в достатній кількості точки їх збору (банально - смітники).	Створити громадську ініціативу, що тісно співпрацюватиме з міською владою та службами вивозу сміття, а також досліжуватиме цю проблему в регіоні. Провести акції, доброчинні збори коштів на благоустрій міських зон відпочинку та інших місць громадського користування. Крім того, запровадити штрафи за побутові викиди у несанкціонованих місцях.	3	0	01010000003D80457EFDE650C00000000000675140	unsolved	7	999
181	Повсеместная рубка леса вокруг Харькова	Лес рубится делянками 500*500 метров подальше от населенных пунктов,что бы меньше видели.Ближе к городу рубят выборочно лучшие деревья.То что ближе к городу в основном ночью дабы не привлекать внимания.И это не санитарная а промышленная рубка.	Проверить законность,разрешение. Перевести эти леса в заповедный фонд.Это ведь чистый воздух для такого большого промышленного города как Харьков.   	3	1	01010000002EFF21FDF6014940A12FBDFDB9144240	unsolved	1	999
183	Забруднена водойма	Забруднена річка Золотоношка через недостатню роботу очисних споруд.	Покращення якості очисних споруд, контроль за викидами в річку.	3	15	01010000003FE603029DC94840341477BCC90B4040	unsolved	4	999
184	Забруднене озеро	Забруднене озеро, за 30 років серія озер, в якому купались люди, перетворилось на замулене болото, в яке з часом ще й почали викидати сміття 	Очистити озеро	3	12	010100000000AC8E1CE93249403D47E4BB946E3E40	unsolved	4	999
185	Забруднення водойм	Міське озеро забруднюється сміттям, що призводить до його пересихання, хоча воно є місцем існування багатьох водоплаваючих птахів	Очищення озера від сміття, просвітницька робота серед населення	3	2	0101000000FD2FD7A2050A4940E754320054293940	unsolved	4	999
186	Стихійне сміттєзвалище	Дане сміттєзвалище розміщується у місті Снятин Івано-Франківської області і знаходиться недалеко від будинків, де проживають люди, приблизно 250-300 метрів. І практично щовечора по прилеглих вулицях стоїть важкий смердючий смог. Неможливо навіть вийти надвір. Біля звалища протікає струмок. Сміттєзвалище є стихійним і жодних документів на його експлуатування немає, але сміття все одно звозиться на протязі багатьох років. Недавно було зафіксовано, що сміття почали звозити не тільки з міста, а й сіл району, та ще й з сусідніх районів. Жителі прилеглих вулиць неодноразово звертались до влади міста з проханням закрити звалище, але і колишня влада, і теперішня мають 1000 і 1 відговірку: то якийсь проект виробляють, то кошів немає і т. д. А люди всеодно змушені страждати.	Сміттєзвалище закрити, як таке і ліквідувати всю його непоправну шкоду. Винних в незаконному експлуатуванні - покарати!!!	3	34	0101000000554FE61F7D3948401C7DCC0704963940	unsolved	2	999
187	Стврено сміттєзвалище на місці водовідводного каналу	Стврено сміттєзвалище на місці водовідводного каналу, люди викитають сміття яке не перегниває так як не хочуть оплачувати сміттєзбір 	Повідомити місцеву владу, виявити порушників, прибрати	3	0	0101000000C2FBAA5CA8464940BCADF4DA6C1C3E40	unsolved	2	999
188	Річка	Не знаю, який унікум поряд описав проблему про Корсунь-Шевченківську дамбу яка буцімто не пускає воду, але вірити цьому не варто. Тому що проблема почалась десяток років назад коли прорили штучний канал з річки Рось до міста Умань, для водопостачання всього міста, де вони і відводять штучно левову частку води. Тому починати з відновлення Річки РОСЬ потрібно тільки з штучного каналу в місто Умань.	Очищення річки, перевірка штучних каналів. 	3	0	0101000000B85B920376B348408D5DA27A6B403F40	unsolved	4	999
214	12345	\N	\N	None	0	01010000007D09151C5E8C49404D6A6803B05D3F40	unsolved	1	999
217	Test problem 208	\N	\N	None	0	01010000006A12BC218DDE484064AC36FFAF223E40	unsolved	7	999
218	Тестова проблема_400	\N	\N	None	0	01010000006A12BC218DDE484064AC36FFAF223E40	unsolved	7	999
219	Тестова проблема_40	\N	\N	None	0	01010000006A12BC218DDE484064AC36FFAF223E40	unsolved	7	999
220	problem admin	\N	\N	None	0	0101000000909F8D5C37DD48407E1EA33CF3263E40	unsolved	5	999
221	problem admin 1	\N	\N	None	0	01010000007D7555A016DD4840DD79E2395B283E40	unsolved	1	999
222	ghfghfgh	\N	\N	None	0	01010000004D49D6E1E8E44840E8BD3104005B3D40	unsolved	2	999
223	Bad token	\N	\N	None	0	0101000000A14D0E9F74E44840096F0F4240623D40	unsolved	3	999
224	Not full token	\N	\N	None	0	01010000000C3F389F3AE4484092239D8191673D40	unsolved	3	999
225	Very bad token	\N	\N	None	0	0101000000F56915FDA1E34840DEACC1FBAA643D40	unsolved	2	999
226	ffffffff	\N	\N	None	0	0101000000D82AC1E270E248401618B2BAD55B3D40	unsolved	3	999
227	hfghfghgfh	\N	\N	None	0	010100000040BFEFDFBCE04840745DF8C1F9643D40	unsolved	3	999
228	Тестова проблема_444	\N	\N	None	0	01010000006A12BC218DDE484064AC36FFAF223E40	unsolved	7	999
231	Problem with 10 photos	Problem with 10 photos	Problem with 10 photos	None	0	01010000005DC47762D6974940F4DE180280633C40	unsolved	1	999
236	Спаси хорька 3	Хорьок знову страждає	Позбавити страждань	None	0	0101000000FF23D3A1D3BF46400AA2EE0390044140	unsolved	6	999
239	sddd	\N	\N	None	0	0101000000149337C0CC3B4740614F3BFC358D3E40	unsolved	1	999
242	qwe	опис відсутній	\N	5	1	010100000000E2AE5E45664940FBAE08FEB7544140	unsolved	1	999
243	test	123	123	None	0	01010000003F74417DCBF249402635B401D8624040	unsolved	7	999
250	qw	\N	\N	None	2	01010000002E9276A38F3949407E18213CDA803E40	unsolved	7	999
251	harsh	\N	\N	None	0	01010000008B170B43E43A4940F20BAF2479763E40	unsolved	1	999
253	ghdfs	gdfs	gdfs	None	1	010100000086C613419C39494029B3412619813E40	unsolved	6	999
254	Collapse	Everybody suggests me to be normal.	AK-47	None	2	01010000005E6743FE99EB48404B04AA7F10453B40	unsolved	7	999
255	моя проблема1222	Тестzhfhh sht	Вталатутzhhzgh aeraer	3	2	0101000000B69E211CB3664840CF15A58460013E40	unsolved	4	999
257	проблема с телефона 1	Еджеsjjs	Ллллdtys	4	1	0101000000073F7100FDDE4740A1100187504D3E40	unsolved	1	999
258	try	Yet	For	None	0	0101000000B9FE5D9F393B4940904E5DF92C733E40	unsolved	3	999
259	we	Ty	\N	None	0	0101000000F8A57EDE543E49409CA56439096D3E40	unsolved	7	999
260	tr	Tr	\N	None	1	010100000050E3DEFC863D4940D87E32C6876D3E40	unsolved	7	999
261	Вимирання лісу	Пробелема вимирання та забруднення лісу.	Не смітіть у лісі.	None	1	0101000000BF61A2410A704940605B3FFD672D4040	unsolved	1	999
262	ssssss	\N	\N	None	0	01010000008884EFFD0D3A4940BE839F3880763E40	unsolved	7	999
263	typical 	T\n	\N	None	0	010100000042EC4CA1F39E4840F0F96184F0283B40	unsolved	7	999
264	Вимирає ліс	Люди выкидать сміття посеред лісу	Не смітіть у лісі	None	3	01010000003C86C77E16C34940B30A9B012E1C4040	unsolved	1	999
265	dfgdf	dfg	dfg	None	0	01010000004910AE8042CD484099D4D00660DF3A40	unsolved	1	999
266	etrew	ert	ert	None	0	0101000000AD8905BEA2D3484016C3D50110F33A40	unsolved	1	999
267	Загразняют реку	Речка вонючка	Построить очистительные системы	None	0	01010000007A6CCB80B3C848405B0A48FB1FD43A40	unsolved	4	999
268	забруднений ліс	Сміття у лісі	Не смітіть у лісі	None	0	0101000000D28E1B7E378D4840EECF4543C6A73A40	unsolved	1	999
271	Палыч распиздяй	Ебашит сутками в танки!!!	Обрезать нахуй интернет! 	None	2	01010000005B61FA5E433649401B66683C11783E40	unsolved	5	999
\.


--
-- Name: problems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('problems_id_seq', 1, false);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY region (id, name, location) FROM stdin;
999	test	010300000001000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
549	74	2	2015-02-16
550	165	2	2015-02-16
551	140	2	2015-02-16
552	156	1	2015-02-16
553	165	1	2015-02-16
554	165	1	2015-02-16
555	165	1	2015-02-16
556	165	1	2015-02-16
557	165	2	2015-02-16
558	165	2	2015-02-16
559	32	2	2015-02-17
560	183	2	2015-02-17
561	183	2	2015-02-17
562	183	2	2015-02-17
563	47	30	2015-02-17
564	183	30	2015-02-17
565	183	30	2015-02-17
566	183	30	2015-02-17
567	183	30	2015-02-17
568	183	30	2015-02-17
569	183	30	2015-02-17
570	183	2	2015-02-17
571	47	2	2015-02-17
572	1	2	2015-02-17
573	98	2	2015-02-19
574	183	2	2015-02-19
575	2	2	2015-02-19
576	140	2	2015-02-19
577	10	2	2015-02-23
578	52	2	2015-02-26
579	144	1	2015-03-02
580	141	2	2015-03-02
581	98	2	2015-03-03
582	132	32	2015-03-04
583	98	32	2015-03-04
584	52	2	2015-03-04
585	98	2	2015-03-04
586	183	2	2015-03-04
587	157	2	2015-03-04
588	151	2	2015-03-04
589	151	2	2015-03-05
590	73	2	2015-03-05
591	103	33	2015-03-05
592	1	2	2015-03-05
593	74	2	2015-03-10
594	85	2	2015-03-10
595	82	2	2015-03-10
596	21	33	2015-03-10
597	157	2	2015-03-10
598	157	35	2015-03-10
599	1	33	2015-03-10
600	54	2	2015-03-11
601	254	42	2015-03-11
602	183	2	2015-03-11
603	255	1	2015-03-11
604	54	35	2015-03-11
605	54	1	2015-03-11
606	82	1	2015-03-11
607	93	32	2015-03-11
608	250	2	2015-03-11
609	59	2	2015-03-12
610	260	1	2015-03-12
611	250	1	2015-03-12
612	253	2	2015-03-12
613	54	2	2015-03-12
614	242	1	2015-03-12
615	6	2	2015-03-12
616	254	1	2015-03-12
617	52	1	2015-03-12
618	6	2	2015-03-12
619	98	35	2015-03-13
620	129	2	2015-03-13
621	129	33	2015-03-13
622	271	35	2015-03-13
623	264	35	2015-03-17
624	264	1	2015-03-17
625	264	2	2015-03-18
626	257	35	2015-03-27
627	63	2	2015-03-27
628	261	44	2015-03-27
629	73	2	2015-04-02
630	255	35	2015-04-03
631	271	2	2015-04-03
\.


--
-- Name: votes_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('votes_activities_id_seq', 631, true);


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


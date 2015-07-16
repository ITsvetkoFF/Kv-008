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
-- Name: actions; Type: TYPE; Schema: public; Owner: ecouser
--

CREATE TYPE actions AS ENUM (
    'GET',
    'PUT',
    'POST',
    'DELETE'
);


ALTER TYPE public.actions OWNER TO ecouser;

--
-- Name: activitytype; Type: TYPE; Schema: public; Owner: ecouser
--

CREATE TYPE activitytype AS ENUM (
    'ADDED',
    'REMOVED',
    'UPDATED',
    'VOTE'
);


ALTER TYPE public.activitytype OWNER TO ecouser;

--
-- Name: modifiers; Type: TYPE; Schema: public; Owner: ecouser
--

CREATE TYPE modifiers AS ENUM (
    'ANY',
    'OWN',
    'NONE'
);


ALTER TYPE public.modifiers OWNER TO ecouser;

--
-- Name: severitytypes; Type: TYPE; Schema: public; Owner: ecouser
--

CREATE TYPE severitytypes AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5'
);


ALTER TYPE public.severitytypes OWNER TO ecouser;

--
-- Name: status; Type: TYPE; Schema: public; Owner: ecouser
--

CREATE TYPE status AS ENUM (
    'SOLVED',
    'UNSOLVED'
);


ALTER TYPE public.status OWNER TO ecouser;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    content text NOT NULL,
    problem_id integer NOT NULL,
    user_id integer,
    created_date timestamp without time zone NOT NULL,
    modified_date timestamp without time zone,
    modified_user_id integer
);


ALTER TABLE public.comments OWNER TO ecouser;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO ecouser;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: detailed_problem; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE detailed_problem (
    id integer,
    title character varying(200),
    content text,
    proposal text,
    severity severitytypes,
    status status,
    location geography(Geometry,4326),
    problem_type_id integer,
    region_id integer,
    number_of_votes bigint,
    datetime timestamp without time zone,
    first_name character varying(100),
    last_name character varying(100),
    number_of_comments bigint
);


ALTER TABLE public.detailed_problem OWNER TO postgres;

--
-- Name: pages; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    alias character varying(30) NOT NULL,
    title character varying(150) NOT NULL,
    content text NOT NULL,
    is_resource boolean NOT NULL
);


ALTER TABLE public.pages OWNER TO ecouser;

--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pages_id_seq OWNER TO ecouser;

--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE permissions (
    id integer NOT NULL,
    res_name character varying(100) NOT NULL,
    action actions NOT NULL,
    modifier modifiers
);


ALTER TABLE public.permissions OWNER TO ecouser;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO ecouser;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE permissions_id_seq OWNED BY permissions.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE photos (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    datetime timestamp without time zone,
    comment text,
    problem_id integer NOT NULL,
    user_id integer
);


ALTER TABLE public.photos OWNER TO ecouser;

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photos_id_seq OWNER TO ecouser;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: problem_types; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE problem_types (
    id integer NOT NULL,
    type character varying(100) NOT NULL
);


ALTER TABLE public.problem_types OWNER TO ecouser;

--
-- Name: problem_types_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE problem_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.problem_types_id_seq OWNER TO ecouser;

--
-- Name: problem_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE problem_types_id_seq OWNED BY problem_types.id;


--
-- Name: problems; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE problems (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    content text,
    proposal text,
    severity severitytypes,
    location geography(Geometry,4326) NOT NULL,
    status status,
    problem_type_id integer NOT NULL,
    region_id integer
);


ALTER TABLE public.problems OWNER TO ecouser;

--
-- Name: problems_activities; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE problems_activities (
    id integer NOT NULL,
    problem_id integer NOT NULL,
    user_id integer,
    datetime timestamp without time zone NOT NULL,
    activity_type activitytype NOT NULL
);


ALTER TABLE public.problems_activities OWNER TO ecouser;

--
-- Name: problems_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE problems_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.problems_activities_id_seq OWNER TO ecouser;

--
-- Name: problems_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE problems_activities_id_seq OWNED BY problems_activities.id;


--
-- Name: problems_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE problems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.problems_id_seq OWNER TO ecouser;

--
-- Name: problems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE problems_id_seq OWNED BY problems.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE regions (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    location geometry NOT NULL
);


ALTER TABLE public.regions OWNER TO ecouser;

--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.regions_id_seq OWNER TO ecouser;

--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE regions_id_seq OWNED BY regions.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE resources (
    name character varying(100) NOT NULL
);


ALTER TABLE public.resources OWNER TO ecouser;

--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE role_permissions (
    role_name character varying(100) NOT NULL,
    perm_id integer NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO ecouser;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO ecouser;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO ecouser;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: solutions; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE solutions (
    id integer NOT NULL,
    problem_id integer NOT NULL,
    administrator_id integer NOT NULL,
    responsible_id integer NOT NULL
);


ALTER TABLE public.solutions OWNER TO ecouser;

--
-- Name: solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.solutions_id_seq OWNER TO ecouser;

--
-- Name: solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE solutions_id_seq OWNED BY solutions.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE user_roles (
    user_id integer NOT NULL,
    role_name character varying(100) NOT NULL
);


ALTER TABLE public.user_roles OWNER TO ecouser;

--
-- Name: users; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100),
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    region_id integer,
    google_id character varying(100),
    facebook_id character varying(100)
);


ALTER TABLE public.users OWNER TO ecouser;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO ecouser;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY permissions ALTER COLUMN id SET DEFAULT nextval('permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY problem_types ALTER COLUMN id SET DEFAULT nextval('problem_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY problems ALTER COLUMN id SET DEFAULT nextval('problems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY problems_activities ALTER COLUMN id SET DEFAULT nextval('problems_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY regions ALTER COLUMN id SET DEFAULT nextval('regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY solutions ALTER COLUMN id SET DEFAULT nextval('solutions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY comments (id, content, problem_id, user_id, created_date, modified_date, modified_user_id) FROM stdin;
1	Yahooo!	98	14	2014-10-31 12:35:54	\N	\N
2	Для вирішення цієї проблеми Ви можете переглянути розділ "Ресурси" - "Як організувати прибирання в парку". Там детально прописані всі організаційні моменти і поради.\n\nЗ повагою,\n\nКоманда Ecomap.	40	\N	2014-11-16 11:04:10	\N	\N
3	Для початку потрібно перевірити чи є така вирубка незаконною, а вже потім приймати певні міри. Як перевірити законність вирубки і які повинні бути дії по її припиненню, цю інформацію Ви зможете знайти в розділі "Ресурси" - "Як перевірити законність вирубки".\n\nЗ повагою,\n\nКоманда Ecomap.	129	\N	2014-11-16 11:41:10	\N	\N
4	Для початку вирішення цієї проблеми Ви можете переглянути розділ "Ресурси" - "Як перевірити законність вирубки". В ньому дана інформація з приводу, як перевірити і зупинити незаконну вирубку. З повагою, Команда Ecomap.	178	\N	2014-11-16 11:52:48	\N	\N
5	Дивіться розділ "Ресурси" - "Як перевірити законність вирубки". Там Ви зможете отримати потрібну інформацію. З повагою, Команда Ecomap.	89	\N	2014-11-16 11:55:13	\N	\N
6	Як отримати пояснення щодо забудови, до кого звернутися за цією інформацією і які норми розташування підприємств біля житлових комплексів - цю інформацію можна отримати в розділі "Ресурси". З повагою, Команда Ecomap.	255	\N	2014-12-09 11:20:09	\N	\N
7	Дивіться розділ "Ресурси" - "Як боротися із забрудненням від заводів". Там Ви зможете отримати необхідну інформацію, яка допоможе вирішити це питання. З повагою, Команда Ecomap.	26	\N	2015-01-09 08:10:40	\N	\N
8	Дивіться розділ "Ресурси" - "Як боротися із забрудненням від заводів". Там Ви зможете отримати необхідну інформацію, яка допоможе вирішити це питання. З повагою, Команда Ecomap.	54	\N	2015-01-09 08:10:49	\N	\N
9	Попали пацанчики	56	95	2015-02-26 20:47:16	\N	\N
10	*100 тисяч тонн (помилився в заголовку). Якщо бути точнішим то 197,4 тисяч тонн, що мають бути вивезені - за інформацією видання Велика Епоха (EpochTimes.com.ua), якому такі цифри назвали в Департаменті промисловості та розвитку підприємництва при КМДА у відповіді на інформаційний зfпит..	354	145	2015-05-22 12:51:25	\N	\N
11	Два питання: 1. Уподобання штучно накручено? 2. Проблема вирішена?	185	153	2015-06-04 10:55:47	\N	\N
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('comments_id_seq', 12, false);


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY pages (id, alias, title, content, is_resource) FROM stdin;
2	cleaning	Як організувати прибирання в парку?	  <ol>&#10;    <li>Обійди територію парку&#10;      <ol>&#10;        <li>запиши собі місця найбільших засмічень</li>&#10;        <li>вибери місце з гарним орієнтиром для зустрічі з активістами</li>&#10;        <li>вибери місце зручне для під’їзду сміттєвоза</li>&#10;      </ol>&#10;    </li>&#10;    <li>Вибери зручний день і час для проведення прибирання протягом 2-3 годин. Домовся про це з адміністрацією парку, якщо така є</li>&#10;    <li>Домовся із перевізником про вивезення сміття в зазначений день і потрібний час із місця зручного для під’їзду сміттєвоза&#10;      <ol>&#10;        <li>Перевізнику відходів важливо, щоб вони були якісно посортовані ‐ домовся з ним про кількість фракцій і про те, які типи сміття можна класти разом з іншими</li>&#10;        <li>Домовся про мінімальну кількість відходів, яку готовий вивезти перевізник. В середньому за 2-3 години один учасник збирає 3-4 120-літрових пакети зі сміттям. Загалом же більше половини сміття буде змішане (деякі перевізники його не забирають принципово), а все інше буде окремо скло і окремо пластик у різних співвідношеннях (яке залежить від багатьох факторів)</li>&#10;        <li>Перевізнику важливо, щоб про нього написали (на сайті і в соц.мережах), що він зробив таку гарну справу ‐ допоміг вивезти відходи! Підготуйся зробити це і розказати про такі плани на зустрічі з його представником</li>&#10;        <li>Перевізник зможе краще виконати свою частину роботи, якщо матиме на руках карту із точними вказівками, куди їхати. <a href="http://purpose.com.ua/LDU/Maps.doc">Ось приклад</a> такої карти (зроблено за допомогою Google Maps)</li>&#10;      </ol>&#10;    </li>&#10;&#10;    <li>Максимально широко повідом про заплановану акцію&#10;      <ol>&#10;        <li>в різних соціальних мережах</li>&#10;        <li>за допомогою об’яв на дошках для оголошень на будинках навколо парку</li>&#10;        <li>попроси друзів та знайомих поширити запрошення на акцію і прийти самим</li>&#10;        <li>Залучи на акцію найближчі до парку організації ‐ домовся про участь хоча б 5-10 чоловік від кожної:&#10;          <ol>&#10;            <li>школи</li>&#10;            <li>ВНЗ&#10;              <ol>&#10;                <li>За декілька днів до акції обов’язково особисто поговоріть із тими, хто приведе на акцію студентів або школярів ‐ важливо налаштувати цих керівників на позитивне ставлення до акції ‐ щоб вони саме так подавали її своїм підопічним (щоб участь в акції не була зіпсована негативним до неї ставленням!)</li>&#10;              </ol>&#10;            </li>&#10;            <li>громадські організації</li>&#10;            <li>компанії та підприємства&#10;              <ol>&#10;                <li>Організаціям та компаніям часто важливо, щоб про них написали (на сайті і в соц.мережах), що вони зробили таку гарну справу ‐ допомогли провести акцію! Підготуйся зробити це і розказати про такі плани на зустрічі з їх представниками</li>&#10;                <li>Ось приклад <a href="https://docs.google.com/document/pub?id=1DdguRFaLp3Mb5tl4AB4QnEZn2KZNiNi6i3HiPSaG3LQ">партнерської пропозиції</a> і того, що партнер може <a href="https://docs.google.com/document/pub?id=1QMTIpVDrzE3zi8r4mxA4a42awDlUnSh3QHAarmq9IrY">отримати за підтримку</a> акції</li>&#10;              </ol>&#10;            </li>&#10;            <li>відомих людей&#10;              <ol>&#10;                <li>Ось приклад <a href="https://docs.google.com/document/pub?id=1j9k5OZkg9Sq9SUALsDcm5ONga4MkjwcPlF9LEU2h13w">пропозиції для відомої людини</a></li>&#10;              </ol>&#10;            </li>&#10;          </ol>&#10;        </li>&#10;      </ol>&#10;    </li>&#10;  &#10;&#10;    <li>Оціни можливу кількість учасників акції і забезпеч кожного матеріалами для прибирання (іх можна придбати за допомогою організацій з п.5)&#10;      <ol>&#10;        <li>Три пакети для сміття по 120 літрів кожен</li>&#10;        <li>Пара рукавичок з матерії</li>&#10;        <li>не обов’язково 0,5 літрів води</li>&#10;        <li>не обов’язково 1-2 вологих серветки або рідкий антисептик&#10;          <ul>&#10;            <li>Ось <a href="https://docs.google.com/spreadsheet/pub?hl=uk&amp;hl=uk&amp;key=0AiZ6hAt9NrE_dDhuR2hHTGN4NnFhMXFVNTM0QUZOOHc&amp;output=html">приклад розрахунку бюджету</a> акції</li>&#10;          </ul>&#10;        </li>&#10;      </ol>&#10;    </li>&#10;&#10;    <li>Знайди собі 1-2 помічників. Чітко розподіліть між собою ролі під час проведення акції&#10;      <ol>&#10;        <li>інструктаж учасників про роздільний збір сміття і обережність поводження з ним&#10;          <ul>&#10;            <li>Ось <a href="https://docs.google.com/document/pub?id=1EPoVAX8_8m3MIf9p3xBlk9RRprY-Nw2r7qVeb_uW8hc">приклад інструкції для учасників</a> ‐ краще її зачитати вголос (з листочків її не читають)</li>&#10;          </ul>&#10;        </li>&#10;        <li>видача матеріалів для прибирання</li>&#10;        <li>фотографування, запис відео-інтерв’ю</li>&#10;        <li>залучення до прибирання відвідувачів парку</li>&#10;        <li>зв’язок з водієм сміттєвоза</li>&#10;        <li>облік результатів акції (ось приклад анкети для координатораприбирання в парку)&#10;          <ol>&#10;            <li>кількість учасників прибирання ‐ їх краще рахувати під час видачі рукавиць</li><li><span>кількість зібраних пакетів з пластиком</span><br/></li><li><span>кількість зібраних пакетів зі склом</span><br/></li><li><span>кількість зібраних пакетів з іншим сміттям</span></li></ol>&#10;        </li>&#10;      </ol>&#10;    </li>&#10;  &#10;    <li>Проведи акцію</li>&#10;  </ol>&#10;&#10;  <p>Подякуй учасникам (у найкращих і найбільш свідомих бажано взяти контакти для подальшої співпраці) та залученим організаціям. Опублікуй подяку, результати акції, фото та записані відео-інтерв’ю в соціальних мережах і в блогах. Перешли на <a href="mailto:info@letsdoit.org.ua">info@letsdoit.org.ua</a> результати акції та посилання на фотографії та відео.</p>&#10;&#10;  <p>Все про сміття та як з ним боротися знає аполітична некомерційна громадська ініціатива «Зробимо Україну чистою!», частина Всесвітнього руху <a href="http://letsdoitworld.org">&#34;Let’s do it!&#34; (http://letsdoitworld.org)</a>.</p>&#10;&#10;  <p>Мета ініціативи ‐ докорінно змінити ставлення українців до життєвого простору, прищепити в суспільстві потребу не смітити та дбати про довкілля. Досягти її можна, змінивши повсякденні звички людей ‐ шляхом дій, спрямованих на створення в Україні чистоти і краси (працюючи над вирішенням проблеми, людина стає частиною рішення).</p>&#10;&#10;  <a href="http://letsdoit.org.ua/">http://letsdoit.org.ua/</a>&#10;	t
3	removing	Як добитись ліквідації незаконного звалища?	  <p>В Україні існують десятки тисяч несанкціонованих звалищ побутових або будівельних відходів. Більшість таких звалищ розміщені  на природних ділянках, особливо  часто ‐ в ярах, балках, на узліссях і берегах річок.</p>&#10;  &#10;  <p>Звалища являють собою ділянки землі, на яких безконтрольно зберігаються побутові відходи. Часто для зменшення об’єму відходів звалища підпалюють. Такий підхід є неприпустимим, оскільки звалища є серйозним джерелом забруднення повітря та грунтових вод. Жоден з таких самовільно створених пунктів скидання відходів не обладнаний відповідним чином, продукти гниття і розпаду потрапляють у ґрунт і ґрунтові води. Температура гниття подекуди настільки висока, що часто легко призводить до їх займання, до того ж у повітря викидається неймовірна кількість шкідливих речовин.</p>&#10;&#10;  <p>Згідно законодавства України про відходи, відповідальність за відходи перш за все покладається на власника відходів.</p>&#10;&#10;  <p>Стаття 12 Закону визначає, що відходи без власника визначаються як безхазяйні. У випадку, якщо безхазяйні відходи виявлено на земельній ділянці, яка належить приватній особі, ця особа зобов’язана повідомити про ці відходи органи влади, які, в свою чергу, повинні вжити заходів для визначення власника відходів, класу їх небезпеки, здійснення обліку цих відходів та прийняти рішення щодо поводження з ними.</p>&#10;&#10;  <p>Стаття 9. предбачає, що безхазяйні відходи, які знаходяться на об’єктах територіальної громади, є власністю цієї територіальної громади. Власником безхазяйних відходів, які знаходяться на території України, однак не належать до власності територіальної громади, вважається держава.</p>&#10;&#10;  <p>Іншими словами, якщо власника безхазяйних відходів неможливо визначити, то держава або місцеві органи самоврядування беруть на себе відповідальність за такі відходи способом, визначеним в Статті 9 та Статті 12.</p>&#10;&#10;  <p>Щоб побороти таке порушення, необхідно відправити поштою кілька листів.</p>&#10;  &#10;  <p>Зразок листа дивіться нижче. У доданому нижче зразку заповніть пропуски та замініть підкреслені слова на Ваші дані. По кожному сміттєзвалищу треба окремий лист і картинка в додаток (фото і карта де знаходиться звалище; можна принтскрін з Гуглкарт, Яндекскарт тощо).<br/><br/>&#10;&#10;  <a href="/docs/official-letter-to-clear-up-illegal-dump.docx">Завантажити зразок листа (Word Document)</a></p>&#10;&#10;  <p>Інформація надана Національним екологічним центром України <a href="http://necu.org.ua/">http://necu.org.ua/</a></p>&#10;	t
4	stopping-exploitation	Як зупинити комерційну експлуатацію тварин?	  <p>Дуже часто в туристичних містах людям пропонують сфотографуватись з тваринами, найчастіше це хижі птахи і сови. Більшість видів хижих птахів в Україні занесені до Червоної книги України. Крім того, така діяльність є жорстоким поводженням з птахами.</p>\n\n  <p>Щоб побороти таке порушення, необхідно відправити поштою кілька листів.</p>\n\n  <p>Зразок листа дивіться нижче. По кожному випадку треба окремий лист і фотографія в додаток. У доданому нижче зразку заповніть пропуски та замініть підкреслені слова на Ваші дані.<br/><br/>\n\n  <a href="/docs/official-letter-to-stop-animal-exploitation.docx">Качнути зразок листа (Word Document)</a></p>\n\n  <p>Інформація надана Національним екологічним центром України <a href="http://necu.org.ua/">http://necu.org.ua/</a></p>\n	t
5	stopping-trade	Торгують первоцвітами - телефонуй: "102-187!"	  <p>Активісти природоохоронних організацій закликають кожного не бути байдужим до нищення зникаючих видів рослин та викликати міліцію кожного разу, коли ви бачите торгівлю первоцвітами. Ми впевнені, що громадяни мають бути свідомими і не допускати порушення законодавства, міліція має виконувати свої обв’язки, а порушники мають отримати передбачене покарання.</p>&#10;&#10;  <p>Всі види підсніжників і більшість інших ранньоквітучих рослин зникають в природі через торгівлю букетами з їх квітів і тому занесені до Червоної книги. Те саме стосується і черемші. Збір та торгівля первоцвітами в Україні заборонені низкою законів, зокрема, законом «Про Червону книгу України» та законом «Про рослинний світ». На порушників накладається штраф відповідно до статей 88-1 та 160 Кодексу України про адміністративні правопорушення. Також за кожну рослину нараховуються збитки, нанесені державі її знищенням.</p>&#10;&#10;  <p>Що робити? Кожен з нас має усвідомити особисту відповідальність у справі збереження рідкісних видів рослин. Головне, не бути байдужим і не проходити повз порушників; у разі виявлення фактів торгівлі первоцвітами потрібно обов’язково звертатись по допомогу до працівників міліції, якщо вони є поруч, або телефонувати 102 та викликати підрозділ ППС на місце незаконної торгівлі. Міліція зобов’язана реагувати на подібні виклики, зокрема, у рамках операції «Первоцвіт», яка триває в Україні. Міліціонер повинен зупинити торгівлю і  бажано ‐ вилучити або знищити квіти.</p>&#10;&#10;  <p>Знищення букетів не є чимось аморальним. Кожен роздрібний торгівець купує зранку квіти на вокзалі у оптовиків, які привезли їх у велике місто з Криму або Карпат, витрачаючи кілька тисяч гривень на оптову партію. Вилучення букетів гарантує матеріальний удар по порушнику, що відбиває бажання наступного дня повторити протиправну торгівлю.</p>&#10;&#10;  <p>Інформація для журналістів. Практика показує, що працівники міліції дуже старанно виконують свої обов’язки, коли їх про це просить людина з посвідченням журналіста.</p>&#10;&#10;  <p>Інформація надана Національним екологічним центром України <a href="http://necu.org.ua/">http://necu.org.ua/</a></p>&#10;	t
6	cruel	Зупинити жорстке поводження з тваринами	<p><span>Питання жорстокого поводження з тваринами не обмежується завданням тілесних ушкоджень. Жорстоким поводженням може визнаватись і неналежні умови утримання, і недостатнє харчування. Щодо умов утримання, то є чіткі мінімальні норми. </span><br/></p><p>Як приклад, норма на ведмедя - 30 метрів квадратних (мінімальна), те що менше - жорстоке поводження.</p><p>Можуть бути й інша зачіпки - тому треба працювати по кожному випадку окремо.</p><p><b>Процедура</b><span> - громадяни роблять звернення для проведення перевірки до Держекоінспекції з вимогою провести перевірку умов утримання червонокнижного виду. А далі у випадку кримінального провадження - до міліції,прокуратури, адміністративне здійснює екоінспекція.</span><br/></p><p>Можуть бути ще особливості, пов'язані з об'єктом утримання тварини.</p><p><br/></p><p></p>	t
8	green-zone	Як захистити зелені зони від забудови?	<p>Знесення та пересадка дерев, чагарників, газонів, квітників може здійснюватися лише в разі наявності спеціального дозволу (ордера). Ордер видається на підставі акта обстеження зелених насаджень, погодженого з Державним управлінням екології та природних, і рішення міської або районної адміністрації.</p><p><b><br/></b></p><p><b>Якщо Ви хочете захистити свій улюблений сквер чи парк, Ви повинні:</b></p><p>1. З'ясувати офіційний статус вашої зеленої зони.</p><p>2. Якщо вирубку зелених насаджень розпочато, Ви маєте право перевірити наявність <br/></p><p>                           - <u>акту обстеження зелених насаджень</u>  (дерев, чагарників, газонів, парків, лісопарків, насаджень санітарно-захисних зон), що підлягають знесенню чи пересаджуванню в зв’язку із забудовою та впорядкуванням земельних площ. В акті обстеження зелених насаджень указується дата його складання; склад комісії, що проводив обстеження; найменування органу, який призначив комісію, із зазначенням номера і дати розпорядження або наказу про її призначення, голови комісії; адреса об’єкта, де проводилось обстеження зелених насаджень. Унаслідок обстеження зелених насаджень в акті складається таблиця, в якій указується кількість, вид зелених насаджень, вік, діаметр стовбура на висоті 1,3 метри від землі, якісний стан зелених насаджень (хороший, задовільний, незадовільний), та зазначається, які насадження підлягають зрізуванню чи пересаджуванню; вказується відновлювальна вартість зелених насаджень. Акт підписується головою та всіма членами комісії, завіряється печаткою.<br/></p><p>                           - <u>ордеру на знесення зелених насаджень.</u> Ордер на знесення зелених насаджень видається на підставі рішення (розпорядження) районної державної адміністрації (в ордері вказується номер та дата прийняття цього рішення чи розпорядження) та на підставі акта обстеження зелених насаджень (в ордері вказується номер та дата його підписання). В цьому документі встановлюється строк вирубки (тобто вказується число, до якого рубка має завершитися) та напрямок використання деревини.<br/></p><p>Акт та ордер оформлюються управлінням зеленої зони відповідно до вимог додатків 3 і 2 <a href="http://zakon1.rada.gov.ua/laws/show/z0880-06/page">Правил утримання зелених насаджень міст та інших населених пунктів України</a>. Акт також має бути погодженим Державним управлінням екології та природних ресурсів на місцях, що засвідчується підписом начальника управління, завіреного печаткою управління. У разі їх відсутності негайно викликайте представників  <u>природоохоронної прокуратури</u> на місцях з проханням виїхати на місце до представників скаржників.<br/>Паралельно слід звернутися до <u>Державного управління екології та природних ресурсів</u> для з’ясування того, чи погоджували вони ордер на рубку. Якщо ордер ними не погоджувався – значить, він не дійсний.<br/><br/></p><p>3. З'ясувати в адміністрації,  чи відповідає землевідведення у Вашій зеленій зоні Генеральному плану розвитку міста. В разі невідповідності зверніться до природоохоронної прокуратури або до суду з проханням скасувати це землевідведення.</p><p><br/></p><p><b>Як з’ясувати офіційний статус зеленої зони в містобудівній документації, насамперед у Генеральному плані розвитку?</b></p><p>Необхідно направити інформаційний запит (це право надане Вам статтею 32 Закону України «Про інформацію») на адресу державної адміністрації.</p><p><b>Шаблони запитів</b></p><table style="width: 565px;" width="565" border="1" cellpadding="0" cellspacing="1">&#10;&#9;<tbody>&#10;&#9;&#9;<tr>&#10;&#9;&#9;&#9;<td style="width: 48.0%;height: 346px;">&#10;&#9;&#9;&#9;&#9;<p> Головному архітектору</p>&#10;&#9;&#9;&#9;&#9;<p> АТ «Київпроект» –</p>&#10;&#9;&#9;&#9;&#9;<p> директору</p>&#10;&#9;&#9;&#9;&#9;<p> ДП «Інститут Київгенплан»</p>&#10;&#9;&#9;&#9;&#9;<p> Чекмарьову В. Г.</p>&#10;&#9;&#9;&#9;&#9;<p> Ваше П.І.Б.,</p>&#10;&#9;&#9;&#9;&#9;<p> Ваша повна поштова адреса</p>&#10;&#9;&#9;&#9;&#9;<p> Інформаційний запит</p>&#10;&#9;&#9;&#9;&#9;<p> Шановний Володимире Гнатовичу!</p>&#10;&#9;&#9;&#9;&#9;<p> Прошу Вас надати довідку щодо  статусу, функціонального призначення  та цільового використання території  (наприклад: обмеженої з двох сторін  вул. Миколи Амосова, з третьої – вул.  Протасів Яр, з четвертої – вул.  Солом’янською; приблизною площею  30 га в Солом’янському районі м.  Києва) в Генеральному плані розвитку  м. Києва до 2020 року.</p>&#10;&#9;&#9;&#9;&#9;<p> Додаток: (викопіювання із будь-якої  карти м. Києва, де Вами обведена  територія, якою ви цікавитеся).</p>&#10;&#9;&#9;&#9;&#9;<p> Дата Ваш підпис</p>&#10;&#9;&#9;&#9;</td>&#10;&#9;&#9;&#9;<td style="width: 52.0%;height: 346px;">&#10;&#9;&#9;&#9;&#9;<p style="text-align: right;">Київському міському голові </p>&#10;&#9;&#9;&#9;&#9;<p style="text-align: right;">Кличко В. В. </p>&#10;&#9;&#9;&#9;&#9;<p style="text-align: right;">Ваше П.І.Б., </p>&#10;&#9;&#9;&#9;&#9;<p style="text-align: right;">Ваша повна поштова адреса </p>&#10;&#9;&#9;&#9;&#9;<p> Інформаційний запит</p>&#10;&#9;&#9;&#9;&#9;<p> Шановний Віталій Володимировичу!</p>&#10;&#9;&#9;&#9;&#9;<p> Прошу Вас надати довідку з державного  земельного кадастру щодо території  (описати місцезнаходження території та  по можливості її приблизну площу,  вказавши, в якому адміністративному  районі м. Києва вона знаходиться).</p>&#10;&#9;&#9;&#9;&#9;<p> Додаток: (викопіювання із будь-якої карти  м. Києва, де Вами обведена територія,  якою ви цікавитеся).</p>&#10;&#9;&#9;&#9;&#9;<p> Дата</p>&#10;&#9;&#9;&#9;&#9;<p> Ваш підпис</p>&#10;&#9;&#9;&#9;</td>&#10;&#9;&#9;</tr>&#10;&#9;</tbody>&#10;</table>&#10;<p> </p>&#10;<p></p><p><span>Відповідь на такий інформаційний запит згідно зі ст. 33 Закону України «Про інформацію» має Вам надійти <b>протягом місяця</b>. В разі, якщо відповідь не надійшла протягом цього терміну, варто зателефонувати до канцелярії (або відділу по роботі зі зверненнями громадян) установи, до якої Ви звертались, і з’ясувати, коли Вам нададуть відповідь.</span><br/></p><p>Якщо після цього Ви так і не дочекалися відповіді, треба направити повторний інформаційний запит.</p><p>Паралельно із цим необхідно звернутися до Прокуратури міста та управління Служби безпеки України в із заявою щодо порушення посадовою особою ст. 5 закону «Про боротьбу з корупцією» та ненадання Вам публічної інформації.</p><p>Дії з ненадання інформації, якщо вони не становлять складу злочину, підлягають покаранню адміністративним стягненням у формі штрафу, а повторне ненадання інформації протягом року загрожує штрафом та звільненням із посади (ст. 8 закону «Про боротьбу з корупцією»).</p><p><b>Які є статуси зелених зон?</b></p><p>Відповідно до наказу Державного комітету України по житлово-комунальному господарству «Про затвердження Правил утримання зелених насаджень міст та інших населених пунктів України» № 70 від 29 липня 1994 р. міські озеленені території діляться за функціональними ознаками на три групи:</p><p>- <u>території загального користування</u> – міські та районні парки, парки культури і відпочинку, сади житлових районів і груп житлових будинків, сквери, бульвари, набережні, лісопарки, лугопарки, гідропарки та інші;</p><p>- <u>території обмеженого користування</u> – насадження на територіях громадських і житлових будівель, шкіл, дитячих закладів, спортивних споруд, закладів охорони здоров'я, промислових підприємств, складських територій та інші;</p><p>- <u>території спеціального призначення</u> – насадження вздовж вулиць, у санітарно-захисних та охоронних зонах, на територіях ботанічних і зоологічних садів, виставок, кладовищ і крематоріїв, ліній електропередач високої напруги; лісомеліоративні насадження; насадження розсадників, квітникарських господарств; пришляхові насадження в межах міст та інших населених пунктів.</p><p><b>! </b>Термін &#34;зелені насадження&#34; стосується дерев та кущів, але жодним чином не стосується території чи конкретної земельної ділянки. Тому коли йдеться про статус зеленої зони, необхідно користуватися юридичним терміном – &#34;озеленені території&#34;.</p><p>Якщо ваша зелена зона – озеленена територія загального користування (якщо її площа складає понад 2,0 га – це парк, від 0,05 до 2,0 га – сквер) з вільним доступом, призначена для відпочинку міського населення, то будівництво житла, офісних приміщень, автостоянок та автозаправок без зміни статусу цієї території є неправомірним, оскільки:</p><p>Відповідно до ДБН 360–92** «Містобудування. Планування та забудова міських і сільських поселень» розміщення будівель, споруд і комунікацій не допускається (пункт 10.4):</p><p>- на землях заказників, природних національних парків, ботанічних садів, дендрологічних парків та водоохоронних зон;</p><p>- на землях зелених зон міст, включаючи землі міських лісів, якщо об’єкти, що проектуються, не призначені для відпочинку, спорту чи обслуговування приміського лісового господарства.</p><p>Відповідно до Правил утримання озеленених територій міст та інших населених пунктів України на території озеленених територій забороняється (пункт 3.6):</p><p>- вести будь-яке будівництво, у тому числі і павільйонів для торгівлі, розміщення малих форм архітектури без погодження (рішення) місцевих органів державної виконавчої влади;</p><p>- обладнувати стоянки автомашин, мотоциклів, велосипедів та інших транспортних засобів (якщо це призводить до пошкодження зелених насаджень, квітників та газонів);</p><p>- складувати будь-які матеріали.</p><p><br/></p>	t
9	illegal	Як зупинити незаконну забудову?	<p>Незаконні забудови — одна з найболючіших проблем жителів середніх та великих українських міст. Зневірені в ефективності будь-якого протесту проти дій забудовників, громадяни у кращому випадку звертаються за допомогою до громадських організацій чи політичних партій (які протестну енергію можуть використовувати у корисливих цілях), а в гіршому — просто безсило спостерігають за тим, як на місці дитячого майданчику чи скверу поряд з їхнім будинком виростає багатоповерхівка чи торговельно-розважальний монстр із заліза та бетону.</p><p>Отже, якщо поряд з вашим будинком поставили паркан та починають завозити будівельні матеріали, а вам це зовсім не до смаку, то вам потрібно:</p><p><i>Створити ініціативну групу.</i> Зрозумійте, що самотужки ви нічого змінити не зможете. При цьому не варто очікувати, що сусіди з великим ентузіазмом сприймуть ваші ідеї — розчарування в громадянській активності, породжене безліччю продажних пікетів та «майданів», занадто велике. Тому на початку вас буде підтримувати лічена кількість однодумців. Проте ваш щонайменший успіх у боротьбі із забудовою одразу призведе до зростання числа активістів.</p><p><i>Перевірити законність будівництва.</i> Згідно зі статтею 376 Цивільного кодексу України, будівництво є законним лише за наступних умов: воно здійснюється на спеціально відведеній для цього ділянці, має всі необхідні дозволи, проходить у цілковитій відповідності з проектом і без порушення стандартних будівельних норм і правил та за умови позитивного вердикту громадських слухань. У <a href="http://zakon0.rada.gov.ua/laws/show/1699-14">Законі України &#34;Про планування і забудову територій&#34;</a>, ст. 23 написано: &#34;Планування окремої земельної ділянки, побудова на ньому будинків і споруд власниками або користувачами здійснюється з урахуванням інтересів інших власників або користувачів земельних ділянок, будинків і споруд”.  Недотримання будь-якої з цих вимог призводить до оголошення будівництва самочинним, після чого воно підлягає знесенню за рахунок забудовника.<b> Звертатися необхідно до місцевої адміністрації </b>та <a href="http://www.dabi.gov.ua/">управління державного архітектурно-будівельного контролю</a> (гаряча лінія: 0-800-210-011). У разі істотного відхилення від проекту, яке порушує суспільні інтереси, суд за позовом відповідного органу державної влади чи місцевого самоврядування може змусити забудовника провести перебудову. Позивачами у такій справі можуть бути лише вищезазначені органи. Звідси порада: з самого початку боротьби проінформуйте про неї місцеву владу, наприклад, написавши листа і підкріпивши його якомога більшою кількістю підписів місцевих жителів.</p><p>У будь-якому разі вам необхідно буде розширювати коло учасників протесту. Для цього знаходьте своїх «колег по нещастю» в інших районах міста, проводьте збори, обмінюйтесь досвідом. Розширення числа активістів неодмінно породить проблему лідерства. Але практика свідчить, що антизабудовні кампанії є більш ефективними, коли не мають конкретних лідерів, яких можна підкупити чи іншим чином нейтралізувати. Обмежтеся колом взаємозамінних координаторів, але всі важливі рішення ухвалюйте винятково загальними зборами.</p><p>Низовий рух, який стрімко розширюється, неодмінно приверне увагу громадських організацій та (особливо!) політичних партій. Так чи інакше вони будуть намагатися використати вас у своїх цілях. Вам важливо цього не допустити, натомість зробити те саме з ними. Партії та організації часто володіють вкрай необхідними для вас ресурсами, насамперед організаційними, і можуть бути корисними. Але в будь-якому разі співпрацюйте з ними обережно і одразу припиняйте співпрацю, якщо помічаєте з їхнього боку відвертий піар. Конфіденційною інформацією намагайтеся особливо не ділитися — немає жодної гарантії, що за певну винагороду від забудовника вони елементарно не «здадуть» йому всі дані.</p><p><i>Час грає на вашу користь.</i> Будь-яке затягування процесу забудови — вам на руку. В умовах економічної кризи та жорсткої конкуренції забудовник не зможе дозволити довгий простій якогось об’єкту, до якого ви його змушуєте, і йому доведеться відступити.</p><p><br/></p>&#10;&#10;<br/>	t
10	fir-tree	Як відрізнити браконьєрську ялинку?	<p><br/></p><p>Усі новорічні дерева, відповідно то розпорядження КМУ від 16 вересня 2009 р №1090-р., повинні мати чіпи та маркування на зрізі. </p><p><span>Без цих ознак дерево вважається браконьєрським. </span><span>У разі виявлення таких фактів необхідно телефонувати на гарячу лінію у відділ лісової охорони. </span></p><p>Телефони: 587-63-73, 587-73-83, 066-222-99-00</p><p> <b>На сайті yalynka.info можна ввести номер з чіпа ялинки та перевірити його автентичність та походження дерева.</b></p><p><b>Це ж можна зробити, зателефонувавши на номер 451-20-12.</b></p><p><span>Відповідно до Наказу ДАЛР та МВС у разі виявлення точок продажу нелегальних дерев, міліція має вживати дії щодо припинення такої торгівлі та притягнення винних до відповідальності. Штрафи нараховуються відповідно до ст. 65 КУпАП (85-204гр.) та згідно постанови КМУ №665, де сума штрафу нараховується відповідно до діаметра стовбура (189-1753 гр.)</span></p><p>Інформація надана Національним екологічним центром України <a href="http://necu.org.ua/">http://necu.org.ua/</a></p><p><br/></p>	t
11	pollution	Як боротися із забрудненням від заводів?	<p><br/></p><p>Найбільш ефективним методом відстоювання своїх інтересів та інтересів громадян є суд. До якого можна звернутися з позовом на організацію, яка завдає шкоди навколишньому середовищу і здоров’ю населення. За для того щоб підтвердити <b>факт РЕАЛЬНОГО забруднення, організація повинна пройти екологічну експертизу</b>, проведення якої можливо добитися через суд. І на основі цього, буде можливим зобов'язати організацію встановити додаткові фільтри очистки, перенести виробництво в інше місце, виплатити компенсацію потерпілим громадянам і т.п. </p><p>Екологічна експертиза є процесом встановлення відповідності господарської або який-небудь іншої діяльності нормам екологічних вимог. Вона здійснюється для того, щоб запобігти негативний вплив цієї діяльності на природу. Іншими словами, сама сутність такої експертизи полягає в попередньому, тобто на стадії розробки проекту та прийняття рішення перевірці всіх відповідностей господарської діяльності деяким екологічним стандартам. А основна мета - запобігання шкідливих екологічних наслідків дій компанії або організації.</p><p><b>В основному в залежності від організації і перевірки, ця експертиза ділиться на два типи: державна і громадська</b>.</p><p><span>Державна здійснюється спеціальним органом. Право на проведення екологічної експертизи залежить тільки від Державного комітету з охорони навколишнього середовища, а також її територіальним органам, який виконує такі ж функції. Тільки вони можуть призначати таку експертизу і контролювати її. Така процедура може проводиться на двох рівнях - державному і суб'єктивному.</span></p><p><span>Що стосується громадської екологічної експертизи, то вона може здійснюється за ініціативою громадян або будь-яких організацій. До того ж така процедура може відбуватися за наказом органів місцевого самоврядування громадськими організаціями основний напрямок яких захищати навколишнє середовище від згубного впливу на неї людини.</span></p><p>Державна здійснюється у встановлених <a href="http://zakon4.rada.gov.ua/laws/show/45/95-%D0%B2%D1%80">Законом України &#34;Про екологічну експертизу&#34;</a> випадках, а громадська в ініціативному порядку. Крім цього ці дві експертизи можуть проводиться одночасно.<br/></p><p><span>Всі стадії здійснення цього процесу тонко врегульовані законодавством держави. Результатом цієї діяльності стає висновок екологічної експертизи, тобто документ, який показує результати перевірки і він містить висновки про допустимість впливу на середовище цієї діяльності.</span><br/></p><p>Отже, щоб добитися екологічної експертизи Ви можете звернутися з позовом до суду, який на основі цього позову може організувати екологічну експертизу підприємства чи звернутися до організації, яка займається такою діяльністю.</p><p><br/></p>	t
12	ios-app	iOS App	<p>14 квітня 2015 року вийшла перша версія <a href="https://itunes.apple.com/ua/app/ecomap-ukraine/id971673693?mt=8" target="_blank">ecomap:ukraine</a> для iOS пристроїв!</p><p>Тепер ви можете швидко та зручно додавати проблеми з вашого мобільного.</p><p><br/></p>	t
14	about	Про проект	<p>Дуже часто про локальні проблеми знають тільки місцеві організації та декілька сот жителів. А як було б добре підключити до їх вирішення однодумців з інших частин країни!</p><p><span>Цей проект замислювався Всесвітнім фондом природи в Україні як платформа, здатна об’єднати зусилля громадян, різних неурядових організацій та компаній для обміну досвідом та покращення стану навколишнього середовища в Україні.</span><br/></p><p><span>Ви можете позначити екологічну проблему на карті, дізнатися у розділі Ресурси про те, як її вирішити та разом з однодумцями взятися до справи. Або долучитися до вирішення інших проблем у різних куточках України. Якщо Вам необхідна додаткова інформація, надішліть нам лист із запитом. Якщо у Вас є досвід, поділіться ним! Майбутнє країни у наших руках!</span><br/></p><p><span>До вирішення 3-х найважливіших проблем (за результатами голосування) долучиться безпосередньо команда WWF в Україні.</span><br/></p><p><span>Практичну реалізацію проект отримав, як і всі добрі починання, силами активних та небайдужих людей. Початковий варіант цього сайту був написаний 3-ма людьми за 48 годин в межах доброчинного хакатону Hack4Good.</span><br/></p><p><span>Післі того екологічна карта була повністю оновлена та дороблена командою молодих програмістів IT Академії компанії SoftServe під керівництвом Ігоря Цвєткова. Дякуємо всім активістам за допомогу в реалізації цього корисного проекту!</span><br/></p><p><span>Але нам також потрібна Ваша посильна допомога для підтримки та покращення екокарти. Долучайтесь!</span><br/></p><p><span>Якщо Ви вмілий програміст і бажаєте допомагати в розвитку проекту – ми будемо раді бачити Вас в нашій команді;</span><br/></p><p><span>Якщо Ви маєте зауваження чи побажання щодо розширення функціональності проекту;</span><br/></p><p><span>Ми також шукаємо людей для наповнення інформаційної секції «Ресурси»;</span><br/></p><p><span>На початковій стадії запуску цього сервісу кожний активний користувач для нас на вагу золота, тож люб’язно просимо нас лайкати і про нас щебетати.</span><br/></p><p><span>Що більше людей та організацій долучаться, то більше ми зможемо зробити для природи України!</span><br/></p><p><span><br/></span></p><p><span>Контакти</span><br/></p><p><span>Oлександра Ковбаско: alex.kovbasko@gmail.com</span><br/></p><p><span>Дмитро Григор'єв: grigorev007@gmail.com</span><br/></p>	t
\.


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('pages_id_seq', 15, false);


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY permissions (id, res_name, action, modifier) FROM stdin;
1	UsersHandler	GET	ANY
2	UserHandler	GET	OWN
3	UserHandler	PUT	OWN
4	UserHandler	DELETE	OWN
5	UserHandler	GET	ANY
6	UserHandler	PUT	ANY
7	UserHandler	DELETE	ANY
8	ProblemsHandler	POST	ANY
9	ProblemHandler	PUT	OWN
10	ProblemHandler	DELETE	OWN
11	ProblemHandler	PUT	ANY
12	ProblemHandler	DELETE	ANY
13	VoteHandler	POST	ANY
14	ProblemPhotosHandler	POST	OWN
15	ProblemPhotosHandler	POST	ANY
16	ProblemCommentsHandler	POST	OWN
17	ProblemCommentsHandler	POST	ANY
18	PagesHandler	POST	ANY
19	PageHandler	PUT	ANY
20	PageHandler	DELETE	ANY
21	CommentHandler	PUT	OWN
22	CommentHandler	DELETE	OWN
23	CommentHandler	PUT	ANY
24	CommentHandler	DELETE	ANY
25	PhotoHandler	PUT	OWN
26	PhotoHandler	DELETE	OWN
27	PhotoHandler	PUT	ANY
28	PhotoHandler	DELETE	ANY
29	PermissionHandler	GET	NONE
30	PermissionHandler	POST	NONE
31	PermissionHandler	GET	ANY
32	PermissionHandler	POST	ANY
33	RoleHandler	GET	NONE
34	RoleHandler	POST	NONE
35	RoleHandler	GET	ANY
36	RoleHandler	POST	ANY
37	UsersHandler	GET	NONE
38	PagesHandler	POST	NONE
39	ProblemPhotosHandler	POST	NONE
40	ProblemCommentsHandler	POST	NONE
41	ProblemsHandler	POST	NONE
42	VoteHandler	POST	NONE
43	PageHandler	PUT	NONE
44	PageHandler	DELETE	NONE
\.


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('permissions_id_seq', 44, true);


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY photos (id, name, datetime, comment, problem_id, user_id) FROM stdin;
73	1e8f19e11c1c706b41bd44f71b5d1e68.jpg	\N	test	56	\N
74	9b5089e7c3c3d7d28bdfb9edb5201807.jpg	\N	test	18	\N
75	bcc557550b1b0e2140ca1b1a7a7b7f6b.jpg	\N	test1	56	\N
83	3d9ea5059b037de3f5ad962b11d5d3a9.JPG	\N	Студенти Бродівського педколеджу долучилися до акції "Зробимо Україну чистою 2014"	185	\N
84	e6540e335f4e74eb605bcc2ca9f6f8a5.JPG	\N	Ми прибираємо для них...	185	\N
101	471f8e531e008c5ff74217f1c97baccf.jpg	\N	Заставка акції СТОП ЗАВОД в Узині; портал www.uzyn.com.ua	25	\N
102	595a8553bafd3ea3be3943fdba2b1aa9.jpg	\N	Струба Узинського цукрового заводу	25	\N
103	ae2659f867283e45a705a13c7c08021f.JPG	\N	Плакати акції СТОП ЗАВОД в Узині; портал www.uzyn.com.ua	25	\N
116	ec8392de123deac7c17be81f976d1ee8.jpg	\N	\N	185	\N
117	477e3ec969fc5a46d8c4416ed4b8fe66.jpg	\N	\N	185	\N
129	829024a08b0de129df62b6551d01ff13.jpg	\N	\N	354	\N
\.


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('photos_id_seq', 130, false);


--
-- Data for Name: problem_types; Type: TABLE DATA; Schema: public; Owner: ecouser
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
-- Name: problem_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('problem_types_id_seq', 8, false);


--
-- Data for Name: problems; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY problems (id, title, content, proposal, severity, location, status, problem_type_id, region_id) FROM stdin;
175	Бездомные животные	Достаточное количество бездомных собак	Увеличить бюджет города по охране окр среды и уходу за бездомными животными	3	0101000020E61000009F02603C837C47406F48A30227054040	UNSOLVED	7	1
3	Сабарівський ліс	В місті Вінниця в мікрорайоні Сабарів ліс та берег Південного Бугу просто завалений сміттям!!! І з кожним роком все більше і більше!!!	Організувати акцію по прибиранню цієї території.	3	0101000020E610000012876C205D984840F3AB394030733C40	UNSOLVED	1	1
2	Китайський мега-порт	Он может стать петлей для Крыма, он - смертный приговор для нашего любимого полуострова.	Пожалуйста, поддержите петицию о недопустимости строительства китайского мега-порта в Крыму:\nhttps://secure.avaaz.org/ru/petition/Prezidentu_Ukrai..nu_otmenit_dogovorennosti_o_stroitelstve_kitayskogo_megaporta/ 	3	0101000020E6100000D4D688601C9046403735D07CCECD4040	UNSOLVED	4	1
4	Спасите Древний могучий Днепр!	Река Днепр, некогда судоходная, в связи со строительством плотин, интенсивным технологическим использованием и изменениями климата, убийственно цветет в летние месяцы и убивает в себе все живое, перестает быть источником питьевой воды и колыбелью Приднепровья.	Государственная программа, выделение денег из госбюджета, чистка и углубление дна реки.	3	0101000020E6100000A298BC01663E484092B1DAFCBF884140	UNSOLVED	4	1
5	Загрязнение Днепра	В городе Берислав нет очистных сооружений.		3	0101000020E6100000265305A3926A47406D0377A04EB54040	UNSOLVED	4	1
6	Знищення гніздівель ластівок, Чубинське, Бориспільський район	Бориспільський район, Чубинське (колишній хутір Чубинських. Автора слів гімну України), Яблунева 6а. Зруйновані гнізда ластівки міської. За підрахунками більше  50 гнізд. Зроблено за наказом власника розважального комплексу "Чубинське". За його словами, ластівки гадять і якщо комусь не подобається, то можуть забрати всі ці гнізда додому. Залишки гнізд, між іншим, в той час вже валялись під дахом комплексу. А крановщики, які виконували наказ і, як зрозуміло, своєї думки не мали, тикали пальцями у власника: "Нічого не знаємо... наша хата з краю"	Інформацію було розповсюджено серед ЗМІ, яке активно відреагувало. Приклади новин можна знайти http://www.socportal.info/news/direktor-magazinu-vbiv-200-ptashenyat-last, http://chask.net/?p=16110, http://weather.tsn.ua/ukrayina/na-kiyivschini-budivelniki-znischili-bilshe-50-lastivchinih-gnizd-zaradi-maybutnogo-trc-298037.html, http://podrobnosti.ua/podrobnosti/2013/06/14/911232.html. На власника було подано звернення до Міністерства внутрішніх справ України з проханням порушити відповідну кримінальну справу відносно власника комплексу.  Справу "зам\\'яли", але власник ТРЦ знову гніздівлі вже не руйнував.	3	0101000020E6100000C443183F8D31494072FDBB3E73DA3E40	SOLVED	5	1
8	забор	забор стоит за красной линией прямо на тротуаре, человек незаконно присвоил себе общую территорию в свою собственность.	знести	3	0101000020E6100000AB9509BFD43949409DD7D825AAAB3E40	UNSOLVED	3	1
9	Необхідність збереження пам’ятки природи місцевого значення «Тунель кохання», с. Клевань, Рівненський район Рівненської області.	Пам\\'ятка природи являє собою ботанічний феномен – зелений тунель у лісовому масиві, утворений заростями дерев та кущів, що сплелися між собою та утворили тунель точної арочної форми. Розташований на 4-кілометровому відрізку залізничної колії. Є місцевою туристичною принадою. Існують проблеми із прибиранням навколишньої території. На початку листопада 2013 року надійшла інформація про вирубку дерев навколо «Тунелю кохання» у шаховому порядку. 	Місцеві жителі періодично проводять толоки, прибирають тунель, проте існує проблема із зникненням обладнаних урн для сміття. Мешканці звернулися до мас-медіа, таких як Zik, Українська правда, 1+1. На запит журналістів заступник Рівненської ОДА О. Губанов пояснив ситуацію профілактичними роботами на залізничній гілці та впорядкуванням лісу. Кілька дерев дійсно були зрубані, однак так і залишилися лежати біля колій.   Проте після того, як подія набула розголосу в ЗМІ, вирубка дерев припинилася. Місцеві жителі досить ініціативні щодо захисту ботанічної пам’ятки, позаяк її відвідує багато туристів, в тому числі іноземних, що є джерелом прибутку. \n1.Туризм може стати джерелом фінансування робіт щодо догляду за лісом (добровільні пожертви, невеличкий збір).\n2. Можна запропонувати також надання тунелю статусу об’єкту культурної спадщини (ландшафтного, природно-антропогенного) із застосуванням відповідного режиму охорони. \n	3	0101000020E6100000F981AB3C816049401C2785798F033A40	UNSOLVED	1	1
10	Необхідність створення заказника для дельфінів біля мису Айя, Сарич та узбережжя Балаклави. 	Щороку сюди припливає на зимовку велика кількість азовок, білобочок та афалін, оскільки там досить спокійно та є хороша кормова база, що дозволяє дельфінам збільшувати поголів’я та комфортно зимувати. Наразі дельфіни потерпають від риболовецьких сітей, заковтують пластикові пляшки та інше побутове сміття. 	Потрібне надання цим водам статусу охоронної території, де буде заборонена господарська діяльність. \nПротягом кількох років на мисі Айя функціонував екологічний пост, який не пускав туди туристів. Збільшилася кількість водоплавних птахів і комах, природа почала оживати. Рада громадських екологічних організацій Севастополя звертається до Мінекології із клопотанням щодо створення окремого морського заказника. Можливе також розширення території існуючого морського заказника - прибережного аквального комплексу біля мису Айя. \n	3	0101000020E6100000FB78E8BB5B3D4640E6965643E2CC4040	UNSOLVED	5	1
11	Місцевість дуже забруднена, місто потерпає від сміття			3	0101000020E6100000F790F0BDBFD34740DD274701A24C4140	UNSOLVED	2	1
12	с.Пожарки	Стехійні сміттєзвалища біля і в лісі.	Поставити в с.Пожарки контейнери для роздільного збору сміття.	3	0101000020E61000005B22179CC1F94840BBB88D06F05A3E40	UNSOLVED	2	1
13	Сміттєзвалища 	Сміттєзвалища в лісі.	Поставити в с.Пожарки контейнери для роздільного збору сміття.	3	0101000020E610000041B96DDFA37C49400BED9C66813A3940	UNSOLVED	2	1
76	Незаконный вылов рыбы, раков	Разпологаются сети браконьеров вдоль берега, в ереках. Перекрыты каналы сетями в несколько этапов.	Контроль, извлечение сетей и порча их на берегу всеми не равнодушными.	3	0101000020E6100000874ECFBBB140474009A87004A90C3E40	UNSOLVED	6	1
14	Знакає річка	Річка Мала Тернівка - колись гарна й мальовнича ріка. Нині вона під загрозою висихання та замулення. 15 років тому вона була повноводною і стрімкою. Зараз вона майже зникла, подекуди  її русла узагалі невидно. Проблема почалася у радянські часи, коли непродумане випасання овець знищило грунтовий покрив у деяких місцях і оголило глину, яку з дощами змиває у русло, деякі круті береги також знищені, на мілині що утворилась розрісся надмірний очерет. Тепер ситуацію погіршує глобальне потепління.	1. Очищення русла від мулу. (дорого звісно, але річка доведена до того, що втратила здатність до самоочищення)\n2. Насадження рослинності	3	0101000020E6100000AC74779D0D5B4840B7B3AF3C48FB4140	UNSOLVED	4	1
18	ГМО	У Чернігівській обл., ТОВ «Земля і воля», а також багато інших с/господарств по всій Україні використовують гмо-культури (з паралельним використанням агресивної с/г хімії), давно вже не в цілях "проби". 	Заборонити в Україні діяльність Монсанто, Сингента та інших компаній, що використовують ГМО-технології. \nЗаборонити використання ГМ-насіння і технологій у великому с \\ г та приватному фермерстві. \nЗробити Україну "зоною, вільною від ГМО". \nРозробку на впровадження програми провести у 2014р.	3	0101000020E61000008D261763605D4940289EB305847A3F40	UNSOLVED	5	1
19	Сміттєзвалище на Гмирі 6	Велика територія бруду, пластику та іншого сміття. Також по всьому мікрорайону собачі віпорожнення.	Прибрати. Щось вирішити з незайманою територією: чи паркінг зробити (автомобілів тьма тьмуща), чи сквер, чи спортивний майданчик повноцінний (в мікрорайоні тільки дитячі майданчики), чи баскетбольне поле.	3	0101000020E6100000C8D0B1834A3249407E54C37E4FA03E40	UNSOLVED	2	1
20	Сміттєзвалище	Несанкціоноване та хаотичне викидання сміття в лісосмугах та полях, що псує загальний вигляд та шкодить довкіллю. Велика кількість будматеріалів та різного пластикового сміття.	Організувати прибирання, повідомлення особам відповідальним за екологічний стан в місцевості задля подальшого недопускання викидання там сміття!	3	0101000020E6100000E7FD7F9C3025494007EBFF1CE6CB3E40	UNSOLVED	2	1
22	НЕЗАКОНЕ СМІТТЄЗВАЛИЩЕ ОРГАНІЗОВАНЕ СІЛЬСЬКОЮ РАДОЮ	В селі Богданнівка, сільський голова організував майже в центрі села незаконне сміттєзвалище	Привернути увагу до данної проблеми жителів села і знайти рішення даної проблеми.	3	0101000020E610000026A8E15B584F49408B51D7DAFBE83E40	UNSOLVED	2	1
25	Викид сажі та зниження ставків пром. викидами	Узинський цукровий комбінат забруднює місто сажею з труби заводу, а також знищив життя в кількох ставказ через стоки. Крім цього присутній постійний неприємний запах через викиди в ставки барди.	Зобов\\'язати підприємство негайно припинити роботу до встановлення очистного обладнання та очистки ставків.	3	0101000020E61000001327F73B14E9484078B81D1A166F3E40	UNSOLVED	1	1
26	Проблема повiтря	Загрязнен воздух, несмотря на всевозможные фильтры на производстве	Контроль фильтров	3	0101000020E6100000BD1C76DF31E64740F92F1004C8AE4040	UNSOLVED	7	1
28	Забруднення ґрунтових вод	Через активну меліорацію і використання хімдобрив в радянські часи і зараз, є загроза забруднення ґрунтових вод і підтоплення (Херснська область)	Належний контроль	3	0101000020E6100000EA211ADD416A474032569BFF57794040	UNSOLVED	7	1
29	стихійні сміттєзвалища	вздовж р.Уж стихійні сміттєзвалища, оскільки в даній місцевості немає спеціально відведеного місця. 	побудова сміттєпереробного заводу	3	0101000020E6100000A3AD4A22FB5E4840D09D60FF75823640	UNSOLVED	2	1
30	засорение реки	Житомир-Новогуйвинское.Река Гуйва. При расчистке леса(пилили деревья),ветки и стволы сбрасывали в реку.  Результат подобной деятельности:-заторы,порча воды гниющим деревом, появление большого количества сине-зелёных водорослей,нехватка кислорода рыбам. Фото могу предоставить. Кроме того,по словам проживающей в том районе сестры,идёт браконьерский вылов раков.	Найти и наказать службы,которые виновны в болезни реки. Обязать их расчистить речку. Не знаю,есть-ли там лесничество,но если да,то поднять вопрос о халатном отношении лесника к своим обязанностям 	3	0101000020E61000009A7D1EA33C114940C7D9740470AF3C40	UNSOLVED	4	1
79	не чистят	Озеро грязное	Убрать почистить	3	0101000020E610000067F16261883A49408E3C1059A4553E40	UNSOLVED	4	1
80	выбросы в атмосферу загрязнённого воздуха с металлургических комбинатов и нехватка кислорода в воэдухе	выбросы в атмосферу загрязнённого воздуха с металлургических комбинатов и нехватка кислорода в воздухе	усилить фильтрацию выбросов и ...	3	0101000020E6100000560DC2DCEE8947408978EBFCDBC54240	UNSOLVED	7	1
31	Загальна системна проблема із сміттям	За сміття переплачується не менш ніж три рази. Перший сплачує величезні внески за використання неекологічного та всякого іншого упакування. Другі гроші, не менш значимі величиною, це сплати тих хто виробляє різні упакування. Третя сплата це покупець, ПРИМУШЕНИЙ сплатити за товар в упакуванні і без прав вибору. Четверта сплата це просто абсурдне примушення сплачувати за вивіз сміття, за яке вже три тази сплачено. Після візиту до магазину третина пакету становить пакування -- ОДРАЗУ як дотранспортував додому. Ціна мішечка сміття перевищує ціну деяких продуктів харчування!. Де ж ті гроші? Де переробка?  Система аж ніяк не заохочує навіть до встановлених смітників сміття переміщувати. Не всі живуть у багатоквартирних будівлях. Організація і побори для решти не просто неприйнятні, а абсурдні.\nДякую за увагу.	Встановлення організованих смітників. На розподілене сортоване збирання. Системні регулярні і сезонні заходи по збору органічних (гнилі та биті яблука, наприклад) та таких що потребують спалювання (листя та гілля) відходів та переміщення їх до організованих місць переробки, з подальшою вбудовою в екологічно корисні та прийнятні ланки. Хто живе у межах будинків з ділянкою (села, дачі, міські ітд) знає добре НАСКІЛЬКИ страждає саме та ділянка землі від тієї кількості сміття що просто не встигає саме по собі переробитися лишаючись локально. \nМаксимальне сприяння побудові переробних сміттє-заводів!!! з нормальними технологіями та вихідними продуктами.Відкрите рекламування усієї системи оббігу та оплати сміття замість пива, горілки та цигарок.\nСпасибі.	3	0101000020E61000002C7DE882FA36494092B1DAFCBF8A3E40	UNSOLVED	2	1
32	Сміттєзвалище біля лісу	Між селами Грушів та Ходорів декілька років тому утворилося незаконне сміттєзвалище у зоні Ржищівського лісгоспу	Прибрати територію і не допускати її засмічення	3	0101000020E61000003D9B559FABF3484079B130444E3B3F40	UNSOLVED	2	1
33	Сміттєзвалища на "Коса на Победе"	Це місце є єдиним можливим "виходом на природу" для багатьох мешканців жилмасиву Перемога, чудове місце для тренування спортсменів тощо. Але, на жаль, немає служб, що доглядають цю територію, або вони є, але абсолютно не виконують свої функції. Централізованних смитників також недостатньо. Через це  всім відома Коса перетворилась на сміттєзвалище і кожного для ця проблема лише збільшується. 	Встановлення смитників, проведення суботників, контроль роботи відповідних служб міськими головами.	3	0101000020E6100000876F61DD783548401BF33AE290894140	UNSOLVED	2	1
34	сплошная вырубка леса 	сплошная вырубка леса  и вывоз на протяжении 3 последних лет	остановка сплошной вырубки остатков леса и недопущение в будущем	3	0101000020E6100000BB7F2C4487144940EAAF575870FB3D40	UNSOLVED	1	1
36	Сміттєзвалище. Забруднення...	Недобудований об\\'їзд завалюють сміттям. Згодом це стане сміттєзвалище неймовірних розмірів.	Очиститит територію, перекрити всі в\\'їзди до території.	3	0101000020E610000093E4B9BE0F334940F2D3B837BF693E40	UNSOLVED	2	1
37	Постійна зміна клімату, вирубка лісів, смітник	На моїх очах вирубають ліс. По дорозі на роботу я бачу навколо себе смітник	Поставити знаки штрафу, за смітник у данному місці. шробити "суботник"!!!!хай люди прибирають там, де самі і живуть!!!!	3	0101000020E6100000C2340C1F11154940E272BC02D15B3E40	UNSOLVED	2	1
39	Стройка	Стоят дома, вырубают леса, гадят) 	Беречь природу!	3	0101000020E6100000B610E4A084454940B8CA13083B3D3E40	UNSOLVED	3	1
40	Смітник біля будинку	Смітник біля будинку і на всій вилиці!!!	Влаштувати день прибирання	3	0101000020E6100000770FD07D394D4840CFF8BEB8544D3640	UNSOLVED	2	1
41	Незаконный вывоз песка	Незаконно выкачивает песок земснаряд, а это грозит тем, что весь мост может рухнуть. 	Запретить и наказать.	3	0101000020E61000001FDB32E02C334940CAA31B6151993E40	UNSOLVED	4	1
42	Загрязнение родникового водоёма	В селе Синяк, Вышгородского района, Киевской области в родниковое озеро сбрасывают отходы производства предприятия "Альянс" и канализацию жилых домов. Вода в колодцах уже дурно пахнет.	Запретиь предприятию сбрасывать отходы в озеро. Для сельской канализации построить очистные сооружения.	3	0101000020E6100000F5A276BF0A5649401C5DA5BBEB443E40	UNSOLVED	4	1
43	Сміттєзвалищє	Возле детского сада, через дорогу, расположен открытый сток для воды от дождя. В сток сбрасывается мусор, в нем часто стоит вода, идет запах гнили. Сток плохо огражден.	Прочистить сток, что б вода уходила, накрыть плитами, что б туда не падали люди, сделать ограждение, наклеить плакат, о том, что это не мусорка.	3	0101000020E6100000AB59677C5F68484021E7FD7F9C603D40	UNSOLVED	2	1
44	Брудно	На вулицях валяються пакети , пусті пляшки , сміття...	Встановити якомога більше мусорних бачків	3	0101000020E6100000ACADD85F76CB484004E5B67D8F464140	UNSOLVED	2	1
45	Забруднені водойоми та береги річок	Береги Дніпра, Кагамлика та інших водоймищ, забрудені різним сміттям. З берегів зливають різноманітні хімічні сполуки у водоймища, через що гине риба та влітку водоймища вкриваються зеленими воростями. Якщо б це були винні підприємства, то було б легше попередити цію проблему, але винуватцями фізичні особи.	Ввести екологічний патруль, який буде контролювати забруднення та виявляти порушників. Ввести жорсткі санкції за забруденння та заохочення за очищення території. \n	3	0101000020E6100000471CB28174894840B85B920376B54040	UNSOLVED	4	1
46	Сміттєзвалище	У приватному секторі утворилося сміттєзвалище, яке, хоча і вичищається періодично установами ЖКГ, проте не упорядковане і розпорошене на 140-150 кв.м. Ще на 100-150 м у всі боки розлітається таке сміття, забруднена вся територія вулиці Фруктової та провулків.	1. Зареєструвати місце для розміщення побутових відходів.\n2. Облаштувати спеціально таке місце, оскльки продукти розкладання таких відходів потрапляють у грунти.\n3. Забезпечити можливість роздільного збирання побутових відходів та сміття.\n4. Провести розяснення серед населення щодо користування місцями розміщення відходів та роздільного збирання сміття.	3	0101000020E6100000C504357C0B23494044F8174163B23C40	UNSOLVED	2	1
48	незаконне будівництво	років 20 тому вирили котлован під новий елітний будинок біля буд 83 на вул.Калинова, зараз цей покинутий котлован заріс деревами та кущами, там справжнє сміттєзвалище. Котлован обнесено парканом і його стереже охоронна фірма цілодобово. Прямо біля ЖЄКу №23. Цей ЖЄК покриває власника кієї "забудови".	засипати котлован та знову зробити там вільний під"їзд (доріжку, тротуар) до будинку №83 для машин та людей. 	3	0101000020E61000001348895DDB4148400DAB7823F3864140	UNSOLVED	2	1
49	Переповнення відходами людського відпочинку	Півострів захаращений горами пластику, скла та іншого сміття, яке незаконно звозиться сюди або залишається після "відпочинку" мешканців Києва.	Зібрати актив Оболонського району для прибирання. Залучити виробника сміттєвих мішків, резинових перчаток тощо, в якості партнера/спонсора, та компанію, яка займається переробкою сміття - прибрати півострів, встановити шлагбауми, облаштувати зони відпочинку, розставити баки для сміття, та збирати по 5грн. з авто за підтримку чистоти.	3	0101000020E6100000789961A3AC4349402384471B47883E40	UNSOLVED	2	1
50	Як зробити місто чистим	Проблема сортування сміття, немає контейнерів для пластика, паперу,скла і т.п.Сміттєзвалища, які роблять мешканці міста, бо немають екологічної культури. Багато реклами по телебаченню, але майже не побачиш реклами, пов`язаної з екологічними проблемами міста, країни, планети...	1. Широко і частіше освітлювати екологічні проблеми по телебаченню, в газетах, на бігбордах.\n2. Проводити масові екологічні акції с залученням шкільної та студентської молоді.\n3. Звернути увагу керівництва міста на проблему сміттєзвалищ с залученням спонсорів, партійних та громадських діячів.	3	0101000020E61000006DA983BC1E2648407FC0030308034340	UNSOLVED	2	1
51	Зробити водойми екологічночистим місцем відпочинку	Забруднення водойм, не чистять , сміттєзвалища на берегах	залучити громадських діячів, студентську молодь та керівництво міста до вирішення проблеми - щорічно чистити, прибирати берег, поставити урни для сміття, обладнати берег для місця сімейного відпочинку мешканців міста	3	0101000020E61000004E469561DC2948407FC0030308034340	UNSOLVED	4	1
53	Вирубка дерев	Вирубка дерев на території міста	вплив на владу, посадка садженців	3	0101000020E61000007E6FD39FFD00494017B7D100DE1E4240	UNSOLVED	7	1
54	Завод з токсичними викидами в житловій зоні	В житловій зоні, в центральній частині м. Снятин, вже багато років працює завод по виготовленню оздоблювальний матеріалів з пластику (ПП «Лідер VTM»). Відповідно, завдається велика шкода здоров’ю людей, які живуть неподалік. Адже, завод постійно неофіційно спалює відходи, і цими газами мусять дихати люди (аж "горло дере"). Люди неодноразово зверталися у відповідні органи влади, але ніхто дану проблему не хоче вирішувати.	1. Закрити даний завод.\n2. Виплатити людям компенсації за завдану шкоду їхньому здоров’ю.\n3. Покарати винних підприємців та чиновників.	3	0101000020E6100000043C69E1B2384840707841446A923940	UNSOLVED	3	1
55	Засмічення Вовчинецьких гір побутовим сміттям	Мешканці міста Івано-Франківськ, с.Вовчинець та с.Підлужжя скидають побітове сміття на схилах Вовчинецького пагорбу (комплексна пам\\'ятка природи місцевого значення ) та берегах річки Бистриця Надвірнянська..	Встановлення сміттєвих баків біля будинків в с.Вовчинець та с.Підлужжя, організація централізованого вивозу сміття не рідше 1 разу/тиждень, встановлення сміттєвих контейнерів при в\\'їзді в заказник "Козакова долина" та регулярний вивіз сміття (не рідше 2 разів/тиждень в період березень-листопад, не рідше 1 рази/тиждень в період грудень-січень)	3	0101000020E6100000CEFA9463B27A4840EB909BE106C03840	UNSOLVED	2	1
81	Не екологiчно чистi придприэмства якi забруднюють навколишнню середу	забрудненя повiтря	Побудувати екологiчнi придприэмства що не забруднюють навколишнiй середи	3	0101000020E6100000B8AD2D3C2F25484016BD5301F7044340	UNSOLVED	7	1
56	Пересыхание цепи озер в Березовой Рудке	Еще несколько лет назад в живописном селе Березовая Рудка (шевченсковские места, кстати) было несколько озер. Сейчас фактически осталось одно, которое стремительно уменьшается и заиливается, еще одно практически заросло, и на месте третьего - сухая земля. Говорят, что забились ключи, которые питают озера, а денег почистить как озера, так и ключи - нет. Жаль, что такое живописное место (здесь находится одна из немногих в Европе пирамид) теряет часть своей красоты. 	Почистить озера, определить проблему, почему они пересыхают, при необходимости - почистить ключи, которые питают озера. 	3	0101000020E61000002EE7525C552849405952EE3EC71D4040	UNSOLVED	4	1
58	Свалка в карьере ракушечника	Мусоровозы возят мусор в карьер, вокруг свалки на полях и дачный участках  мусор	Закосервировать , утилизировать , засыпать	3	0101000020E610000085B4C6A01350474037DDB243FCE73E40	UNSOLVED	2	1
59	Порушення підприємством санітарно-екологічних норм	Макарівська птахофабрика забруднює токсичними викидами повітря та воду. При проведенні моніторингу стану атмосферного повітря в селищі Макарів санепідемстанцією було встановлено, що концентрація двоокису азоту перевищує гранично допустиму в 1,27 разів, сірководню - в 15,38 разів, коефіцієнт комбінованої дії сірководню та аміаку перевищує норму в 16,62 рази. Це становить загрозу природі та здоров`ю людей.\nhttp://www.youtube.com/watch?v=562siiNlsfc	Необхідно примусити власників використовувати очисні технології та постійно контролювати рівень забруднення, або перенести виробництво подалі від населеного пункту.	3	0101000020E61000004FCE50DCF1384940BDC804FC1AD13D40	UNSOLVED	7	1
61	незаконні сміттезвалища	незаконні сміттезвалища в посадках в межах города та поблизу.	 вплив на владу, громадський контроль. зміна законодавства	3	0101000020E6100000836C59BE2EFF4840B8E68EFE97194240	UNSOLVED	2	1
63	Смітник у зоні відпочинку	Гарний сосновий ліс перетворили на сміттєзвалище	Заставити відповідальних осіб прибрати територію. Побажання відпочиваючим - будьте людьми!!!	3	0101000020E61000006FD39FFD485B4840E9B7AF03E7283D40	UNSOLVED	2	1
66	экологически опасная свалка	Свалка с нарушениями всех нормативных документов в непосредственной близости к жилой зоне	Закрыть\n	3	0101000020E61000005CACA8C1345448408E23D6E2539C4140	UNSOLVED	2	1
67	Заьруднення повітря	Забруднення повітря заводом "Ізоват"	Закрити, вдосконалити очисну систему	3	0101000020E6100000B728B341261F494047E9D2BF24BD3C40	UNSOLVED	7	1
69	"Сирітська хатка" на березі Південного Бугу	Побудований маєток на березі річки взагалі без врахування прибережної зони.	Бажана зацікавленність природоохоронних і юридичних органів.	3	0101000020E6100000702711E15FC248403F53AF5B04063C40	UNSOLVED	3	1
71	сміттезвалища і сміття взовж річкі Ірпінь	Багато сміття викинуто вздовж річки	Сміття було вивезено на офіційний смітник за Димером за допомогою власних автівок членами клуба http://kievjeep.net/forum/index.php\nПроблему вирішено.	3	0101000020E6100000C710001C7B5E49400ABE69FAEC5C3E40	SOLVED	2	1
72	Автозаправка напроти дев\\'ятиповерхового будинку	Замість зеленої зони збудували автозаправку напроти дев\\'ятиповерхового будинку. В будинку мешкає близько 500 мешканців, поряд ще будинки, школа дитячої творчості...\nНіяких дозволів, документів... у мешканців ніхто не питав чи хочуть вони мешкати напроти заправки і нюхати всі ці канцерогенні вихлопи.	Знести або підірвати заправку, повернути зелені насадження які були на її місці.	3	0101000020E6100000342F87DD770A4840779FE3A3C5094340	UNSOLVED	7	1
73	Загрязнение местности и атмосферы	Большая свалка рядом с домами, также рядом очисная как подует от туда хоть не выходи на улицу.	Свалку перенести, построить завод переработки мусора, очистную перестроить по новым стандартам чтобы люди не задыхались от запаха что от туда идет	3	0101000020E610000084D89942E73D484059880E8123274040	UNSOLVED	2	1
74	Забруднення території	Засмічення території міста самими жителями та засмічення лісів службами які відвозять сміття в ліс і там його залишають в великих кількостях	Розмістити таблички - реклами щодо чистоті в місті, це примусить задуматись принаймні більшу половину жителів. Щодо лівіс пивинна держава сама вирішувати такі питання та штрафувати тих хто відвозив ліс сміття і мало того, треба ще змусити їх його знищити аби його не перевезли в інше місце. Країна хабарництва! Ви ж для себе та своїх дітей гірше робите!	3	0101000020E6100000369204E10AA8494053EC681CEA973A40	UNSOLVED	2	1
75	Мусорка	незаконная свалка мусора в лесопосадке. масштабы огромные	информирование населения	3	0101000020E61000001233FB3C462F4840774B72C0AE8E4140	UNSOLVED	2	1
143	Грязное старое русло реки Лугань	Мусор, ил	Необходима чистка реки, вывоз мусора	3	0101000020E61000009A7D1EA33C4B4840091B9E5E29AB4340	UNSOLVED	4	1
82	Незаконне полювання в околицях с. Липовиця	Місцеві жителі не приховують, що в їхньому селі значна частина місцевих жителів відкрито промишляє браконьєрством. Кримінальні "мисливці" настільки нахабні, що розстрілюють охоронні знаки заповідних об\\'єктів. Особливо їх багато в малолюдних гірських районах Ґорґан.	- Операція по добровільній здачі незареєстрованої зброї\n- Інформування туристами про виявлення озброєних осіб в гірських чи лісових районах\n- Створення добровільних дружин, які патрулюватимуть в період риковиськ тощо	3	0101000020E61000006B2A8BC22E624840914259F8FA0A3840	UNSOLVED	6	1
83	Греблі	Греблі призводять до обміління річок, замулення, вимирання іхтіофауни.	Необхідно поступово відмовитись від регулювання річкого стоку ха допомогою гребель.	3	0101000020E61000008AABCABE2BCE48402D05A4FD0F484140	UNSOLVED	4	1
84	Велика кількість сміття	Купи сміття під метромостом	Запезбечити належний рівень якості вивозу сміття з району «Тюрінка», бо назараз це є один із найбільш забруднених районів Харкова.	3	0101000020E61000004CDD955D30004940A038807EDF234240	UNSOLVED	2	1
85	Міське сміттєзвалище	Велике сміттєзвалище, яке постійно забруднює навколишнє середовище!!!	запустити існуючий неподалік завод з переробки твердих побутових відходів.	3	0101000020E61000005FD38382523249408F54DFF945353840	UNSOLVED	2	1
86	Браконьерство	Вылавливают бродом и сетками всю живность в водоемах	Организовывать патруль	3	0101000020E61000005E4C33DDEBB4494072A8DF85ADD13E40	UNSOLVED	6	1
88	Истребление рыбы "электроудочкой".	Часть местных жителей систематически занимается выловом рыбы путем применения "электроудочки". При том, на этой территории существует заповедник, но никто на это не обращает внимания.	Усилить контроль со стороны местных правоохранительных органов.	3	0101000020E6100000A41AF67B62494940E109BDFE24AC4040	UNSOLVED	6	1
89	Вирубка лісу.	Вирубка лісу на території де знаходиться багато рідкісних рослин, в тому числі і з Червоної Книги України.	Пропоную перевірити вирубку на офіційність, якщо офіційно то звертатись з офіційними заявами до органів міського управління і т.д.\nЗазвичай вирубку проводять під ліценцією "чистки" але чистка включає в себе вирубку 1 дерева з 5, а в нас зрубуються всі.	3	0101000020E610000004543882543C4840486AA16472D63B40	UNSOLVED	1	1
90	Радіаційне забруднення - База "С"	Бывший склад урановой руды. Находилось в эксплуатации с 1960 по 1991 годы. Содержит 150-300 тыс. тонн твердых радиоактивных отходов в виде полуразрушенных конструкций бункеров для урановой руды, загрязненных железнодорожных путей, грунта на поверхности и под бункерами. Объем – 0,15 млн. м3, площадь 300 тыс. м2. Максимальная мощность дозы гамма излучения на поверхности 4700 мкР/час, общая активность – 12000 Ku	Это проблема государственного масштаба, должна решаться как можно скорее на государственном уровне.	3	0101000020E610000083DBDAC2F33648402BDEC83CF2614140	UNSOLVED	7	1
91	Переповнення відходами людського відпочинку	Берег захаращений горами пластику, скла та іншого сміття, яке  залишається після "відпочинку" мешканців Києва.	Прибрати, встановити шлагбауми, розставити баки для сміття, вивозити сміття.	3	0101000020E6100000E67805A227474940ED0F94DBF6893E40	UNSOLVED	2	1
93	Сміттєзвалище переповнене.	Сміттєзвалище використовується понад нормативні строки що несе небезпеку.	Припинити використовувати сміттєзвалище.	3	0101000020E610000093C3279D481E49404D8578245E863E40	UNSOLVED	1	1
94	Забруднення води	Червона вода стікає до Дніпра	Потрібні очисні споруди	3	0101000020E610000028F38FBE49E947409C3237DF88924140	UNSOLVED	4	1
95	Забруднення повітря	Забруднення повітря небезпечними викидами заводів	Очисні споруди на заводах	3	0101000020E6100000D600A5A146ED474055A69883A0914140	UNSOLVED	7	1
96	Незаконний вилов риби	Незаконне зайняття рибним, звіриним або іншим водним добувним промислом	У 200 разів збільшиться штраф за незаконний вилов риби.\nЗаборонити вилов риби.	3	0101000020E6100000F50EB743C3C64840CA4FAA7D3A624040	UNSOLVED	6	1
97	Енергетика	Після вводу в експлуатацію нової станції метро та нової дороги, ліхтарі (6 ліхтарів) впродовж старої дороги залишилися, працюють та світять без мети.	Пропоную демонтувати непотрібні ліхтарі та спрямувати цю енергію на освітлення темної вулиці в цьому ж районі	3	0101000020E610000017D522A298064940A19E3E027F1A4240	UNSOLVED	7	1
98	Зливання стычних вод у р. Хорол	Міська не очищена калінізація частково зливаеться в річку Хорол.	Потрібно вияснити чтому зливають і найти шляхи вирішення ціеї проблеми	3	0101000020E610000089B14CBF44FC4840E69315C3D5CD4040	UNSOLVED	4	1
101	Уникальные водоемы.	Уникальные водоемы (часть из которых родниковые), с обильным наличием различного вида животных и птиц, зарастают и заиливаются. Животные и птицы уходят. С этими водоемами на прямую связано водообеспечение населения с использованием колодцев.	Чистка, вырубка старых (сухих, гнилых) деревьев.	3	0101000020E6100000552E54FEB5E448404EB9C2BB5CF03E40	UNSOLVED	4	1
102	Сміттезвалище у лісі	На очах розростається сміттезвалище у лісі. Невідомі безперешкодно вивозять у ліс будівельне сміття та ін.	Обмежити рух транспорту через ліс, Вивезти сміття у відведене для нього місце, Встановити попереджувальні снаки про міру відповідальності за вивіз сміття та соціально направленцу агітацію за чисте довкілля.	3	0101000020E610000019FF3EE3C23949407808E3A771573E40	UNSOLVED	2	1
104	Забруднене озеро	Невелике озеро біля школи дитячого садка забруднена сміттям. Там кожен день гуляє багато молодих сімей та маленьких дітей	Собраться инициативной группе и убедить живущих там людей организовать очистку озера	3	0101000020E6100000F0C000C28734494079211D1EC2683E40	UNSOLVED	4	1
105	Сміттєзвалище	Розвалена стара ферма та велика кількість сміття	Прибрати сміття та віддати територію під забудову	3	0101000020E61000006DE525FF93354940698B6B7C26B73940	UNSOLVED	2	1
107	Незаконне вивезення сміття 	Сміттєзвалище існує вже досить довгий час, ним користуються незаконно, вивозять сміття з будівництв та інший непотріб	Необхідно обмежити проїзд автомобілів, дорога в цьому місті вузька	3	0101000020E6100000D7A02FBDFD414940F5D8960167BD3E40	UNSOLVED	2	1
108	Незаконна вирубка лісів	Масово вирубуються ліси	Змінити лісника	3	0101000020E61000008AABCABE2B42494012C0CDE2C5BE3E40	UNSOLVED	1	1
109	Вирубка дерев біля траси Київ - Чернігів	Проводиться повна вирубка захисних зелених насаджень біля траси Київ - Чернігів	Зупининити це! Відновити насадження!	3	0101000020E6100000B3CEF8BEB8424940AA61BF27D6C93E40	UNSOLVED	1	1
110	Вирубка лісів	Незаконне вирубування лісів	Змінити лісника	3	0101000020E61000001A14CD03584249404A404CC285C03E40	UNSOLVED	1	1
112	Забруднене озеро	В озеро зливаються стічні води, як результат воно заростаяє та не є придатним для людей	Організувати очистку водойми, вирішити проблему стічних вод	3	0101000020E6100000B8019F1F46404940A7ECF483BAC03E40	UNSOLVED	4	1
113	Вирубка дерев	Вирубка дерев у великих масштабах, яким більше 100 років	Збільшення штрафів в 10-ки разів, кримінальна відповідальність	3	0101000020E6100000309E4143FF42494091B932A836BC3E40	UNSOLVED	1	1
114	Будівництво Біланівського ГЗК	Якщо Біланівський ГЗК почне діяти, весь ставок-випаровувач «Укртатнафти» інфільтрується у тіло кар’єра. Стоки, що надходитимуть до ставка, не очищуватимуться. Зате вони потраплятимуть в кар’єр – адже між ставком та кар’єром небезпечно мала відстань. А там вестимуться вибухові роботи. Виникне проблема відкачування кар’єрних вод. Кар’єрні води – це дуже солоний розчин, ропа. З ними змішаються насичені фенолами води ставка-випаровувача. Куди їх скидати? Тут варіантів кілька. Можна будувати новий ставок-відстійник – це дуже дорого. Можна скидати води в Дніпро чи Псьол. Та у такому випадку солона ропа та феноли винищать все. Як це вплине на Дніпро, можна ще думати, а Псьол – зважаючи на його малу потужність – стане мертвою рікою.	Потрібно закрити будівництво Біланівського ГЗК, щоб не було екологічної катастрофи.	3	0101000020E6100000666A12BC21954840DA39CD02EDD44040	UNSOLVED	3	1
116	Попадання неочищених стічних вод в річку	Вже багато років в Івано-Франківську не працюють як належно очисні споруди стічних вод. Фінансування на вирішення проблеми відсутнє, стан очисних споруд жахливий, результати аналізів стічних вод які попадають в річку приховують, перевіряючі органи за замовчування питання беруть хабарі.	Показати громаді міста реальну картину, залучити довгострокові інвестиції на відновлення або переоснащення очисних споруд, виконати проект та реконтсрукцію або капітальний ремонт згідно цього проекту.	3	0101000020E6100000406B7EFCA58148408733BF9A03BC3840	UNSOLVED	4	1
117	Незаконний вилов риби	У річці Псьол майже не залишилось риби, кожного року бракон\\'єри глушать рибу. Люди неодноразово спостерігали як глушена риба пливе по Пслу. І це вже не перший рік.	Прошу заборонити вбиство незаконними методами риби у річці Псьол.	3	0101000020E6100000AED4B32094B1484019028063CFE64040	UNSOLVED	6	1
118	Сміттєзвалище	Сміттєзвалище	Сміттєзвалище	3	0101000020E61000009432A9A10D444940E2CCAFE600393E40	UNSOLVED	2	1
159	Сміття,забруднення повітря	По вулицях розкидане сміття,повітря забруднене заводами з важкої металургії	Хочу,щоб долучали до цього людей,яким не все одно!мі зможемо ще все вирішити!!!	3	0101000020E6100000FEBAD39D275C4840C9586DFE5FC94240	UNSOLVED	2	1
119	Забруденний ставок в Козельщині	Береги ставка засмічені та вода має неприємний запах. Також навколо прилеглих територій помітні залишки сміття, що псують вигляд Козельщини.	Необхідно виділити гроші для очищення ставка і прибрати сміття навколо ставка. Зробимо Козельщину чистішою!	3	0101000020E6100000276BD443349C48402E8F352383EC4040	UNSOLVED	4	1
120	Екологічний хаос	Це сміттєзвалище працює ще з того часу. За весь час на нього не було виділено ні копійки. За результати праці я думаю балакати не доведеться, тут і так все ясно. Сміття вивозять кожен день. Загортають бульдозерами в землю. Залишки намагаються спалити, але це не завжди вдається. Звідци й збираються великі кочугури сміття, яке просто не вспівають обробляти. Вивід один - постійний сморід, забруднення грунтових вод, все йде людям в криниці. Також екологічна проблема в тому, що не всі продукти підлягають процесам розпаду і переробки природнім шляхом (пластикові бутилки, пакети, одноразовий посуд та ін.)	На місцевій обласній раді не раз ставилося питання, щодо вирішення цієї проблеми. Депутати прийняли рішення знайти інвестора для будівництва переробного заводу, на території звалища. Але чомусь - руху ніякого до сих пір. Було б не погано, як би зайнялись зацікавлені люди цим питанням. Завод вироблятиме вторинну сировину, яку також можна використовувати в виробництві одноразового посуду тощо. З часом вилучені кошти від продажу продукції також можливо використати за призначенням. На мою думку рентабельність цього заводу складатиме 70-85 %, що в наш час не погано. З урахуванням кошториса та затрат на будівництво потібно 5 -7 років на повернення коштів. Це також не погаганий показник, навіть без підтримкм влади. Для підтримки необхідні зміни до діючого законодавства, щодо охорони навколишнього середовища, та притягнення до відповідальності посадових осіб за розкрадання державних коштів.	3	0101000020E61000001F84807C09274940A7AD11C138A43C40	UNSOLVED	2	1
121	Остров из мусора	Искусственно созданный остров из отходов пищевой и бумажной промышленности.	Установка фильтров на предприятиях.	3	0101000020E6100000FA0B3D62F43C4840C2A6CEA3E2914140	UNSOLVED	4	1
124	ставок Крива Руда	В ставок раніше викидались стічні води з цукрового заводу, а зараз в нього викидають сміття і каналізацію. Якщо глянути, то видно що вода зелена а підводою багато муляки.	\nСлужба що проводила очистку ставка перестала існувати після розпаду СССР. Потрібно створити щось подібне, щоб привести ставок до нормального виду.	3	0101000020E6100000D6FD63213ACC4840FA7B293C689A4040	UNSOLVED	4	1
125	Жомова яма	Цукровий завод уже давно закрився, а жомова яма до сих пір гниє. В сонячну погоду по вулиці Транспортній нереально йти з незакритим носом!	Необхідно вивести всю цю вонь.	3	0101000020E61000006EC493DDCCCC4840EB8D5A61FA984040	UNSOLVED	5	1
126	Незаконне сміттєзвалище	Сюди люди вивозять сміття.	Думаю, необхідно ще кілька сміттєвозів, щоб люди самі не вивозили своє сміття куди попало.	3	0101000020E61000001233FB3C46CB4840EE27637C989B4040	UNSOLVED	2	1
127	Загрязнение воздуха предприятием  "АрселорМиталл Кривой Рог"	Загрязнение атмосферного воздуха. Отключение всех фильтров по ночам. Загрязнение водоемов. 	Штрафы и административные взыскания. Независимый экологический аудит 	3	0101000020E61000005776C1E09AEF47403BE0BA6246B24040	UNSOLVED	7	1
128	Проблема вивезення сміття та культури людей	Не відомо - це мешканці села туди звозять сміття чи просто люди які зупиняються на своїх машинах , але ж блін  до заправки 100 метрів -- невже важко донести своє сміття !!!! 	Зібрати місцевих мешканців та прибрати сміття , встановити відеофіксатори - щоб виявити порушників .  Мій контактний номер : 066-846-8-555 (Ілля) 	3	0101000020E6100000410DDFC2BA2D49408BFCFA2136703E40	UNSOLVED	2	1
129	Вирубка лісу	Дуже сильно незаконно вирубують ліс біля "історичного дуба".	Прийняти міри!	3	0101000020E610000066F4A3E1941548401DAB949EE9013A40	UNSOLVED	1	1
130	Звалище будівельного сміття 	Стихійне звалище будівельного сміття біля грунтової дороги	Прибрати звалище. Встановити нагляд та попереджувальні знаки. Закрити або обмежити проїзд,	3	0101000020E6100000FCA5457D92E9474025B1A4DC7D864140	UNSOLVED	2	1
131	Очисні споруди	В м. Борщів вже багато років не працюють очисні споруди. Вся вода з міської каналізації потрапляє в місцеву річку Нічлава.	Відновити роботу очисних споруд.	3	0101000020E6100000EA5DBC1FB765484057B3CEF8BE083A40	UNSOLVED	4	1
132	Бездомные собаки	Многочисленные стаи бездомных собак!	Отловить и поместить в питомник.	3	0101000020E6100000D9D0CDFE403F4940F73C7FDAA8723E40	UNSOLVED	7	1
144	Загрязненная речка и прилегающая территория 	В оттоку от речки сливают непонятно что, сам водоем закидан мусором и трупами умерших животных, вокруг полно мусора, битые стекла и т.д.	Если наш город слишком занят чтобы решать подобные проблемы, необходимо самоорганизоваться и хотя бы убрать территорию от мусора.	3	0101000020E6100000A38FF980404B4840E97E4E417EAA4340	UNSOLVED	4	1
145	Экологическая культура жителей города	Экологическая культура жителей города	Перестать выбрасывать мусор на улицу	3	0101000020E61000002D95B7239C484840EAB46E83DAB34340	UNSOLVED	1	1
160	Стихійне сміттєзвалище	Стихійне сміттєзвалище на березі озера де зазвичай відпочивають кияни на Оболоні.	Прибрати територію та влаштувати смітники.	3	0101000020E61000004837C2A2224449405BEF37DA717F3E40	UNSOLVED	2	1
133	Забруднення ставків.	Ці ставки - дуже популярне місце для відпочинку та зайняттям спорту, безліч сімей відпочиває на берегах цих ставків, навіть рибалки ходять сюди.\nАле, ставок з кожним роком стає все більш забрудненим. Колір води в ставку становиться все темнішим... \nАле здебільшого забруднюють самі відпочиваючи, залишають за собою велику купу сміття, деякі слухняні збирають після себе та несуть до смітнику, який стоїть на виході з лісу, але це далеко, деяким - важко стільки нести.\nВ тому році, була зроблена яма, щоб хоча б якось локалізувати сміття, але вона швидко заповнилась і ніхто її не прибирав...\nПроблема відома вже декілька років, вже й було виділено дуже багато грошей (600000грн.), для того, щоб вирішити цю проблему, але ці гроші мабуть пішли, на інші справи... \nОсь лінк: http://vpoltave.info/read/novost/id/199972117/Stavki-mezhdu-Sadami-i-Polovkami-dozhdalis-svoejj-ocheredi\nПро ситуацію: http://vpoltave.info/read/novost/id/199814170/Otdykh-na-pomojjke	Хоч і учні шкіл ходять сюди на суботники, щоб прибрати, але це не на довго, за одні вихідні - знову купа сміття.\nРоків з 10 тому, в цих ставках купались люди, а зараз і порух важко знаходитись.	3	0101000020E6100000473D44A33BCA48402C80290307404140	UNSOLVED	4	1
134	Забруднена водойма	Сильно забруднена водойма. Постійно падає рівень води.	Очистка води	3	0101000020E610000017D86322A5354940126C5CFFAEA33E40	UNSOLVED	4	1
135	Проблема питної води	Людям, які живуть поблизу Єрестівсього ГЗК немає де набрати питної води, так як у зв\\'язку з будівництвом кар\\'єру, у воду попали небезпечні хімічні елементи, які шкодять здоров\\'ю людей. Також в цих місцях із-за вибухів - вже стіни на хатах потріскались.	Необхідно терміново вирішити це питання, бо людям з навколишніх сіл загрожує небезпека для їх життя та здоров\\'я. Місцева влада повинно вирішити цю проблему.	3	0101000020E6100000753FA7203F8B4840D218ADA3AAD94040	UNSOLVED	4	1
136	міське сміттєзвалище	1 жахливий еко стан довколишніх поселень\n2  забруднення повітря (самозаймання), \n3 забруднення грунтових вод. \nосновне накопичення сміття не контрольоване адміністрацією міста (стихійне). вибіркове вивезення сміття компанією монополістом. велика кількість сміття спалюється в межах міста - спричиняє забуднення повітря.	1 запросити декілька інших сміттєвих компаній (зруйнувати монополію на вивіз)\n2 запровадити систему сортування сміття для подальшої переробки\n3 збудувати сміттєпереробний завод 	3	0101000020E6100000A565A4DE53F54840C2DD59BBED8E3C40	UNSOLVED	2	1
137	Забруднення повытря	Постійний запах тухлих яєць. Купа сміття по боках дороги.	Поставити нові очисні системи.\nПрибрати сміття.	3	0101000020E6100000EAB46E83DAEF4740AF7D01BD70954140	UNSOLVED	7	1
138	Экологическая культура жителей города	Равнодушие жителей города к экологическим проблемам, оставляют мусор после семейного отдыха в лесу, парке, у водоема. Дети бросают обертки от конфет на дорогу, хотя урна находится не далеко. Выбрасывают много бумаги, хотя можно сдать макулатуру. Много отходов выброшено, а рядом бродят голодные бездомные животные.	Работаю в творческой группе учителей города по экологическому воспитанию, проводим с коллегами конференции, семинары для учителей, организовываем природоохранные акции и т.д. Хотелось бы, чтобы нам в этом помогала и городская общественность, молодежные организации, студенты.	3	0101000020E6100000662D05A4FD2748407FC0030308034340	UNSOLVED	7	1
139	Сміттєзвалища на "Балка"	немає служб, що доглядають цю територію	Люди	3	0101000020E6100000CA37DBDC9834484080457EFD10894140	UNSOLVED	2	1
140	 горит свалка ТБО	Уже месяц горит свалка. Дым на весь город. Все пропахло вонючий дымом. Самое печальное, что местная власть на это не реагирует.	Срочно принять меры по тушению пожара. Рекультивация земель на полигоне. Огородить территорию. Огриничить доступ посторонним лицам. Пропускной режим. Придерживаться закона об отходах.	3	0101000020E61000001F115322896647400475CAA31B5B4240	UNSOLVED	2	1
141	Добыча сланцевого газа	Загрязнение подземных вод химическими смесями	Запретить добычу	3	0101000020E61000001BD82AC1E2464840073F7100FDA44240	UNSOLVED	7	1
142	Хранилище радиоактивных отходов «Щербаковское»	Хранилище радиоактивных отходов гидрометаллургического завода (ГМЗ)\n На заводе была реализована следующая технологическая цепочка:разработка месторождений урановых руд открытым и шахтным способами (сопровождалась выбросами радиоактивной пыли, отвалами, выделением газа радона), производство уранового конденсата непосредственно на заводе(сопровождалось образованием огромного количества радиоактивных жидких отходов). Отходы производства в виде пульпы сбрасывались в хвостохранилище. По состоянию на конец 2010 года в хвостохранилище находится 37,4 млн.т отходов уранового производства общей активностью \n 3,89*1014 Бк.\n Площадь хвостохранилища - 25 га\n Расстояние до города - 1,5 км	Загрязнение обнаруживается не только на поверхности грунтов, но и проникает на глубину до одного метра. Причем, содержание изотопов урана, тория, полония, свинца увеличивается с глубиной.	3	0101000020E61000001C7E37DDB227484022E17B7F83BE4040	UNSOLVED	7	1
146	Викид шкідливих речовин у повітря - застарілий сміттепереробний завод у межах міста Києва	Регулярно сміттепереробний завод викидає у повітря відходи, які майже унеможливлюють отримання повітря через вікно. Жителі масивів Позняки, Осокорки, Харківський, змушен користуватися кондиціонерам і тримати вікна зачиненими. Вважаю, що дана проблема є загрозою для здоров\\'я всього населення перелічених районів.	реконструкція заводу, переведення на сучасні європейські технології. Або перетворення  на завод з розподілу сміття, а переробка - поза межами міста!	3	0101000020E61000004CFE277FF7324940223999B855AC3E40	UNSOLVED	2	1
147	Свалка в Тоннельной  балке 	Отдыхая на природе, люди не утруждаются   вывозом мусора и кидаю его на под ближайший куст.	Установка мусорных  урн, наложение штрафов, на нарушителей,  субботники 	3	0101000020E6100000FA0B3D62F4344840B9AAECBB22844140	UNSOLVED	2	1
148	Свалка в Тоннельной  балке 	Проблема в массовых стихийных свалках после отдыха людей на природе. Мусор с балки не вывозится, и убирается только благодаря активистам на субботниках.	Установка мусорных  урн, наложение штрафов, на нарушителей,  субботники 	3	0101000020E610000044C2F7FE063548406C97361C96844140	UNSOLVED	2	1
149	Вирубка невеликого лісу 	Раніше був невеличкий ліс, в котрому проживали зайці, у нього ходили люди на відпочинок, але його знищили та почали забудову ділянок біля траси. 	Можливо вже запізно щось робити, але можна попередити вирубки зелених насаджень у подібних ділянках.	3	0101000020E610000071033E3F8C324840F1F62004E4854140	UNSOLVED	1	1
150	Жахливі руїни дому ветеранів	Руїни дому ветеранів, яки розбирають.	Прибрати руїни	3	0101000020E6100000459BE3DC268E47408ACC5CE0F2D64240	UNSOLVED	2	1
152	проблема днепровских склонов	После того как был построен вертодром и остальные высотные сооружения,  склоны Днепра находятся в критическом состоянии. Под смотровой площадкой образуются овраги, что может критично отразиться на целостности фундамента Мариинского дворца	Собрать консилиум специалистов и выбрать наиболее реалистичный проэкт по укреплению днепровских склонов	3	0101000020E6100000DAACFA5C6D3949404759BF99988A3E40	UNSOLVED	7	1
153	Сміттєзвалище 	Пустая поляна , на которой постоянно собирается мусор и люди жгут костры 	Обустроить ее , построить что либо ( дет. площадку , магазины ) или хотя бы просто сделать асфальт 	3	0101000020E610000071218FE0469047403D5FB35C36D64240	UNSOLVED	2	1
154	загрязнение прибрежных морских вод	Загрязнение акватории городскими сточными водами и сточными водами крупнейших промышленных предприятий. Часть загрязнения происходит в результате работы морского порта.	Контроль выполнения норм экологических требований законодательства судами, заходящими в акваторию порта. Детальное рассмотрение эффективности и аккуратности выполнения перегрузки сыпучих грузов, таких как сера, угольный пек, собственно уголь и многие другие виды  минералов. Очистка акватории.	3	0101000020E61000009A081B9E5E8B47408978EBFCDBC54240	UNSOLVED	4	1
155	Огромная мусорка	Огромные горы мусора, которые лежат годами и не перерабатываются. Мусор на эту свалку сводят не только со всего города и близлежащих поселков но и с других городов. Наш город как мусорный склад.	Решение проблемы переработки мусора и отходов в стране -первоочередная задача! Никто не хочет заниматься этой грязной работой, бизнесменам не выгодно содержать перерабатываются заводы т.к нет выгоды и перспектив использования переработанных материалов.. Нужно найти применение для переработанных отходов, заинтересовать нужных людей в полезности таких предприятий.	3	0101000020E610000032569BFF579147405C76887FD8D04240	UNSOLVED	2	1
156	Проблема разрушенных дамб пресноводных ставков	В степи разрушены дамбы пресноводных ставков, Вода в степи - определяющий фактор. 	Необходимо восстанавливать дамбв по примеру Акций Украинского обществыа охраны птиц летом- осенью  2013 года.	3	0101000020E6100000975643E21EA9464043C879FF1F374240	UNSOLVED	4	1
158	Слив с заводского отстойника непосредственно в море	Металлургический комбинат Азовсталь имеет на своей территории отстойник промышленной воды, но вот уже долгое время отстойник прорвал и грязная, технологическая воды вылевается непосредственно в море. Это черное пятно грязной воды видно с воздуха	Потребовать у руководства комбината провести ремонтные работы отстойника и очистных сооружений для предотвращения попадания в воду промышленных, токсичных отходов	3	0101000020E61000007218CC5F218B47403ACB2C42B1CF4240	UNSOLVED	5	1
174	Стихійні сміттєзвалища	Стихійні сміттєзвалища на території міста	Організація прибирання	3	0101000020E6100000BA4C4D823708494007D0EFFB37273940	UNSOLVED	2	1
161	Екологічне забруднення місцевості на заповідній території Апостолівського району, Дніпропетровської області	Забруднення місцевості на заповідній території Апостолівського району викидами з заводів міста Орджонікідзе, Нікопольского району, зокрема Procter & Gamble (химический комбинат). Спроби зекономити на використанні фільтрів призводить до збільшення захворювань на онкологію та респіраторні "інфекції". Нижче стаття з сайту «Город Никополь» : С конца июля жители города неоднократно жаловались на то, что в их домах и квартирах появляется пыль темного цвета с отвратительным запахом, которая к тому же почти не смывается.\nПричем подобные случаи фиксировались в разных районах города, в том районах городской больницы, и даже центральной площади им. Ивана Сирко! При этом никаких комментариев от властей по этому поводу до сих пор не последовало. Хотя с почти что 100%-й уверенностью можно говорить, что причиной загрязнения являются промышленные выбросы.	Версий об источнике загрязнения ходит несколько. Некоторые причиной выбросов называют работу местной Богдановской обогатительнйо фабрики, которая расположена относительно недалеко. Но многие кивают в сторону завода бытовой химии «Проктер энд Гембл», который также расположен на территории города. В этом плане стоит вспомнить тот факт, что феврале 2012 года в районе прилегающих к заводу автогаражей территория площадью примерно в 1 гектар была загрязнена неизвестным веществом, до безобразия похожей на стиральный порошок.	3	0101000020E61000008542041C42D54740637FD93D79084140	UNSOLVED	1	1
163	Дышим хлором , берилием , бензолом , натрийдихлофокперит , и вообще проблема уже 115 лет	Заводы - 2 крупнейших металлургических комбината , которые выбрасывают   850 млн. тонн отравляющих веществ , мы тут все от рака лёгких дохнем !!!	поставить долбанные фильтры на трубы , хоть белирий с хлором вдыхать не будем , и бензола паубавится 	3	0101000020E61000004F1F813FFC8C4740CFDC43C2F7CC4240	UNSOLVED	7	1
164	Озеро Снітинка біля Фастова	Нечистоти з міста Фастів, викидаються у озеро. 	Ремонт(побудова) очисних споруд.	3	0101000020E6100000B4CBB73EAC0D4940E466B8019FF73D40	UNSOLVED	4	1
165	Сміття	Прикро бачити коли люди проходячи кожного дня лісосмугою викидають там сміття із дому йдучи дорогою до дому.  Підлітки підтримують таку тенденцію і теж смітять обгортками і пляшками. І як з цим боротися?!.	Напевно варто поставити бак для сміття. Але хто має оплачувати послуги ЖЕКу?	3	0101000020E61000001EE1B4E0459949400F09DFFB1BB43840	UNSOLVED	2	1
166	Вирубка лісу	Йде активна вирубка лісу на горі, над селом, розбивається дорога, висохли джерела, зникли тварини, галявини всі зруйновані самоскидами...	З"ясувати до якого лісгоспу відноситься ця ділянка, вияснити хто займається вирубкою	3	0101000020E610000058ACE122F7584840AD342905DD663640	UNSOLVED	1	1
167	Загрязнена річка	Із-за Корсунь-Шевченківської ГЕС рівень річки Рось значно знизився, і ріка почала заростати. Також не добросовісні житалі викидають в річку сміття, що призвело до загрязнення річки. В Росі зменшилась кількість риби майже до мінімуму.	Провести відкриття шлюзів щоб змити зарослі ділянки річки. Провести акцію по чистці річки. Посилити контроль від браконєрства. 	3	0101000020E61000004016A243E0B4484055FA0967B7423F40	UNSOLVED	4	1
168	Сміттєзвалище біля джерела води	Неохайно організоване офіційне сміттєзвалище знаходиться за 40 метрів від старовинного польового джерела питної води.	\nПеренести сміттєзвалище на будь-яку відстань від даного місця (територія це дозволяє).	3	0101000020E61000003259DC7F643A4940EE06D15AD19E3C40	UNSOLVED	2	1
169	Срублено здоровое дерево	Абсолютно здоровое дерево, которое только начало цвести, срубил какой-то замечательный человек 29.04.2014.	Найти и выписать солиднейший штраф: дерево не на частной территории, чтобы кто-то имел право принимать самовольное решение о его уничтожении.	3	0101000020E61000002CF3565D873E474014B1886187AD3E40	UNSOLVED	1	1
170	Слив канализации в озеро	Один из частников сливает продукты своей жизнедеятельности в озеро. Если пройти от спуска с улицы Озерной вдоль ставка по узенькой тропке, рано или поздно натолкнешься на метровую "речку" отходов, идущую с частной территории.	Собрать деньги на лопату частнику, чтобы он мог вырыть себе выгребную яму, и сдать его в руки властям за преступление против общества и своих соседей.	3	0101000020E61000005D6A847EA64047405E4C33DDEBB03E40	UNSOLVED	7	1
171	Сміттєзвалище	Сміттєзвалище	Впорядкувати силами місцевої громади, місцевих органів самоврядування	3	0101000020E610000057B5A4A31CB248404C7155D977FD3840	UNSOLVED	2	1
172	Сміттєзвалище	Мешканці однієї з вулиць, створили власне сміттєзвалище, звісно ж несанкціоноване!\nЇдеш через це село, аж самому не приємно що на в\\'їзді таке твориться.	Притягнути до адміністративної відповідальності винуватців і заставити поприбирати! Покласти відповідальність за вирішення цього на органи місцевого самоврядування і дільничного інспектора.	3	0101000020E6100000CA8B4CC0AFA948403F70952710FE3840	UNSOLVED	2	1
173	Грибовицьке сміттєзвалище	Переповнене Грибовицьке сміттєзвалище.	Почати рекультивацію спільно з Львівською міською радою	3	0101000020E6100000D9B27C5D86F34840DE8D058541093840	UNSOLVED	2	1
176	Парк завалений сміттям, яке періодично залишають відпочиваючі	Парк "Перемога" завалений сміттям, яке періодично залишають відпочиваючі. В частині парку сміття ніхто не прибирає.	Ретельніше прибирати парк. Посилити відповідальність за засмічування території. 	3	0101000020E6100000D07CCEDDAE3B49405F61C1FD809B3E40	UNSOLVED	2	1
177	Стихійні звалища на Вінниччині, проблема утилізації відходів	Глобальна проблема Вінниччини - більше 3000 стихійних звалищ, які шкодять природі і не відповідають санітарним нормам. В багатьх населених пунктах відсутні сміттєві баки, сміття кидають прямо на вулиці. Відсутній централізований вивіз сміття. Люди влаштовують звалища де їм заманеться.   	Посилити відповідальність за засмічування.\nПоставити сміттєві баки.\nПобудувати сміттєпереробний завод.\nВиховувати екологічну культуру.\nЗбільшити кількість прибиральників, особливо в селах	3	0101000020E61000008EE733A0DE3048400B2AAA7EA5DB3C40	UNSOLVED	1	1
178	Вирубка лісу.	В с. Карпівка, Могилів-Подільського р-ну, Вінницької обл. здійснюється вирубка лісу. Законна чи ні не відомо, але її необхідно зупинити. На території лісу росте велика кількість різних рослин. Багато з яких знаходяться під охороною(Червона книга України) оскільки є рідкісними.	Я готовий почати вирішення цієї проблеми але мені необхідна юридична допомога.	3	0101000020E6100000DE0033DFC13D4840E012807F4ADD3B40	UNSOLVED	1	1
179	Сміттєзвалища	Мусорная свалка в городе. Мусор разлетается на всю округу загрязняя близлежащий жилой массив и лес.	Отдать мусороперерабатывающим компаниям. Организовать новую свалку дальше от города и жилых массивов.	3	0101000020E6100000ED2AA4FCA47C464028F04E3E3D164140	UNSOLVED	1	1
181	Повсеместная рубка леса вокруг Харькова	Лес рубится делянками 500*500 метров подальше от населенных пунктов,что бы меньше видели.Ближе к городу рубят выборочно лучшие деревья.То что ближе к городу в основном ночью дабы не привлекать внимания.И это не санитарная а промышленная рубка.	Проверить законность,разрешение. Перевести эти леса в заповедный фонд.Это ведь чистый воздух для такого большого промышленного города как Харьков.   	3	0101000020E61000002EFF21FDF6014940A12FBDFDB9144240	UNSOLVED	1	1
182	Истребление Байбака(сурка)	Охота из автомобилей. Сурок авто не боится подпускает близко это его и губит.Численность катастрофически снизилась.Если срочно не принять меры по защите в этом регионе может совсем исчезнуть.	Взять под охрану Красной книги.Привлекать для охраны местные общества охотников и неравнодушных граждан.	3	0101000020E6100000EDB776A224E248400B630B410EA04240	UNSOLVED	6	1
183	Забруднена водойма	Забруднена річка Золотоношка через недостатню роботу очисних споруд.	Покращення якості очисних споруд, контроль за викидами в річку.	3	0101000020E61000003FE603029DC94840341477BCC90B4040	UNSOLVED	4	1
184	Забруднене озеро	Забруднене озеро, за 30 років серія озер, в якому купались люди, перетворилось на замулене болото, в яке з часом ще й почали викидати сміття 	Очистити озеро	3	0101000020E610000000AC8E1CE93249403D47E4BB946E3E40	UNSOLVED	4	1
185	Забруднення водойм	Міське озеро забруднюється сміттям, що призводить до його пересихання, хоча воно є місцем існування багатьох водоплаваючих птахів	Очищення озера від сміття, просвітницька робота серед населення	3	0101000020E6100000FD2FD7A2050A4940E754320054293940	UNSOLVED	4	1
186	Стихійне сміттєзвалище	Дане сміттєзвалище розміщується у місті Снятин Івано-Франківської області і знаходиться недалеко від будинків, де проживають люди, приблизно 250-300 метрів. І практично щовечора по прилеглих вулицях стоїть важкий смердючий смог. Неможливо навіть вийти надвір. Біля звалища протікає струмок. Сміттєзвалище є стихійним і жодних документів на його експлуатування немає, але сміття все одно звозиться на протязі багатьох років. Недавно було зафіксовано, що сміття почали звозити не тільки з міста, а й сіл району, та ще й з сусідніх районів. Жителі прилеглих вулиць неодноразово звертались до влади міста з проханням закрити звалище, але і колишня влада, і теперішня мають 1000 і 1 відговірку: то якийсь проект виробляють, то кошів немає і т. д. А люди всеодно змушені страждати.	Сміттєзвалище закрити, як таке і ліквідувати всю його непоправну шкоду. Винних в незаконному експлуатуванні - покарати!!!	3	0101000020E6100000554FE61F7D3948401C7DCC0704963940	UNSOLVED	2	1
187	Стврено сміттєзвалище на місці водовідводного каналу	Стврено сміттєзвалище на місці водовідводного каналу, люди викитають сміття яке не перегниває так як не хочуть оплачувати сміттєзбір 	Повідомити місцеву владу, виявити порушників, прибрати	3	0101000020E6100000C2FBAA5CA8464940BCADF4DA6C1C3E40	UNSOLVED	2	1
188	Річка	Не знаю, який унікум поряд описав проблему про Корсунь-Шевченківську дамбу яка буцімто не пускає воду, але вірити цьому не варто. Тому що проблема почалась десяток років назад коли прорили штучний канал з річки Рось до міста Умань, для водопостачання всього міста, де вони і відводять штучно левову частку води. Тому починати з відновлення Річки РОСЬ потрібно тільки з штучного каналу в місто Умань.	Очищення річки, перевірка штучних каналів. 	3	0101000020E6100000B85B920376B348408D5DA27A6B403F40	UNSOLVED	4	1
193	Мусор под домом	опис відсутній	Дворникам было бы неплохо чаще обходить дом с другой стороны	1	0101000020E6100000EA3C2AFEEF364840DE1E84807C5B4140	UNSOLVED	2	1
195	Вирубують ліс	Вирубують ліс. Не зрозуміло, чи це законно?	Перевірити, чи законна вирубка лісу.	3	0101000020E6100000359BC761303F4940DFA9807B9EFF3D40	UNSOLVED	1	1
200	Cкупчення мусору біля Водограю	В районі водограю з прекрасною та чистою водою постійно нагромаджується велика кількість сміття від місцевих жителів та туристів.	Розміщення смітників а також звернення знаком про дотримання екологічної безпеки.\r\n	1	0101000020E61000002C0E677E35AD4840A5F622DA8E3D3740	UNSOLVED	2	1
255	Незаконна забудова в селі Чубинське	Біля  комплексу новобудов почались підготовчі роботи компанії ШЕЛЬФ, ТОРГІВЕЛЬНИЙ ДІМ, які проходять без додержання норм будівництва і негативно впливають на довкілля.\r\nПроводилась зустріч з керівництвом метою якої було: ознайомлення громади із специфікою діяльності підприємства, документального підтвердження оприлюднення прийнятих рішень щодо розроблення проектів містобудівної документації з прогнозованими правовими, економічними та екологічними наслідками. Але зустріч не дала ніякого результату, ніякої точної інформації щодо документального підтвердження правових, економічних та екологічних наслідків .\r\nСільська рада без документів ШЕЛЬФА приймає рішення, щодо затвердження плану будівництва, громадські слухання проходить без громадського обговорення, депутати сільської ради планують в грудні 2014 (дата не відома) затверди право діяльності підприємства ШЕЛЬФ (надати дозвіл на виробництво( за словами керівництва ШЕЛЬФА тільки офісно-складські приміщення) без документів підприємству, \r\n	На сьогоднішній день, основними питаннями є:\r\n1) Підприємство офіційно не зареєстровано? (проходить реєстрацію) Буде реєстрація Бориспільського р-ну.\r\n2) Земельна ділянка проходить зміну призначення.\r\n3) Громадські слухання з громадою не проводилися.\r\n4) Немає генерального плану забудови.\r\n5) Немає висновків державних інститутів щодо прогнозів правових, економічних та екологічних наслідків.\r\n\r\nПідкажіть, будь ласка, до кого нам звертатись щодо отримання пояснень, особливо з питань впливу на довкілля, також норм розташування підприємств біля житлових комплексів.	3	0101000020E61000001A170E846431494003CDE7DCEDD63E40	UNSOLVED	3	1
279	Незаконна вирубка лісів	Незаконне вирубування лісів. пошкодження лісової підстилки, нехтування правилами заготівлі деревин	Збільшення контролю за здіснення незаконного вирубування лісів, накладання штрафу за пошкодження лісової підстилки, збільшення контролю за правилами заготівлі деревини	1	0101000020E6100000672783A3E4E949404ED367075CB73940	UNSOLVED	1	1
354	Завод Радикал - майже 100 тисяч тон ртутьвмісних відходів	Токсичні відходи ртуті. На вивезення їх у держави вже багато років немає грошей.	Фінансувати вивезення та безпечну для природи утилізацію ртутьвмісних відходів.	1	0101000020E610000094F6065F983A4940535E2BA1BBA43E40	UNSOLVED	7	1
\.


--
-- Data for Name: problems_activities; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY problems_activities (id, problem_id, user_id, datetime, activity_type) FROM stdin;
1	2	\N	2014-02-19 14:00:50	ADDED
2	3	\N	2014-02-26 14:09:47	ADDED
3	4	\N	2014-02-26 18:45:04	ADDED
4	5	\N	2014-02-27 17:24:53	ADDED
5	6	\N	2014-02-18 17:54:51	ADDED
6	8	\N	2014-02-27 20:16:08	ADDED
7	9	\N	2014-02-27 20:29:48	ADDED
8	10	\N	2014-02-27 20:37:27	ADDED
9	11	\N	2014-02-27 23:15:33	ADDED
10	12	\N	2014-03-02 22:25:39	ADDED
11	13	\N	2014-03-02 22:35:18	ADDED
12	14	\N	2014-03-03 13:09:47	ADDED
13	18	\N	2014-03-03 14:39:08	ADDED
14	19	\N	2014-03-03 16:15:34	ADDED
15	20	\N	2014-03-06 18:59:10	ADDED
16	22	\N	2014-03-11 13:28:18	ADDED
17	25	\N	2014-03-14 17:10:33	ADDED
18	26	\N	2014-03-17 15:24:58	ADDED
19	28	\N	2014-03-17 16:23:07	ADDED
20	29	\N	2014-03-17 16:39:06	ADDED
21	30	\N	2014-03-17 18:21:55	ADDED
22	31	\N	2014-03-18 08:14:00	ADDED
23	32	\N	2014-03-18 08:14:27	ADDED
24	33	\N	2014-03-18 11:14:05	ADDED
25	34	\N	2014-03-18 14:21:22	ADDED
26	36	\N	2014-03-18 14:36:04	ADDED
27	37	\N	2014-03-18 15:51:48	ADDED
28	39	\N	2014-03-18 16:54:31	ADDED
29	40	\N	2014-03-18 17:35:47	ADDED
30	41	\N	2014-03-18 18:36:33	ADDED
31	42	\N	2014-03-18 23:41:47	ADDED
32	43	\N	2014-03-19 07:04:12	ADDED
33	44	\N	2014-03-19 20:09:36	ADDED
34	45	\N	2014-03-19 13:06:54	ADDED
35	46	\N	2014-03-20 08:08:28	ADDED
36	48	\N	2014-03-25 06:22:50	ADDED
37	49	\N	2014-03-25 11:04:22	ADDED
38	50	\N	2014-03-25 19:50:14	ADDED
39	51	\N	2014-03-25 20:16:53	ADDED
40	53	\N	2014-03-25 21:48:56	ADDED
41	54	\N	2014-03-26 14:12:01	ADDED
42	55	\N	2014-03-26 14:15:11	ADDED
43	56	\N	2014-03-26 15:34:09	ADDED
44	58	\N	2014-03-26 16:10:04	ADDED
45	59	\N	2014-03-26 16:13:06	ADDED
46	61	\N	2014-03-26 16:15:14	ADDED
47	63	\N	2014-03-26 16:16:57	ADDED
48	66	\N	2014-03-26 16:25:12	ADDED
49	67	\N	2014-03-26 16:25:31	ADDED
50	69	\N	2014-03-26 16:35:05	ADDED
51	71	\N	2014-03-26 16:39:53	ADDED
52	72	\N	2014-03-26 16:43:56	ADDED
53	73	\N	2014-03-26 17:00:23	ADDED
54	74	\N	2014-03-26 17:11:29	ADDED
55	75	\N	2014-03-26 17:15:06	ADDED
56	76	\N	2014-03-26 17:47:51	ADDED
57	79	\N	2014-03-26 18:28:10	ADDED
58	80	\N	2014-03-26 18:45:01	ADDED
59	81	\N	2014-03-26 19:04:12	ADDED
60	82	\N	2014-03-26 19:20:33	ADDED
61	83	\N	2014-03-26 19:22:43	ADDED
62	84	\N	2014-03-26 19:59:57	ADDED
63	85	\N	2014-03-26 20:06:30	ADDED
64	86	\N	2014-03-26 20:14:12	ADDED
65	88	\N	2014-03-26 21:33:02	ADDED
66	89	\N	2014-03-26 21:48:47	ADDED
67	90	\N	2014-03-26 22:34:45	ADDED
68	91	\N	2014-03-26 22:55:33	ADDED
69	93	\N	2014-03-27 07:03:44	ADDED
70	94	\N	2014-03-27 07:11:51	ADDED
71	95	\N	2014-03-27 07:15:51	ADDED
72	96	\N	2014-03-27 07:31:38	ADDED
73	97	\N	2014-03-27 07:35:11	ADDED
74	98	\N	2014-03-27 07:40:13	ADDED
75	101	\N	2014-03-27 07:52:00	ADDED
76	102	\N	2014-03-27 07:53:39	ADDED
77	104	\N	2014-03-27 08:10:58	ADDED
78	105	\N	2014-03-27 08:12:20	ADDED
79	107	\N	2014-03-27 09:45:43	ADDED
80	108	\N	2014-03-27 09:49:10	ADDED
81	109	\N	2014-03-27 09:51:14	ADDED
82	110	\N	2014-03-27 09:51:35	ADDED
83	112	\N	2014-03-27 10:03:00	ADDED
84	113	\N	2014-03-27 10:08:35	ADDED
85	114	\N	2014-03-27 10:13:58	ADDED
86	116	\N	2014-03-27 10:23:08	ADDED
87	117	\N	2014-03-27 10:25:51	ADDED
88	118	\N	2014-03-27 10:28:58	ADDED
89	119	\N	2014-03-27 10:32:59	ADDED
90	120	\N	2014-03-27 10:53:02	ADDED
91	121	\N	2014-03-27 10:57:50	ADDED
92	124	\N	2014-03-27 11:12:45	ADDED
93	125	\N	2014-03-27 11:17:19	ADDED
94	126	\N	2014-03-27 11:22:22	ADDED
95	127	\N	2014-03-27 12:10:18	ADDED
96	128	\N	2014-03-27 12:18:31	ADDED
97	129	\N	2014-03-27 12:38:44	ADDED
98	130	\N	2014-03-27 12:44:55	ADDED
99	131	\N	2014-03-27 14:22:54	ADDED
100	132	\N	2014-03-27 14:48:52	ADDED
101	133	\N	2014-03-27 15:24:37	ADDED
102	134	\N	2014-03-27 15:42:40	ADDED
103	135	\N	2014-03-27 15:44:46	ADDED
104	136	\N	2014-03-27 16:58:50	ADDED
105	137	\N	2014-03-27 18:40:59	ADDED
106	138	\N	2014-03-27 18:56:15	ADDED
107	139	\N	2014-03-27 19:41:30	ADDED
108	140	\N	2014-03-27 20:34:53	ADDED
109	141	\N	2014-03-27 21:06:19	ADDED
110	142	\N	2014-03-28 00:05:32	ADDED
111	143	\N	2014-03-28 08:14:04	ADDED
112	144	\N	2014-03-28 08:17:10	ADDED
113	145	\N	2014-03-28 08:28:52	ADDED
114	146	\N	2014-03-28 12:43:00	ADDED
115	147	\N	2014-03-28 12:55:49	ADDED
116	148	\N	2014-03-28 12:59:43	ADDED
117	149	\N	2014-03-28 13:19:41	ADDED
118	150	\N	2014-03-28 20:04:24	ADDED
119	152	\N	2014-03-29 02:13:47	ADDED
120	153	\N	2014-03-29 07:11:59	ADDED
121	154	\N	2014-03-29 07:18:21	ADDED
122	155	\N	2014-03-29 10:24:00	ADDED
123	156	\N	2014-03-29 13:05:36	ADDED
124	158	\N	2014-03-29 18:14:27	ADDED
125	159	\N	2014-03-29 20:01:18	ADDED
126	160	\N	2014-03-29 23:00:19	ADDED
127	161	\N	2014-03-30 03:24:07	ADDED
128	163	\N	2014-03-30 07:58:28	ADDED
129	164	\N	2014-04-02 13:22:12	ADDED
130	165	\N	2014-04-02 20:48:29	ADDED
131	166	\N	2014-04-06 13:00:38	ADDED
132	167	\N	2014-04-06 18:14:31	ADDED
133	168	\N	2014-04-08 17:52:40	ADDED
134	169	\N	2014-04-09 17:31:42	ADDED
135	170	\N	2014-04-09 17:38:37	ADDED
136	171	\N	2014-04-09 20:19:48	ADDED
137	172	\N	2014-04-11 09:26:53	ADDED
138	173	\N	2014-04-12 13:55:59	ADDED
139	174	\N	2014-04-14 15:04:18	ADDED
140	175	\N	2014-04-18 14:24:46	ADDED
141	176	\N	2014-04-24 13:55:04	ADDED
142	177	\N	2014-04-24 14:06:52	ADDED
143	178	\N	2014-04-25 16:21:46	ADDED
144	179	\N	2014-05-06 09:46:48	ADDED
145	181	\N	2014-05-16 20:46:37	ADDED
146	182	\N	2014-05-16 22:03:48	ADDED
147	183	\N	2014-05-17 07:40:22	ADDED
148	184	\N	2014-05-18 08:25:47	ADDED
149	185	\N	2014-05-21 13:07:08	ADDED
150	186	\N	2014-05-24 22:03:54	ADDED
151	187	\N	2014-05-25 06:43:42	ADDED
152	188	\N	2014-05-26 21:10:55	ADDED
153	73	\N	2014-10-31 04:14:09	VOTE
154	81	\N	2014-10-31 13:52:46	VOTE
155	50	\N	2014-10-31 13:53:01	VOTE
156	138	\N	2014-10-31 13:53:25	VOTE
157	51	\N	2014-10-31 13:53:34	VOTE
158	28	\N	2014-10-31 13:55:26	VOTE
159	54	14	2014-10-31 19:28:28	VOTE
160	127	\N	2014-11-03 05:14:23	VOTE
161	181	\N	2014-11-03 12:29:41	VOTE
162	98	\N	2014-11-04 04:17:12	VOTE
163	173	\N	2014-11-04 08:23:38	VOTE
164	193	\N	2014-11-04 08:39:23	ADDED
165	85	\N	2014-11-04 10:10:21	VOTE
166	41	\N	2014-11-04 11:00:14	VOTE
167	19	\N	2014-11-04 11:00:21	VOTE
168	134	\N	2014-11-04 11:00:31	VOTE
169	146	\N	2014-11-04 11:00:59	VOTE
170	173	\N	2014-11-04 11:13:08	VOTE
171	9	\N	2014-11-04 14:29:40	VOTE
172	13	\N	2014-11-04 14:30:05	VOTE
173	165	16	2014-11-04 14:31:58	VOTE
174	105	16	2014-11-04 14:32:27	VOTE
175	173	\N	2014-11-04 17:06:04	VOTE
176	173	18	2014-11-04 19:15:07	VOTE
177	85	18	2014-11-04 19:15:28	VOTE
178	9	\N	2014-11-05 05:26:32	VOTE
179	9	\N	2014-11-05 06:13:03	VOTE
180	127	\N	2014-11-05 07:55:59	VOTE
181	26	\N	2014-11-05 07:56:04	VOTE
182	142	\N	2014-11-05 07:56:15	VOTE
183	195	\N	2014-11-05 08:08:59	ADDED
184	85	\N	2014-11-05 09:18:26	VOTE
185	173	\N	2014-11-05 09:18:41	VOTE
186	116	\N	2014-11-05 10:21:19	VOTE
187	55	\N	2014-11-05 10:21:25	VOTE
188	19	\N	2014-11-05 10:44:30	VOTE
189	173	\N	2014-11-05 10:53:35	VOTE
190	173	\N	2014-11-05 10:53:37	VOTE
191	173	\N	2014-11-05 10:53:38	VOTE
192	127	\N	2014-11-05 11:00:08	VOTE
193	142	\N	2014-11-05 11:01:08	VOTE
194	146	\N	2014-11-05 11:02:28	VOTE
195	165	\N	2014-11-05 14:00:48	VOTE
196	22	\N	2014-11-05 17:07:48	VOTE
197	8	\N	2014-11-05 18:32:06	VOTE
198	142	\N	2014-11-06 06:13:26	VOTE
199	33	\N	2014-11-06 06:13:49	VOTE
200	98	\N	2014-11-06 06:19:57	VOTE
201	3	\N	2014-11-06 06:37:32	VOTE
202	173	\N	2014-11-06 08:05:29	VOTE
203	56	\N	2014-11-06 08:36:03	VOTE
204	54	\N	2014-11-06 09:00:32	VOTE
205	13	\N	2014-11-06 09:47:12	VOTE
206	13	\N	2014-11-06 10:12:10	VOTE
207	29	\N	2014-11-06 11:08:45	VOTE
208	9	\N	2014-11-06 14:15:58	VOTE
209	105	\N	2014-11-06 14:16:37	VOTE
210	13	\N	2014-11-06 14:17:00	VOTE
211	85	\N	2014-11-06 14:17:15	VOTE
212	61	\N	2014-11-06 17:20:55	VOTE
213	54	\N	2014-11-07 03:29:12	VOTE
214	94	\N	2014-11-07 07:30:35	VOTE
215	95	\N	2014-11-07 07:31:27	VOTE
216	129	\N	2014-11-07 07:58:39	VOTE
217	181	\N	2014-11-07 08:14:32	VOTE
218	200	\N	2014-11-07 08:35:00	ADDED
219	75	\N	2014-11-07 11:08:57	VOTE
220	164	\N	2014-11-08 04:58:45	VOTE
221	9	\N	2014-11-08 17:11:41	VOTE
222	55	\N	2014-11-09 12:59:04	VOTE
223	116	\N	2014-11-09 12:59:16	VOTE
224	80	\N	2014-11-09 13:01:09	VOTE
225	54	\N	2014-11-09 14:34:46	VOTE
226	9	\N	2014-11-10 04:26:02	VOTE
227	134	\N	2014-11-10 09:37:10	VOTE
228	19	\N	2014-11-11 10:49:05	VOTE
229	146	\N	2014-11-11 10:49:23	VOTE
230	200	\N	2014-11-11 15:03:20	VOTE
231	74	\N	2014-11-12 04:29:32	VOTE
232	173	\N	2014-11-12 13:47:31	VOTE
233	85	\N	2014-11-12 13:48:27	VOTE
234	129	\N	2014-11-14 12:58:05	VOTE
235	178	\N	2014-11-16 11:52:51	VOTE
236	89	\N	2014-11-16 11:55:15	VOTE
237	129	\N	2014-11-17 12:20:12	VOTE
238	10	\N	2014-11-18 10:23:51	VOTE
239	28	\N	2014-11-18 10:25:37	VOTE
240	69	\N	2014-11-18 10:39:51	VOTE
241	89	\N	2014-11-19 16:36:38	VOTE
242	178	\N	2014-11-19 16:36:42	VOTE
243	163	\N	2014-11-21 12:53:40	VOTE
244	145	\N	2014-11-21 12:59:39	VOTE
245	9	\N	2014-11-21 15:02:17	VOTE
246	105	\N	2014-11-21 15:02:28	VOTE
247	185	\N	2014-11-24 16:01:43	VOTE
248	174	\N	2014-11-24 16:02:17	VOTE
249	142	\N	2014-11-25 06:00:25	VOTE
250	18	\N	2014-11-25 06:00:32	VOTE
251	86	\N	2014-11-25 06:00:39	VOTE
252	129	\N	2014-11-25 06:01:03	VOTE
253	20	\N	2014-11-25 06:01:04	VOTE
254	19	\N	2014-11-25 06:02:12	VOTE
255	146	\N	2014-11-25 06:02:17	VOTE
256	41	\N	2014-11-25 06:07:16	VOTE
257	41	\N	2014-11-25 06:07:19	VOTE
258	134	\N	2014-11-25 06:08:07	VOTE
259	184	\N	2014-11-25 06:08:42	VOTE
260	36	\N	2014-11-25 06:08:58	VOTE
261	88	\N	2014-11-25 06:10:00	VOTE
262	86	\N	2014-11-25 06:10:33	VOTE
263	18	\N	2014-11-25 06:10:36	VOTE
264	86	\N	2014-11-25 06:10:56	VOTE
265	18	\N	2014-11-25 06:11:20	VOTE
266	73	\N	2014-11-25 06:11:31	VOTE
267	20	\N	2014-11-25 06:15:30	VOTE
268	55	\N	2014-11-25 06:16:09	VOTE
269	6	\N	2014-11-25 06:16:58	VOTE
270	30	\N	2014-11-25 06:20:53	VOTE
271	176	\N	2014-11-25 06:21:01	VOTE
272	195	\N	2014-11-25 06:25:59	VOTE
273	134	\N	2014-11-25 06:28:19	VOTE
274	19	\N	2014-11-25 06:28:36	VOTE
275	18	\N	2014-11-25 06:35:36	VOTE
276	96	\N	2014-11-25 06:36:06	VOTE
277	183	\N	2014-11-25 06:51:52	VOTE
278	8	\N	2014-11-25 06:54:46	VOTE
279	18	\N	2014-11-25 06:58:04	VOTE
280	51	\N	2014-11-25 07:04:36	VOTE
281	81	\N	2014-11-25 07:05:10	VOTE
282	50	\N	2014-11-25 07:05:20	VOTE
283	176	35	2014-11-25 07:09:51	VOTE
284	109	35	2014-11-25 07:13:39	VOTE
285	41	\N	2014-11-25 07:26:04	VOTE
286	128	\N	2014-11-25 07:40:10	VOTE
287	152	35	2014-11-25 07:48:08	VOTE
288	164	\N	2014-11-25 07:58:25	VOTE
289	31	\N	2014-11-25 08:03:08	VOTE
290	134	\N	2014-11-25 08:15:28	VOTE
291	136	\N	2014-11-25 08:16:28	VOTE
292	128	\N	2014-11-25 08:32:29	VOTE
293	113	\N	2014-11-25 08:33:21	VOTE
294	112	\N	2014-11-25 08:33:38	VOTE
295	88	\N	2014-11-25 08:34:08	VOTE
296	101	\N	2014-11-25 08:36:32	VOTE
297	133	\N	2014-11-25 08:37:11	VOTE
298	79	\N	2014-11-25 08:52:39	VOTE
299	117	\N	2014-11-25 08:54:18	VOTE
300	101	\N	2014-11-25 08:54:55	VOTE
301	102	\N	2014-11-25 08:55:04	VOTE
302	19	\N	2014-11-25 09:00:29	VOTE
303	146	\N	2014-11-25 09:00:57	VOTE
304	41	\N	2014-11-25 09:01:16	VOTE
305	121	\N	2014-11-25 09:04:39	VOTE
306	146	\N	2014-11-25 09:17:06	VOTE
307	152	\N	2014-11-25 09:18:57	VOTE
308	146	\N	2014-11-25 09:30:48	VOTE
309	41	\N	2014-11-25 09:51:33	VOTE
310	152	\N	2014-11-25 09:52:09	VOTE
311	134	\N	2014-11-25 09:52:24	VOTE
312	132	\N	2014-11-25 09:53:54	VOTE
313	2	\N	2014-11-25 09:59:51	VOTE
314	93	\N	2014-11-25 10:30:02	VOTE
315	73	\N	2014-11-25 10:45:46	VOTE
316	86	\N	2014-11-25 10:46:56	VOTE
317	18	\N	2014-11-25 10:48:07	VOTE
318	8	\N	2014-11-25 10:50:15	VOTE
319	176	\N	2014-11-25 10:50:48	VOTE
320	152	\N	2014-11-25 10:51:16	VOTE
321	160	\N	2014-11-25 11:02:35	VOTE
322	49	\N	2014-11-25 11:02:52	VOTE
323	86	\N	2014-11-25 11:03:11	VOTE
324	18	\N	2014-11-25 11:04:00	VOTE
325	176	\N	2014-11-25 11:20:49	VOTE
326	41	\N	2014-11-25 11:23:29	VOTE
327	19	\N	2014-11-25 11:23:53	VOTE
328	34	\N	2014-11-25 11:36:32	VOTE
329	146	\N	2014-11-25 11:37:07	VOTE
330	20	\N	2014-11-25 12:10:13	VOTE
331	6	\N	2014-11-25 12:11:08	VOTE
332	8	\N	2014-11-25 12:11:33	VOTE
333	73	\N	2014-11-25 12:21:50	VOTE
334	8	\N	2014-11-25 12:22:07	VOTE
335	45	\N	2014-11-25 12:23:06	VOTE
336	97	\N	2014-11-25 12:51:18	VOTE
337	53	\N	2014-11-25 12:51:35	VOTE
338	195	\N	2014-11-25 13:06:19	VOTE
339	49	\N	2014-11-25 13:12:58	VOTE
340	26	\N	2014-11-25 13:20:36	VOTE
341	26	\N	2014-11-25 13:20:37	VOTE
342	79	\N	2014-11-25 13:29:36	VOTE
343	102	\N	2014-11-25 13:29:44	VOTE
344	8	\N	2014-11-25 13:30:55	VOTE
345	6	\N	2014-11-25 13:32:03	VOTE
346	195	\N	2014-11-25 13:32:52	VOTE
347	59	\N	2014-11-25 13:33:10	VOTE
348	82	\N	2014-11-25 13:34:22	VOTE
349	164	\N	2014-11-25 15:43:14	VOTE
350	173	\N	2014-11-25 15:45:27	VOTE
351	4	\N	2014-11-25 15:45:40	VOTE
352	30	\N	2014-11-25 15:53:19	VOTE
353	200	\N	2014-11-25 16:18:54	VOTE
354	152	\N	2014-11-25 17:26:45	VOTE
355	170	\N	2014-11-25 17:39:58	VOTE
356	76	\N	2014-11-25 17:41:34	VOTE
357	73	\N	2014-11-25 17:45:49	VOTE
358	76	\N	2014-11-25 17:50:28	VOTE
359	26	\N	2014-11-25 18:04:05	VOTE
360	86	\N	2014-11-25 18:31:01	VOTE
361	86	\N	2014-11-25 20:16:12	VOTE
362	146	\N	2014-11-26 10:00:04	VOTE
363	19	\N	2014-11-26 10:00:24	VOTE
364	41	\N	2014-11-26 10:00:58	VOTE
365	49	\N	2014-11-26 10:01:58	VOTE
366	160	\N	2014-11-26 10:02:27	VOTE
367	91	\N	2014-11-26 10:02:36	VOTE
368	31	\N	2014-11-26 10:05:09	VOTE
369	152	\N	2014-11-26 10:08:19	VOTE
370	104	\N	2014-11-26 10:09:14	VOTE
371	36	\N	2014-11-26 10:09:32	VOTE
372	184	\N	2014-11-26 10:09:35	VOTE
373	9	\N	2014-11-26 10:19:35	VOTE
374	181	\N	2014-11-27 05:02:50	VOTE
375	53	\N	2014-11-27 05:04:51	VOTE
376	84	\N	2014-11-28 06:19:16	VOTE
377	53	\N	2014-11-28 06:19:20	VOTE
378	128	\N	2014-11-28 08:03:51	VOTE
379	45	\N	2014-11-28 18:36:24	VOTE
380	73	\N	2014-11-28 20:51:37	VOTE
381	181	\N	2014-11-29 15:34:31	VOTE
382	53	\N	2014-11-29 15:34:44	VOTE
383	18	\N	2014-11-29 15:40:29	VOTE
384	9	\N	2014-11-29 17:45:10	VOTE
385	39	\N	2014-11-29 18:40:56	VOTE
386	118	\N	2014-11-29 18:41:22	VOTE
387	79	\N	2014-11-29 18:41:58	VOTE
388	102	\N	2014-11-29 18:42:25	VOTE
389	173	\N	2014-11-30 18:37:56	VOTE
390	181	\N	2014-12-01 04:24:19	VOTE
391	61	\N	2014-12-01 04:24:28	VOTE
392	53	\N	2014-12-01 04:24:46	VOTE
393	84	\N	2014-12-01 04:24:52	VOTE
394	161	\N	2014-12-01 04:34:21	VOTE
395	181	\N	2014-12-01 12:33:04	VOTE
396	97	\N	2014-12-01 12:34:05	VOTE
397	29	52	2014-12-02 08:46:22	VOTE
398	166	52	2014-12-02 08:47:09	VOTE
399	6	\N	2014-12-04 07:43:28	VOTE
400	98	\N	2014-12-05 11:29:20	VOTE
401	255	\N	2014-12-09 09:52:49	ADDED
402	255	\N	2014-12-09 11:20:16	VOTE
403	195	\N	2014-12-15 06:07:51	VOTE
404	187	\N	2014-12-15 06:08:31	VOTE
405	200	\N	2014-12-15 08:26:44	VOTE
406	279	64	2014-12-16 15:13:37	ADDED
407	74	\N	2014-12-17 11:59:20	VOTE
408	54	\N	2014-12-17 12:00:36	VOTE
409	195	\N	2014-12-18 14:22:45	VOTE
410	166	\N	2014-12-18 14:25:41	VOTE
411	129	\N	2014-12-18 14:27:25	VOTE
412	45	\N	2014-12-21 04:10:35	VOTE
413	133	\N	2014-12-21 09:42:23	VOTE
414	88	15	2014-12-22 07:10:17	VOTE
415	98	15	2014-12-22 07:10:49	VOTE
416	164	\N	2014-12-24 07:32:17	VOTE
417	132	\N	2014-12-27 11:24:05	VOTE
418	129	\N	2014-12-30 12:25:50	VOTE
419	86	78	2015-01-07 06:31:34	VOTE
420	18	\N	2015-01-08 08:31:02	VOTE
421	129	\N	2015-01-12 17:08:00	VOTE
422	54	\N	2015-01-15 12:32:08	VOTE
423	156	\N	2015-01-16 18:27:08	VOTE
424	129	\N	2015-01-29 10:32:58	VOTE
425	54	\N	2015-01-29 10:33:48	VOTE
426	66	\N	2015-01-29 15:27:20	VOTE
427	127	\N	2015-01-30 09:47:30	VOTE
428	90	\N	2015-01-30 10:02:49	VOTE
429	145	\N	2015-02-02 05:41:28	VOTE
430	163	\N	2015-02-02 05:55:36	VOTE
431	29	\N	2015-02-02 05:57:45	VOTE
432	166	\N	2015-02-02 05:58:31	VOTE
433	40	\N	2015-02-02 05:59:01	VOTE
434	55	\N	2015-02-04 18:49:32	VOTE
435	116	\N	2015-02-04 18:50:05	VOTE
436	82	\N	2015-02-04 18:50:35	VOTE
437	173	\N	2015-02-10 07:47:37	VOTE
438	39	\N	2015-02-11 19:11:57	VOTE
439	145	85	2015-02-11 19:30:51	VOTE
440	56	\N	2015-02-14 11:39:22	VOTE
441	174	\N	2015-02-14 15:21:06	VOTE
442	185	\N	2015-02-14 15:21:33	VOTE
443	185	\N	2015-02-19 06:35:42	VOTE
444	174	\N	2015-02-19 06:35:49	VOTE
445	176	\N	2015-02-20 07:56:04	VOTE
446	9	\N	2015-02-20 08:29:59	VOTE
447	18	\N	2015-02-22 19:32:35	VOTE
448	18	\N	2015-02-23 07:01:00	VOTE
449	86	81	2015-02-23 08:23:44	VOTE
450	45	\N	2015-02-25 10:57:05	VOTE
451	185	\N	2015-02-26 03:25:35	VOTE
452	174	\N	2015-02-26 03:25:46	VOTE
453	185	\N	2015-02-26 03:50:10	VOTE
454	174	\N	2015-02-26 03:50:14	VOTE
455	3	\N	2015-02-26 07:44:32	VOTE
456	185	\N	2015-02-26 12:42:28	VOTE
457	174	\N	2015-02-26 12:43:17	VOTE
458	185	\N	2015-02-26 15:28:03	VOTE
459	174	\N	2015-02-26 15:28:11	VOTE
460	183	\N	2015-02-27 03:23:39	VOTE
461	185	\N	2015-02-27 06:24:55	VOTE
462	174	\N	2015-02-27 06:25:01	VOTE
463	4	\N	2015-02-27 09:59:57	VOTE
464	185	\N	2015-02-27 13:49:23	VOTE
465	174	\N	2015-02-27 13:49:27	VOTE
466	185	\N	2015-02-28 17:39:00	VOTE
467	174	\N	2015-02-28 17:39:04	VOTE
468	185	\N	2015-03-01 07:33:52	VOTE
469	174	\N	2015-03-01 07:33:56	VOTE
470	88	\N	2015-03-01 15:03:51	VOTE
471	88	\N	2015-03-01 15:03:51	VOTE
472	56	\N	2015-03-01 15:48:12	VOTE
473	18	\N	2015-03-02 07:52:29	VOTE
474	185	\N	2015-03-02 12:55:06	VOTE
475	174	\N	2015-03-02 12:55:09	VOTE
476	185	\N	2015-03-03 05:40:55	VOTE
477	174	\N	2015-03-03 05:40:59	VOTE
478	185	\N	2015-03-03 15:49:54	VOTE
479	174	\N	2015-03-03 15:50:00	VOTE
480	142	95	2015-03-03 16:42:29	VOTE
481	185	\N	2015-03-04 12:36:25	VOTE
482	174	\N	2015-03-04 12:36:28	VOTE
483	174	\N	2015-03-04 12:47:59	VOTE
484	185	\N	2015-03-04 12:48:07	VOTE
485	174	\N	2015-03-04 13:10:05	VOTE
486	185	\N	2015-03-04 13:10:11	VOTE
487	101	81	2015-03-05 05:57:57	VOTE
488	56	\N	2015-03-05 07:43:26	VOTE
489	185	\N	2015-03-05 14:47:06	VOTE
490	174	\N	2015-03-05 14:47:11	VOTE
491	119	\N	2015-03-05 14:49:52	VOTE
492	135	\N	2015-03-05 14:50:28	VOTE
493	174	\N	2015-03-05 16:07:56	VOTE
494	185	\N	2015-03-05 16:08:02	VOTE
495	174	\N	2015-03-06 07:56:31	VOTE
496	185	\N	2015-03-06 09:27:14	VOTE
497	174	\N	2015-03-06 09:27:18	VOTE
498	185	\N	2015-03-06 13:59:08	VOTE
499	174	\N	2015-03-06 13:59:11	VOTE
500	146	\N	2015-03-06 18:27:50	VOTE
501	134	\N	2015-03-06 18:28:14	VOTE
502	185	\N	2015-03-07 14:14:15	VOTE
503	174	\N	2015-03-07 14:14:20	VOTE
504	185	103	2015-03-07 14:22:01	VOTE
505	185	103	2015-03-07 14:23:58	VOTE
506	185	104	2015-03-07 18:37:32	VOTE
507	174	104	2015-03-07 18:37:41	VOTE
508	85	104	2015-03-07 18:38:16	VOTE
509	185	\N	2015-03-08 12:26:22	VOTE
510	174	\N	2015-03-08 12:27:18	VOTE
511	185	\N	2015-03-08 15:09:09	VOTE
512	174	\N	2015-03-08 15:09:12	VOTE
513	185	\N	2015-03-09 09:12:29	VOTE
514	174	\N	2015-03-09 09:12:33	VOTE
515	185	\N	2015-03-09 09:50:03	VOTE
516	174	\N	2015-03-09 09:50:16	VOTE
517	185	\N	2015-03-09 13:53:53	VOTE
518	174	\N	2015-03-09 13:53:57	VOTE
519	185	\N	2015-03-09 15:21:32	VOTE
520	174	\N	2015-03-09 15:21:36	VOTE
521	118	\N	2015-03-09 22:09:51	VOTE
522	39	\N	2015-03-09 22:09:56	VOTE
523	185	\N	2015-03-10 04:51:10	VOTE
524	174	\N	2015-03-10 04:51:16	VOTE
525	185	\N	2015-03-10 08:15:44	VOTE
526	174	\N	2015-03-10 08:15:48	VOTE
527	185	\N	2015-03-10 12:49:57	VOTE
528	174	\N	2015-03-10 12:50:00	VOTE
529	185	\N	2015-03-10 15:30:55	VOTE
530	174	\N	2015-03-10 15:30:59	VOTE
531	185	\N	2015-03-10 16:48:21	VOTE
532	185	\N	2015-03-10 16:48:44	VOTE
533	174	\N	2015-03-10 16:48:48	VOTE
534	174	\N	2015-03-11 05:07:46	VOTE
535	185	\N	2015-03-11 05:07:54	VOTE
536	134	\N	2015-03-11 08:59:16	VOTE
537	79	\N	2015-03-11 08:59:39	VOTE
538	102	\N	2015-03-11 08:59:45	VOTE
539	185	\N	2015-03-11 10:26:35	VOTE
540	174	\N	2015-03-11 10:26:39	VOTE
541	183	\N	2015-03-11 10:49:16	VOTE
542	185	\N	2015-03-11 11:11:18	VOTE
543	174	\N	2015-03-11 11:11:23	VOTE
544	185	\N	2015-03-11 14:40:18	VOTE
545	174	\N	2015-03-11 14:40:21	VOTE
546	185	\N	2015-03-12 09:26:53	VOTE
547	174	\N	2015-03-12 09:26:58	VOTE
548	185	\N	2015-03-12 09:57:37	VOTE
549	174	\N	2015-03-12 09:57:40	VOTE
550	84	\N	2015-03-12 13:04:17	VOTE
551	174	\N	2015-03-12 13:26:25	VOTE
552	185	\N	2015-03-12 13:26:30	VOTE
553	185	\N	2015-03-12 15:51:46	VOTE
554	174	\N	2015-03-12 15:51:49	VOTE
555	134	\N	2015-03-13 12:10:32	VOTE
556	185	\N	2015-03-13 12:41:36	VOTE
557	174	\N	2015-03-13 12:41:39	VOTE
558	185	\N	2015-03-14 12:49:40	VOTE
559	185	\N	2015-03-14 15:21:47	VOTE
560	174	\N	2015-03-14 15:21:50	VOTE
561	185	\N	2015-03-14 16:21:03	VOTE
562	174	\N	2015-03-14 16:21:06	VOTE
563	185	\N	2015-03-15 09:16:47	VOTE
564	174	\N	2015-03-15 09:16:51	VOTE
565	185	\N	2015-03-15 11:15:19	VOTE
566	174	\N	2015-03-15 11:15:23	VOTE
567	185	\N	2015-03-15 15:43:17	VOTE
568	174	\N	2015-03-15 15:43:20	VOTE
569	185	\N	2015-03-15 17:46:27	VOTE
570	174	\N	2015-03-15 17:46:31	VOTE
571	174	\N	2015-03-16 06:36:47	VOTE
572	185	\N	2015-03-16 06:36:51	VOTE
573	25	\N	2015-03-16 11:46:47	VOTE
574	25	106	2015-03-16 12:05:43	VOTE
575	25	106	2015-03-16 12:05:43	VOTE
576	25	106	2015-03-16 12:05:43	VOTE
577	185	\N	2015-03-16 13:25:23	VOTE
578	174	\N	2015-03-16 13:25:29	VOTE
579	185	\N	2015-03-16 17:28:05	VOTE
580	174	\N	2015-03-16 17:28:10	VOTE
581	185	\N	2015-03-17 04:28:43	VOTE
582	174	\N	2015-03-17 04:28:46	VOTE
583	185	\N	2015-03-17 06:59:54	VOTE
584	174	\N	2015-03-17 06:59:57	VOTE
585	129	108	2015-03-17 08:40:47	VOTE
586	185	\N	2015-03-17 13:14:34	VOTE
587	174	\N	2015-03-17 13:14:38	VOTE
588	174	\N	2015-03-17 15:55:41	VOTE
589	185	\N	2015-03-17 15:55:46	VOTE
590	185	\N	2015-03-18 12:19:19	VOTE
591	174	\N	2015-03-18 12:19:23	VOTE
592	185	\N	2015-03-18 14:21:34	VOTE
593	185	\N	2015-03-18 15:40:44	VOTE
594	185	\N	2015-03-18 16:09:14	VOTE
595	174	\N	2015-03-18 16:09:17	VOTE
596	185	\N	2015-03-18 17:41:32	VOTE
597	174	\N	2015-03-18 17:41:37	VOTE
598	185	\N	2015-03-19 04:34:39	VOTE
599	174	\N	2015-03-19 04:34:43	VOTE
600	44	\N	2015-03-19 04:45:23	VOTE
601	185	\N	2015-03-19 13:13:07	VOTE
602	174	\N	2015-03-19 13:13:28	VOTE
603	185	\N	2015-03-19 14:42:59	VOTE
604	174	\N	2015-03-19 14:43:02	VOTE
605	185	\N	2015-03-20 05:12:17	VOTE
606	174	\N	2015-03-20 05:12:21	VOTE
607	185	\N	2015-03-20 07:23:21	VOTE
608	174	\N	2015-03-20 07:23:24	VOTE
609	185	\N	2015-03-20 13:59:39	VOTE
610	174	\N	2015-03-20 13:59:42	VOTE
611	185	\N	2015-03-21 11:37:28	VOTE
612	174	\N	2015-03-21 11:37:32	VOTE
613	185	\N	2015-03-21 15:35:54	VOTE
614	174	\N	2015-03-22 07:22:20	VOTE
615	185	\N	2015-03-22 07:22:26	VOTE
616	185	\N	2015-03-22 15:27:14	VOTE
617	174	\N	2015-03-22 15:27:17	VOTE
618	185	\N	2015-03-23 14:10:13	VOTE
619	174	\N	2015-03-23 14:10:16	VOTE
620	185	\N	2015-03-24 05:37:14	VOTE
621	174	\N	2015-03-24 05:37:24	VOTE
622	74	\N	2015-03-24 06:55:32	VOTE
623	105	\N	2015-03-24 08:19:00	VOTE
624	174	\N	2015-03-24 08:19:40	VOTE
625	185	\N	2015-03-24 08:20:42	VOTE
626	174	\N	2015-03-24 08:21:10	VOTE
627	174	\N	2015-03-24 14:19:46	VOTE
628	185	\N	2015-03-24 18:24:28	VOTE
629	174	\N	2015-03-24 18:24:36	VOTE
630	132	\N	2015-03-26 09:11:16	VOTE
631	185	\N	2015-03-26 11:05:08	VOTE
632	174	\N	2015-03-26 11:05:17	VOTE
633	152	\N	2015-03-26 20:42:43	VOTE
634	31	\N	2015-03-26 20:43:39	VOTE
635	185	\N	2015-03-27 04:01:08	VOTE
636	174	\N	2015-03-27 04:01:20	VOTE
637	94	\N	2015-03-27 06:43:01	VOTE
638	95	\N	2015-03-27 06:44:13	VOTE
639	130	\N	2015-03-27 06:45:30	VOTE
640	185	\N	2015-03-27 16:47:37	VOTE
641	174	\N	2015-03-27 16:47:46	VOTE
642	45	\N	2015-03-27 19:02:43	VOTE
643	61	\N	2015-03-28 07:19:38	VOTE
644	26	114	2015-03-28 08:38:25	VOTE
645	5	\N	2015-03-28 11:36:09	VOTE
646	186	\N	2015-03-28 13:29:03	VOTE
647	54	\N	2015-03-28 13:29:32	VOTE
648	156	\N	2015-03-28 14:07:13	VOTE
649	127	\N	2015-03-28 14:43:17	VOTE
650	26	\N	2015-03-28 14:43:30	VOTE
651	88	\N	2015-03-28 17:03:26	VOTE
652	185	\N	2015-03-29 07:23:23	VOTE
653	146	\N	2015-03-30 09:57:48	VOTE
654	185	\N	2015-03-30 12:09:31	VOTE
655	174	\N	2015-03-30 12:09:39	VOTE
656	185	\N	2015-03-31 04:52:23	VOTE
657	174	\N	2015-03-31 04:52:26	VOTE
658	185	\N	2015-04-01 13:43:06	VOTE
659	174	\N	2015-04-01 13:43:14	VOTE
660	56	\N	2015-04-01 16:30:16	VOTE
661	74	\N	2015-04-01 16:30:58	VOTE
662	13	\N	2015-04-01 16:58:22	VOTE
663	174	\N	2015-04-01 17:00:05	VOTE
664	185	\N	2015-04-01 17:00:12	VOTE
665	185	\N	2015-04-04 07:08:27	VOTE
666	174	\N	2015-04-04 07:08:31	VOTE
667	185	\N	2015-04-04 16:38:56	VOTE
668	185	\N	2015-04-08 14:06:07	VOTE
669	88	15	2015-04-10 07:52:04	VOTE
670	185	\N	2015-04-11 11:41:39	VOTE
671	174	\N	2015-04-11 11:41:43	VOTE
672	156	118	2015-04-17 07:46:03	VOTE
673	185	\N	2015-04-17 12:31:08	VOTE
674	195	\N	2015-04-17 19:36:43	VOTE
675	185	\N	2015-04-19 09:02:50	VOTE
676	174	\N	2015-04-19 09:03:00	VOTE
677	185	\N	2015-04-22 05:04:06	VOTE
678	174	\N	2015-04-22 05:04:11	VOTE
679	173	\N	2015-04-22 05:28:24	VOTE
680	164	\N	2015-04-28 05:59:00	VOTE
681	34	\N	2015-04-28 05:59:29	VOTE
682	93	\N	2015-04-28 06:07:46	VOTE
683	195	\N	2015-04-28 06:09:19	VOTE
684	34	\N	2015-04-28 12:57:19	VOTE
685	175	\N	2015-04-30 09:50:43	VOTE
686	18	\N	2015-04-30 09:52:35	VOTE
687	12	\N	2015-04-30 09:53:17	VOTE
688	185	\N	2015-05-01 14:11:29	VOTE
689	174	\N	2015-05-01 14:11:44	VOTE
690	185	103	2015-05-01 14:14:09	VOTE
691	185	103	2015-05-01 14:15:15	VOTE
692	185	103	2015-05-05 14:48:48	VOTE
693	184	\N	2015-05-08 08:57:56	VOTE
694	172	\N	2015-05-09 17:54:45	VOTE
695	171	\N	2015-05-09 17:55:25	VOTE
696	172	\N	2015-05-12 09:29:23	VOTE
697	185	\N	2015-05-13 16:44:16	VOTE
698	19	\N	2015-05-14 12:01:45	VOTE
699	173	\N	2015-05-14 12:03:06	VOTE
700	131	\N	2015-05-15 06:41:39	VOTE
701	185	\N	2015-05-16 17:07:13	VOTE
702	172	\N	2015-05-19 14:20:16	VOTE
703	146	\N	2015-05-20 04:13:27	VOTE
704	185	\N	2015-05-20 16:51:46	VOTE
705	174	\N	2015-05-20 16:52:22	VOTE
706	55	\N	2015-05-21 20:40:11	VOTE
707	116	\N	2015-05-21 20:41:08	VOTE
708	185	\N	2015-05-22 07:14:40	VOTE
709	174	\N	2015-05-22 07:14:47	VOTE
710	14	\N	2015-05-22 10:27:28	VOTE
711	131	\N	2015-05-22 12:44:29	VOTE
712	354	145	2015-05-22 12:48:29	ADDED
713	185	\N	2015-05-26 14:48:59	VOTE
714	174	\N	2015-05-26 14:49:04	VOTE
715	172	\N	2015-05-26 16:56:17	VOTE
716	164	\N	2015-05-31 14:17:16	VOTE
717	172	\N	2015-06-01 12:07:41	VOTE
718	34	\N	2015-06-07 18:55:31	VOTE
719	164	\N	2015-06-07 18:55:46	VOTE
720	93	\N	2015-06-07 19:08:45	VOTE
721	94	\N	2015-06-09 10:54:07	VOTE
722	130	\N	2015-06-09 10:54:14	VOTE
723	95	\N	2015-06-09 10:54:25	VOTE
724	179	160	2015-06-11 04:46:57	VOTE
725	172	\N	2015-06-13 05:46:32	VOTE
726	164	\N	2015-06-13 08:44:42	VOTE
727	134	\N	2015-06-13 08:49:27	VOTE
728	45	\N	2015-06-17 13:11:19	VOTE
729	56	\N	2015-06-20 20:13:31	VOTE
730	164	\N	2015-06-22 17:38:00	VOTE
731	34	\N	2015-06-22 17:38:17	VOTE
732	59	\N	2015-06-22 17:40:46	VOTE
733	42	\N	2015-06-22 17:41:12	VOTE
734	34	\N	2015-06-22 17:45:21	VOTE
735	34	\N	2015-06-23 04:01:22	VOTE
736	176	165	2015-06-23 06:25:32	VOTE
737	4	\N	2015-06-25 10:02:41	VOTE
738	145	15	2015-06-25 12:12:23	VOTE
739	172	\N	2015-06-25 18:11:52	VOTE
740	31	\N	2015-06-25 18:38:41	VOTE
741	127	\N	2015-06-28 07:43:39	VOTE
742	26	\N	2015-06-28 07:43:52	VOTE
743	185	\N	2015-07-02 07:33:24	VOTE
744	31	\N	2015-07-02 19:57:48	VOTE
745	34	\N	2015-07-04 19:20:48	VOTE
746	164	\N	2015-07-04 19:24:52	VOTE
747	42	\N	2015-07-04 19:25:44	VOTE
748	39	\N	2015-07-04 19:26:14	VOTE
749	118	\N	2015-07-04 19:26:21	VOTE
750	102	\N	2015-07-04 19:27:13	VOTE
751	34	\N	2015-07-05 09:02:33	VOTE
752	34	\N	2015-07-05 10:15:00	VOTE
753	34	\N	2015-07-05 10:15:00	VOTE
754	34	\N	2015-07-05 14:27:43	VOTE
755	56	81	2015-07-09 07:37:33	VOTE
756	34	\N	2015-07-12 11:01:21	VOTE
757	71	\N	2015-07-15 12:02:38	VOTE
\.


--
-- Name: problems_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('problems_activities_id_seq', 758, false);


--
-- Name: problems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('problems_id_seq', 355, false);


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY regions (id, name, location) FROM stdin;
1	Ukraine	0103000000010000006200000008F6F22C37C93F4014F496C8030D4A40441C4D9D671440400291CD98D7074A4020383552BE3440404487F6F4F3244A405024870A9E5B404070687109861E4A406C2DC17758E04040A1CB3AB9E32A4A40FC8A503A2432414048E285B76AE249405CDC08592C124140289AA43C80C849402813D9C2C61C4140D38B3062C4A049400C37FBE4D682414042B1EFBA919A4940548616CD5FB04140255460F810634940E4BCE63695AD4140DB75829AE14949408C008E4426504240089EDE29E01C49400C6C91E15CB24240E88930622531494014B5725C5C01434016599A6534F54840C8B90F93284C43409EA7B54D96F648405C1265E8D60844402E883062EFCC484090A8614B570A444038CF11DD59A748402C5946635BD64340DE9ADE2954644840C0A4C414A4F243403C964173BF1D4840347191E17FDE43403BB4C65E10F3474050796885A2624340A076BC87ADE947402C786885A7204340BA944173F0C54740143EFBE49C1C43407715908E148D4740543CFBE46AB642405A26A11FD882474048DBCEEB42614240D4BB9D026F59474068D2947E6EE94140F662ABF6AE524740D488B3032E7B4140626C821AF8224740844BA92CA9824140A8DBBF245BD3464030490CF647C141407293DEA97AB44640A41B76F9D6434240F022A19F28BC4640809927DED72A4240C8F5A7D97D8E4640EC9D614BB89E41408CB400CC517846402808021FF6F0404067D522EE442E464094773F29C8A940403665E5E34D484640501F4D9D01C64040ECADC65E7384464048494663223A4040371F0469EAA94640B0E67C33BE504040E56348AD74C24640E433FBE448CB4040F21C673200ED4640345C577437A640401D2BDB0C510A4740A8C2BFF97FBE3F4028DDBF24AB2A4740B85182EFE0AC3F40788FA43C665A4740B15E9300AEBF3E40C88B0706A34A474070EC55F6AA603E4079A2520426044740004C1F26719A3D406F3AEC1D8BA546409F1D266054263D40C86348AD82BB464009F6660706AE3C405518CA7BEAA6464031168929CA3B3C4004FA441080BE464090BE969D3A7C3C407290417367CC4640704482EFF4A83C40D6017F7D51F8464068D8E11B08EF3C4067E05C5B2121474090B222C3EBDC3C403147C3C10C384740F1F02C9A75123D407B2F78434342474057B7BFF9AF2B3D40AD7D93AB8B304740A912B2858DC23D403E519A65CC2C4740F0FB660750063E40F813908E43364740A04982EF94D63D404F997BE03D43474020434882AAE83D40D092417351564740482660CD468F3D4006A1B5CDDB764740883DAB4B466A3D4002B3C6DE5EAC474020D2A7AE050D3D40503FEC1D4FC14740E8491F26691F3D4098C87426AFEC4740E00DB285BFAB3C40A0067F7D1F0F4840302ED4A771423C404866AB76E9134840B820FD03C5853B40ABE8F991CA3B4840B8D27E529ADB3A40D377BC87212F4840305A07DB8C9E3A401E4BC3C1401C484060CCE11B8C323A40662C3ED6451C4840C87CC63329F23940BE6CE5E35AFE474000F13DAB2E3539407AF80A230EF2474030D455F6C6DD3840D879593E67DE474020351F26ED6638403481932BAEFD474088028929CEC23740F09F181728FE4740D8D62C9A69243740333D4FE7540C484088D18F63E5B53640F2A9EFBAEBF0474068678CC60CA43640A82FDB0C3B134840683FCD6DEA153640914BC3C10C36484080AD6D41E547364089974173A669484060BCE11BE28E36405468AB76F98A4840D0D18F63C3C63640D43BB2B081834840D92C1F26B98436407010B9EA06BD4840F018D4A72F6D37407945EC1D7D274940B1DDC9D039EC3740EADBE8806236494080331F26AD073840B03878C34A5A4940A1C0E11BEE863740EEF296C80ACA4940686D8CC64C013840F0444F6708CF494068092660988D384084A81817B9F1494027C544E5E953394028A57B6090F4494090F2A07484563A40F2CDD76F88EA494018CBA7AE3D743B40FA8FCD98D0CB4940589B747BDA3D3C402B9AA4BC3EC94940313371DE1B9E3C40584B8954BFB6494038FEA0742AFE3C4016DB4BCA0FCD4940289200A143413D40C9AAB54D22AF4940DF8B29FD48283E406A96070644B54940682089291C8E3E40AA0D7F7DE5A849401887EF8F949E3E404DFAD0B551E94940583D71DE73ED3E40CE343ED66B054A4008F6F22C37C93F4014F496C8030D4A40
\.


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('regions_id_seq', 2, false);


--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY resources (name) FROM stdin;
UsersHandler
UserHandler
ProblemsHandler
ProblemHandler
VoteHandler
ProblemPhotosHandler
ProblemCommentsHandler
PagesHandler
PageHandler
CommentHandler
PhotoHandler
PermissionHandler
RoleHandler
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY role_permissions (role_name, perm_id) FROM stdin;
admin	1
user	2
user	3
user	4
admin	5
admin	6
admin	7
user	8
user	9
user	10
admin	11
admin	12
user	13
user	14
admin	15
user	16
admin	17
admin	18
admin	19
admin	20
user	21
user	22
admin	23
admin	24
user	25
user	26
admin	27
admin	28
user	29
user	30
admin	31
admin	32
user	33
user	34
admin	35
admin	36
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY roles (id, name) FROM stdin;
1	admin
2	user
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('roles_id_seq', 3, false);


--
-- Data for Name: solutions; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY solutions (id, problem_id, administrator_id, responsible_id) FROM stdin;
\.


--
-- Name: solutions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('solutions_id_seq', 1, false);


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY user_roles (user_id, role_name) FROM stdin;
1	admin
2	user
3	user
4	user
5	user
6	user
7	user
8	user
9	user
10	user
11	user
12	user
13	user
14	user
15	user
16	user
17	user
18	user
19	user
20	user
21	user
22	user
23	user
24	user
25	user
26	user
27	user
28	user
29	user
30	user
31	user
32	user
33	user
34	user
35	user
36	user
37	user
38	user
39	user
40	user
41	user
42	user
43	user
44	user
45	user
46	user
47	user
48	user
49	user
50	user
51	user
52	user
53	user
54	user
55	user
56	user
57	user
58	user
59	user
60	user
61	user
62	user
63	user
64	user
65	user
66	user
67	user
68	user
69	user
70	user
71	user
72	user
73	user
74	user
75	user
76	user
77	user
78	user
79	user
80	user
81	user
82	user
83	user
84	user
85	user
86	user
87	user
88	user
89	user
90	user
91	user
92	user
93	user
94	user
95	user
96	user
97	user
99	user
100	user
101	user
102	user
103	user
104	user
105	user
106	user
107	user
108	user
109	user
110	user
111	user
112	user
113	user
114	user
115	user
116	user
117	user
118	user
119	user
120	user
121	user
122	user
123	user
124	user
125	user
126	user
127	user
128	user
129	user
130	user
131	user
132	user
133	user
134	user
135	user
136	user
137	user
138	user
139	user
140	user
141	user
142	user
143	user
144	user
145	user
146	user
147	user
148	user
149	user
150	user
151	user
152	user
153	user
154	user
155	user
156	user
157	user
158	user
159	user
160	user
161	user
162	user
163	user
164	user
165	user
166	user
167	user
168	user
169	user
170	user
171	user
172	user
173	user
174	user
175	user
176	user
177	user
178	user
179	user
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY users (id, first_name, last_name, email, password, region_id, google_id, facebook_id) FROM stdin;
1	admin	admin_lastname	admin@example.com	4f99d5d7bc1fca18ffd0fabc2b0cce86c15dc779	1	\N	\N
2	name1	\N	name1@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
3	name2	\N	name2@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
4	name3	\N	name3@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
5	name4	\N	name4@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
6	name5	\N	name5@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
7	name6	\N	name6@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
8	name7	\N	name7@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
9	name8	\N	name8@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
10	name9	\N	name9@.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
11	Тарас	Іванов	ldgoust@gmail.com	c2e1f80f2be011f2e36da4a930d9fc3aa8384096	1	\N	\N
12	Andrey	Abramov	abramow.andrey@yahoo.com	4a6813fa4b74c2e87aee291ff380990aa84c7f26	1	\N	\N
13	Andrew	Palatnyy	apalatnui@gmail.com	49615de64c6b8b27c145b1d29b082f235957b39a	1	\N	\N
14	Tony	Gopster	lowriderman@bigmir.net	9af665a6aeb2422e4005c29b1a5fbd1aa8162b94	1	\N	\N
15	Igor	Tsvetkoff	tsvetkoff@i.ua	43f43cb22da23c3fafc17272ba124621d90d9da2	1	\N	\N
16	Василь	Байцим	v.baitsym@gmail.com	3ea12c8ba688ec956fa378529abf4c08ce462f57	1	\N	\N
17	Greens	Volyn	greenskiev@ukr.net	a57323816711c9fbf988fa4bf9f84758184cf296	1	\N	\N
18	Роман	Зарічний	roman.zarichnyi@gmail.com	57a38c4c5e082783814b2a0a9dbfcb8c52d8a7cd	1	\N	\N
19	Юрій	Пивоваренко	yurij.pyvovarenko@gmail.com	da6aa4829fdc29b7c35f3aaa6f3e5e33ef4346f8	1	\N	\N
20	Артем	Круть	artemkrut252@gmail.com	a8f18c09f3ee23f72462034ed8a0ec6ff14c5453	1	\N	\N
21	Геннадій	Бондаренко	gena.bondarenko@rambler.ru	fcc24a868832ba95e0d68165b65f6b0050f8159a	1	\N	\N
22	Gozak	Natalia	tah@ukr.net	2bed0b39361a3a5f672bdb758469fc88c78de928	1	\N	\N
23	ecology	dnepropetrovsk	ecology.dnepropetrovsk@gmail.com	093bf573603a426476a36120308727881be74b40	1	\N	\N
24	Oleh	Holodnyak	oleg.gld@gmail.com	23a9659ffb493f3a01a080153e014c99ec835ac2	1	\N	\N
25	Oleksandra	Kovbasko	artimia@gmail.com	2d702ddd563ba914b5d04c852744bb1c14804cd4	1	\N	\N
26	Олександр	Малиш	a.malysh@ua.fm	e5df2af498f0fbf43a4c322bf4a9d847392d8280	1	\N	\N
27	Богдан	Горін	bodja789kg@gmail.com	1ad1481d72a10f40009e5cd8a6337aad49c7ca32	1	\N	\N
28	Valentyn	L..	tran4rm@gmail.com	12d7b167afa698da029050f4cff9716d5ad14019	1	\N	\N
29	Svyatoslav	Panyonko	panyonko@yahoo.com	249ec8d56204f971fb5aa16a13bc37f96dde6a5c	1	\N	\N
30	Ivanna	Tabachuk	pourqoi_pas@ukr.net	74009f4ac4e290074c39ece7477a1da7253f6e1d	1	\N	\N
31	Олександр	Руденко	rudik.ru@bigmir.net	9754b06a06799f0580105c1f34484b68a3a88207	1	\N	\N
32	Алексей	Бондаренко	bondarenko_aleks@bigmir.net	0c871d982ae8f4d9d6ad1a67a3583fe54da01ba9	1	\N	\N
33	 Оксана 	Григорьева	maxim.grigoriev1@gmail.com	620076406c77e91703f30f63d5987d476c120033	1	\N	\N
34	АЛЕКСАНДР	Александров	aklar@ukr.net	3ade0e142eba3df1f9eaed154bbb4bc45cd4def3	1	\N	\N
35	Вікторія	Сергіївна	demjanenko_vika@ukr.net	ec2d619935ce36caed438b12dffed6bfbc3d0bff	1	\N	\N
36	Олександр	Шкурко	shkurko13@bigmir.net	62c1f330c2475b9633e4ebd13414eb353851824c	1	\N	\N
37	Олександр	Князький	knyazkiyov@gmail.com	db9c2302368119132452c7f2a26b554652eed533	1	\N	\N
38	Владимир	Белей	vokin8@gmail.com	f05e4c43b53f86005297508922f80e1bff35e18f	1	\N	\N
39	Andrey	Palatnyi	andrey.palatnyi@gmail.com	49615de64c6b8b27c145b1d29b082f235957b39a	1	\N	\N
40	Андрей	Веретин	hold1966@mail.ru	8bd6d88729860aa249b8b489079ba97e90c03658	1	\N	\N
41	Alex	Vospet	vospet@ukr.net	d2714e803d7de3e5009b19ac2600a6a51848bb43	1	\N	\N
42	Максим	Линник	linnikmaksim@gmail.com	7dbd7588b0e0e05cf9e9706143b733cd9a12244c	1	\N	\N
43	Олександр	Сікора	vipsikora@gmail.com	e2dbd5324c6dbce885abb06c3a8ab453eebcf87e	1	\N	\N
44	Sergey	Ivanov	mirror-worlds@yandex.ru	d4443c91a837192280910367c273d02a8095365e	1	\N	\N
45	марта 	пінчак	martusjaforever@mail.ru	fdfe043c3cfb41c9417284a0b7141b09015b6c56	1	\N	\N
46	Анастасія	Чала	asya_chala@i.ua	7d64bfa2a1a31af83bedd2d5d067867279d550ad	1	\N	\N
47	Сергій	Карпенко 	karpenko_serg@ukr.net	0dc70b1c3619ba58030a8e5d33dbb4b7301e8805	1	\N	\N
48	Анна	Гапонюк	anya.levenyatko1990@mail.ru	5210e6608b4e6f19bdb318e4fb0c8da140b52fe4	1	\N	\N
49	Віталій	Мокін	vbmokin@gmail.com	af256c1861f2f99ab93c02a0117428e36c090077	1	\N	\N
50	Тетяна	Лісова	tanja_kr@list.ru	5b3fe5c3344afa314f981f6cd0cf49b0a06e97eb	1	\N	\N
51	Dmytro	Kostylov	dmytro.kostylov@gmail.com	d6b884406fa780849ad991093a7d1b277fc40453	1	\N	\N
52	Тетяна	Рішко	trishko@mail.ru	688fd8160544954721e74960f4bf15efc1283c1e	1	\N	\N
53	Анета	Тягнибок	aneta1512@mail.ru	c6c237968dd3f1cc87e73d97333b7ce1f69c1f74	1	\N	\N
54	Алексей	Мятельский	a.myatelsky@outlook.com	49d9a50434bf028da94d6428eb118fa40ae1226c	1	\N	\N
55	Василь	Юращук	dobosh82@mail.ru	465d20ba900881924d2fd68605341b498e792d9b	1	\N	\N
56	Леся 	Мінько	minko94@mail.ua	1bd1dfaabf53bf24b8b48645ae7ba8ba2ae7f9e8	1	\N	\N
57	Соломія	Парасюк	solomiakoval@gmail.com	0947710023f2e764f5162ea145a4fd607d64a9bd	1	\N	\N
58	Руслан	Пиж	ruslanpyzh@gmail.com	f3c8b8e14877341c3ce527a321a0b39b4b31a39d	1	\N	\N
59	Наталія	Степована	stepovana@list.ru	d41cfd9ebb547fdc7d4d4de7fd6c3af401f46a92	1	\N	\N
60	Вікторія	Кобель	kobel_94@mail.ru	0a90f1d862b279ed94b6e87d76fa559f086d8d4c	1	\N	\N
61	Анна 	Мельник	aniameknyk95@gmail.com	528a638e6800fc210c170c4e39a2dde9f8108655	1	\N	\N
62	Вікторія	Кобель	kobel_95@mail.ru	b7c4b2eaa4334e7423bffc25c73914e417a0ed5f	1	\N	\N
63	Роман	Яворський	xxxromanokxxx@gmail.com	0cf9076adc78a171fe36b8c68f79308c37f04612	1	\N	\N
64	Аліна	Максимчук	alino4kazaja@gmail.com	2f16f7134e60f9acae590be7ba6a2f98478fcc4b	1	\N	\N
65	Андрій	Шевчун	tar.boiko@yandex.ua	249ec8d56204f971fb5aa16a13bc37f96dde6a5c	1	\N	\N
66	Андрій 	Шевчун	ashevchun@mail.ua	d85845038669a68485972502ca80d284e810e161	1	\N	\N
67	Михайло	Карпа	mukhailo94@gmail.com	4363049a087f032e564623847b961ffa391105c8	1	\N	\N
68	Ірина	Маюк	irynamayuk@gmail.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
69	Олег	Барна	abrams__m1a2@mail.ru	d85845038669a68485972502ca80d284e810e161	1	\N	\N
70	Олег	Романовський	oleh_94@mail.ru	080d265f418db4722e9f99d4da10eebce841d8bd	1	\N	\N
71	Марія	Тиха	marynam@gmail.com	850f78d8dace5a42e0d47bd0d73a1bb03173f241	1	\N	\N
72	Антон	Воробйов	antoonmm@gmail.com	cd0aef7ab0eaf402dcdfd703e54a006315218f9c	1	\N	\N
73	Вікторія	Якушин	vikavila@gmail.com	d85845038669a68485972502ca80d284e810e161	1	\N	\N
74	Тетяна 	Мисак	tanya122@gmail.com	b215f5a57a60dee6220ac64a99a8d8fbcf2567d7	1	\N	\N
75	Олександр	Кирей	a.kirey@i.ua	d5c7ae3b5fd9bb2513f74dad7b5661f7cdfb3e76	1	\N	\N
76	Олександр	Гордеєв	shtukaturki@gmail.com	0c65c3e560f770f991a0ec348df259e50d7d5d3c	1	\N	\N
77	марта	*******	martta@mail.ru	fdfe043c3cfb41c9417284a0b7141b09015b6c56	1	\N	\N
78	Сергей	Безбородько	ecochernigov@gmail.com	f10c0554d1acb07da663f36076b816d697bdc4bb	1	\N	\N
79	Andrii	Bts	andrii.testmail@gmail.com	58f520e66d66fe8a7326b5e6bbb0b377988257d4	1	\N	\N
80	Александр Степанович	Фамилия	ak50@mail.ru	3a3eb4883bc5f4ebc943d584eda09e2cdc5d0038	1	\N	\N
81	Vasyl	Kotsiuba	clic@ukr.net	fa15062d2b502e4be1a493370e82b8b20b60fc96	1	\N	\N
82	2	2	test@2222	249ec8d56204f971fb5aa16a13bc37f96dde6a5c	1	\N	\N
83	Юлія	Спінова	juliaeco87@rambler.ru	bac4aa70345a007ad21125fc33fbd84f8488dbb6	1	\N	\N
84	Марина	Дронговська	marydrongovska@gmail.com	580e8788168d1153ce8ea16807ad52ccf6496a9b	1	\N	\N
85	Володимир	Ночвай	nochvai@gmail.com	d1d20ad87d436890856b2905dce18671da1ddff7	1	\N	\N
86	111	111	mail@mail.ru	111963a2f6a587d8643c0333b241ea756018e798	1	\N	\N
87	111	111	m1ail@mail.ru	111963a2f6a587d8643c0333b241ea756018e798	1	\N	\N
88	1111111	1111111	adasd@mail.ru	f20a04a7534648aaae7494b836373d4e19b54b9b	1	\N	\N
89	34r34r43r@34r.34r	34r	erferffrf@refre.ert	2cbafef28b8f105c298a64a6ea432107ee719b1a	1	\N	\N
90	Мар'яна	Андрусишин	m_andru@ukr.net	63e5403c50dd231539fd0df451d78b4b56de9367	1	\N	\N
91	Mikhail	Prs	qwee1@mail.ru	914136b22ffd84d700e1827579cacd20b17e753f	1	\N	\N
92	Микола	Кожухаренко	nikolaykozhuharenko@gmail.com	5eccf49aee6f4a1ef3b85de53e984ecb2bb1fbe9	1	\N	\N
93	ttt	ttt	ttt@ttt.ttt	7a3ce25e42d7365fb8f6aa9520412bbafc87a855	1	\N	\N
94	Олександр	Єфремов	frya@ukr.net	f9901bf620bc016b9203ac53baab7a0646946513	1	\N	\N
95	Партія	Зелених	zeleni@mail.ru	16f2b64f1b2f133acefb9b53a1a2c7c007424c27	1	\N	\N
96	Оленка	Оленка	vkak2013@mail.ru	ffc2b89269a7dd77961cf2c9553c0ac8c253851c	1	\N	\N
97	Ruth	Huistein	gsolber_huistein_1425169767@tfbnw.net	47e4f27c494f3f2ab7fecf1da23d731905ece7ba	1	\N	\N
99	Олексій	Гуральник	alexey.huralnyk@gmail.com	c966245ac85f09e8a97210092a7546bf4683d601	1	\N	\N
100	Mikhail	Prsj	ecomap@mail.ru	6e7664975424c861bbce83fd7f242bf64e3ff8e1	1	\N	\N
101	Даниїл	Майоров	danmaiorov@gmail.com	c6192335b2370cb195f1b5b2224fc685641ada97	1	\N	\N
102	Галіна	Ширінська	connja7@gmail.com	5c5ecf17655cbbe34f2e0974dcfa0938601476ed	1	\N	\N
103	Лілія 	Квак	janslavn@i.ua	b6b9a90c4cb603751d9396b57c816cc3922b9153	1	\N	\N
104	Marianna	Lobay	lobaymarianna@gmail.com	a18292bf5b6a6d5fdc37688a94cbb8b08ca52475	1	\N	\N
105	Djkjlbvbh	<fnjxtyrj	vydra07@bigmir.net	08d71a8a3995ba0e0011ef063347c6c47bb6417e	1	\N	\N
106	Ініціативна Група	МІСТО МРІЇ	udnk_people@meta.ua	a1fe249997d004bf386ee7af41856cfa7d722f1a	1	\N	\N
107	Ваня	Зубкович	zubkowuch11@rambler.ru	c59191f3612bf3a285f48a8a165588216ea2af78	1	\N	\N
108	Олександр	Ткаченко	sanches999@ukr.net	1cdc2b522c6d77a0a7b0f58fdf18b1457bf40dc3	1	\N	\N
109	Victoria	Shevchenko	victoriashevchenko33@gmail.com	1593bc2110b5c17cd0a50986b52f1a7044c92cf5	1	\N	\N
110	Сергей	нест	ssnest@list.ru	06d50392d0059108a2ae1a57bbaa23d7b7f78629	1	\N	\N
111	Наталія 	Юхименко	shyjan@i.ua	ed20795bac11c110d5ba753860d44d2ca365f5ef	1	\N	\N
112	Христина	Косач	hrustya_hlyan@i.ua	1fc48f81a5d3447478adaff9ea4888de5313bd05	1	\N	\N
113	Антон	Коверник	propet90@gmail.com	30eaf48569f9a407329d4be1e31a320a3001031e	1	\N	\N
114	Володимир	Янович	yanovich.volodya@yandex.ru	d4b56a27402c2abe96cfe3c7f9ae6f6060ac7e84	1	\N	\N
115	Богдан	Левко	bohdan70707@mail.ru	586100547e67a4643b51ef7f0da169f463e34591	1	\N	\N
116	Yuriy	Kurilenko	yuriy.kurilenko7@gmail.com	2640fc953df91f7a3bc875573101060892a84901	1	\N	\N
117	Володимир	Крижанівський	krizvol@gmail.com	2975844ff702fd254b7ef3c5216472a5c0b585b0	1	\N	\N
118	Bogdan	Kurinniy	assassid@ukr.net	6619729b7f7cb626fca4a64ddcf1a53232645c69	1	\N	\N
119	Мальвіна	Шинкарчук	malvina.schinkar4uk@yandex.ua	d3df68c3042553f03415e269e278054d7232c62d	1	\N	\N
120	Іванна	Бесараб	yesivanna@mail.ru	ad72853e59aca0f0f55d6d40a9a911c1508e3152	1	\N	\N
121	mykola	kharechko	crchemist@gmail.com	78420443e3b828efc1814a56a9fd73d73c43e8e7	1	\N	\N
122	Ганна	Карпенко	karpenkoganna@gmail.com	4136bb6e3c91022df541b4f3d56762628dd14b0f	1	\N	\N
123	Zoryana	Borysova	zoryanaluskavets@gmail.com	a6e0cd05927ef91d3f9d211a09bf21efba8eb9c9	1	\N	\N
124	Віка	Шутяк	a380632814325@gmail.com	b9de729a044be12f0df1ca6a85003e52795a8c59	1	\N	\N
125	Вікторія	Хлян	igor.budzin@yandex.ua	058746909f22bfcc0ea0ad564b3b3a57ba6e5a98	1	\N	\N
126	Ірина	Мельничук	melnychukiryna@i.ua	c5d3885a0de7b2de74f5faea212734945ab8c70e	1	\N	\N
127	Вікторія 	Баран	vikabaran@i.ua	f0d118e3246dc806861958092f4e51e6f444359a	1	\N	\N
128	Вероніка 	Вайда	veronikavayda@i.ua	9b2a76c3c505c545f9044c2393c9e33c85e4c909	1	\N	\N
129	Ірина 	Мельничук	melnychukiryna@mail.ua	f84ad05e900d5faf1e7162a73b8dbd28155eea43	1	\N	\N
130	Ірина	Антонюк	melnychukiryna@gmai.ru	998205dbe91cef5cad6a3940075f16cc0504ba3c	1	\N	\N
131	Ірина 	Мельничук 	melnychukiryna@bigmir.ua	cea223e352eafa811622e54bbea1776e042cf60c	1	\N	\N
132	Yulia	Mytsyk	yulia.kosinska@ukr.net	841f08706b7e7fdd05c9ee8dc22c422fd71152e3	1	\N	\N
133	Павло	Костюк	thepublicenemy1994@gmail.com	d1c10d7743a0272759b18054312eb3023ae62033	1	\N	\N
134	Марія 	Лопачак	lopachakm@mail.ru	91e30a3c498abe0076ac90ee36c51bd68059d8f1	1	\N	\N
135	Лілія	Вовчко	vovchkoliliya@ukr.net	076787708af1a9419499af32ca3a48bc683f423a	1	\N	\N
136	Мирослава	Велика	ostapuk_galia@mail.ru	80780dd9eb836fa65707b2740dc10cf9b22ac74e	1	\N	\N
137	Дмитро	Андрушкевич	adm071194@gmail.com	c5cb8f111870ee9d5b2db8dba81de94cc5c86d82	1	\N	\N
138	леся	фірич	adm071195@gmail.com	dbbff291d050438170cddbedb7ad1881976f6d09	1	\N	\N
139	Лілія	Зубак	l.komarnitska@mail.ru	9069bedf1b1f7346002c750799c45956a9de6066	1	\N	\N
140	Галина	Андрухів	andruhivhalya@ukr.net	4216840565c06f21cde5bfbc410359fb68681938	1	\N	\N
141	христина 	садовець	sadovets.christina@mail.ru	2123f5f611a6bb7d321f82527ea8dcf6881dce2c	1	\N	\N
142	Ольга 	Кунець	olya.kunets.93@mail.ru	60d8da6e682589b94cbb1357c092d19af7e8c97c	1	\N	\N
143	лілія	Зубак	l.zubak@mail.ru	63f10a4aa231f79c51cefb70203be20445a8e02b	1	\N	\N
144	Zhanna	Kuzmytska	kuzmytskazhanna@gmail.com	a0f8dee7c389a00cb369816bab4f08613807764c	1	\N	\N
145	Євген	Довбуш	edovbush@ukr.net	41fafc895b65e2fd1aaaa53842490cc4103c27e1	1	\N	\N
146	Марина	Дроздовська	mariamatviychuk230894@gmail.com	5e78bae53b12c4ef9249a61a3fc6dfdc005bf07f	1	\N	\N
147	ірина	подольччак	iralito@i.ua	849b4103259611b02654b187b3159bca165dfe0c	1	\N	\N
148	anja	okeanja	martakauffman@gmail.com	4cdaf67b68ed21d0ba1f33de1e25ed9c1e222336	1	\N	\N
149	Андрій	Подібка	andriy.podibka@mail.ru	c08489216d663ef7e115ddbd1c16c45dad962204	1	\N	\N
150	Юрий	Семенцов	vainemeinen@rambler.ru	2203a395083445640550e080ebb361ab6be2396e	1	\N	\N
151	Юрий	Грабилин	krabmail777@gmail.com	0de6bae28bd9019fed7a120101f294a90340d9b4	1	\N	\N
152	Микита	Жук	antidote.mail@gmail.com	d131db086c55ce0bee109b4ab699d7f4640b321c	1	\N	\N
153	Лесь	Баськов	oleksandrbaskov@gmail.com	cadf7eb682ee81c1d7624e03b3004df728e5a559	1	\N	\N
154	Олег	Пугаєв	oleh4pk@gmail.com	6836447a781460f3c982e4afbf6a7d99fa4ec5df	1	\N	\N
155	Леся	Войтенко	secretpartner888@gmail.com	e5172facc874047f26bea38f42faf2b8c1576f65	1	\N	\N
156	Іван	Жалдак	zhaldak.ivan@gmail.com	904bf248b2c105640a7b2b426083a4f523f5dc05	1	\N	\N
157	Andriy	Martyshko	a.martyshko@gmail.com	0c66f7cce1cc51bfddc0e26b059a6ff5bdc6b6bb	1	\N	\N
158	Ivan	Hadji	inhadj11@gmail.com	6946403374c8d9fbc7fc6ef90418afb1436aadf3	1	\N	\N
159	Anna	Vilde	anneco@yandex.ru	6e996ae7e89d429b43de545c76d690545b0208c8	1	\N	\N
160	Konstantin	Yarmolenko	yarmolenko@gmx.de	594d5eebb2f4fc91c24a49a98b69d0b8bc2d8054	1	\N	\N
161	Саша	Чёрный	duta.sana@mail.ru	3604632b70e67cb29dd036f7f7f837313c20fdda	1	\N	\N
162	Павло	Вікторович	pavelpivdenne@inbox.ru	011f44cab93ce723f6bac35305da68ef223d2100	1	\N	\N
163	Yuriy	Vladimirovich	y.ridkous@gmail.com	e0da783aa1b6a4b3891fdf873275b22ff09087b4	1	\N	\N
164	Микола	Скиданюк	manyava@i.ua	2491e24079e9b21fe593325c5c983ef899f12c4b	1	\N	\N
165	test	test	test@gmail.com	cfca756297eb6a8b327bc292380093204f404479	1	\N	\N
166	аол	аол	v@b.co	9606b4697e1c27bafc976e9a6b4a69046a71e803	1	\N	\N
167	yurkiss	yurkiss	yurkiss@yandex.ru	940ff6c2f260e5bc0f529001a19d8cf29876a0ba	1	\N	\N
168	Николай	Мамула	radakvitka@gmail.com	3dda9d9117f1f9b0ce7c11f1143581a81e2aeee4	1	\N	\N
169	Yevhen	Malov	y.malov@outlook.com	34cf58e423f2862df8120191e15cdeeabb74da70	1	\N	\N
170	мит	мол	ffh@gmail.com	acb2e9bcd41e62b2eeb974c2eda7ddb030c29c6f	1	\N	\N
171	Мила	Курпатова	stsyganova@yandex.ru	bc59daaf76524ee56c6b7845f10b45270ef937cb	1	\N	\N
172	Даніїл	Тищенко	daniil.tischenko@gmail.com	560f8f32b135f718ced4a9490dfced54b58d39ce	1	\N	\N
173	Катерина	Жовта	katuxaz@ukr.net	76eb52cffefe764f38fd48bae171fb983afb438f	1	\N	\N
174	Олександр	Кириченко	kyrychenko9622@gmail.com	4fd59a26769ae07e2da9e77cb710fcb9456c835f	1	\N	\N
175	Andrey	Lavdanskiy	andrey_lavdanskiy@mail.ru	bfab3b1fab7c70a0d1c7942d8aa4b1542972f746	1	\N	\N
176	мит	мро	ter@gmail.com	9606b4697e1c27bafc976e9a6b4a69046a71e803	1	\N	\N
177	Labunska	Inna	innalabynskaya@gmail.com	1e497f6794294587748f11eb5d8c14c585518b2e	1	\N	\N
178	Olena	Piddubska	poddubskaya@gmail.com	8f248e6dd1ca39cfc334d00ca38941630a20acbf	1	\N	\N
179	Bogdan	Kurinnyi	dev1dor@ukr.net	cfca756297eb6a8b327bc292380093204f404479	1	\N	\N
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('users_id_seq', 180, false);


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
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: pages_alias_key; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_alias_key UNIQUE (alias);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: problem_types_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY problem_types
    ADD CONSTRAINT problem_types_pkey PRIMARY KEY (id);


--
-- Name: problems_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY problems_activities
    ADD CONSTRAINT problems_activities_pkey PRIMARY KEY (id);


--
-- Name: problems_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_pkey PRIMARY KEY (id);


--
-- Name: regions_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: resources_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (name);


--
-- Name: role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_name, perm_id);


--
-- Name: roles_name_key; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_name);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_problems_location; Type: INDEX; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE INDEX idx_problems_location ON problems USING gist (location);


--
-- Name: idx_regions_location; Type: INDEX; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE INDEX idx_regions_location ON regions USING gist (location);


--
-- Name: _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE "_RETURN" AS
    ON SELECT TO detailed_problem DO INSTEAD  SELECT problems.id,
    problems.title,
    problems.content,
    problems.proposal,
    problems.severity,
    problems.status,
    problems.location,
    problems.problem_type_id,
    problems.region_id,
    a.number_of_votes,
    b.datetime,
    c.first_name,
    c.last_name,
    count(comments.id) AS number_of_comments
   FROM ((((problems
     LEFT JOIN ( SELECT problems_activities.problem_id AS id,
            count(*) AS number_of_votes
           FROM problems_activities
          WHERE (problems_activities.activity_type = 'VOTE'::activitytype)
          GROUP BY problems_activities.problem_id) a ON ((problems.id = a.id)))
     LEFT JOIN ( SELECT problems_activities.problem_id AS id,
            problems_activities.datetime
           FROM problems_activities
          WHERE (problems_activities.activity_type = 'ADDED'::activitytype)) b ON ((problems.id = b.id)))
     LEFT JOIN ( SELECT problems_activities.problem_id,
            users.first_name,
            users.last_name
           FROM (problems_activities
             LEFT JOIN users ON ((users.id = problems_activities.user_id)))
          WHERE (problems_activities.activity_type = 'ADDED'::activitytype)
          GROUP BY problems_activities.problem_id, users.first_name, users.last_name) c ON ((c.problem_id = problems.id)))
     LEFT JOIN comments ON ((problems.id = comments.problem_id)))
  WHERE (NOT (problems.id IN ( SELECT problems_activities.problem_id
           FROM problems_activities
          WHERE (problems_activities.activity_type = 'REMOVED'::activitytype))))
  GROUP BY problems.id, problems.title, problems.proposal, a.number_of_votes, b.datetime, c.first_name, c.last_name
  ORDER BY problems.id;


--
-- Name: comments_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id) ON DELETE CASCADE;


--
-- Name: comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: permissions_res_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_res_name_fkey FOREIGN KEY (res_name) REFERENCES resources(name);


--
-- Name: photos_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id);


--
-- Name: photos_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: problems_activities_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY problems_activities
    ADD CONSTRAINT problems_activities_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id) ON DELETE CASCADE;


--
-- Name: problems_activities_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY problems_activities
    ADD CONSTRAINT problems_activities_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: problems_problem_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_problem_type_id_fkey FOREIGN KEY (problem_type_id) REFERENCES problem_types(id);


--
-- Name: problems_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY problems
    ADD CONSTRAINT problems_region_id_fkey FOREIGN KEY (region_id) REFERENCES regions(id);


--
-- Name: role_permissions_perm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY role_permissions
    ADD CONSTRAINT role_permissions_perm_id_fkey FOREIGN KEY (perm_id) REFERENCES permissions(id);


--
-- Name: role_permissions_role_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY role_permissions
    ADD CONSTRAINT role_permissions_role_name_fkey FOREIGN KEY (role_name) REFERENCES roles(name);


--
-- Name: solutions_administrator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_administrator_id_fkey FOREIGN KEY (administrator_id) REFERENCES users(id);


--
-- Name: solutions_problem_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_problem_id_fkey FOREIGN KEY (problem_id) REFERENCES problems(id) ON DELETE CASCADE;


--
-- Name: solutions_responsible_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_responsible_id_fkey FOREIGN KEY (responsible_id) REFERENCES users(id);


--
-- Name: user_roles_role_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_role_name_fkey FOREIGN KEY (role_name) REFERENCES roles(name);


--
-- Name: user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: users_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_region_id_fkey FOREIGN KEY (region_id) REFERENCES regions(id);


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


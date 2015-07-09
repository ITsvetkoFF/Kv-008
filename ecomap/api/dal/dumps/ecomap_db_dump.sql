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
    user_id integer NOT NULL,
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
    resource_id integer NOT NULL,
    action actions NOT NULL,
    modifier modifiers NOT NULL
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
    datetime timestamp without time zone NOT NULL,
    comment text,
    problem_id integer NOT NULL,
    user_id integer NOT NULL
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
    problem_type_id integer,
    region_id integer
);


ALTER TABLE public.problems OWNER TO ecouser;

--
-- Name: problems_activities; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE problems_activities (
    id integer NOT NULL,
    problem_id integer NOT NULL,
    user_id integer NOT NULL,
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
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.resources OWNER TO ecouser;

--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: ecouser
--

CREATE SEQUENCE resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resources_id_seq OWNER TO ecouser;

--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ecouser
--

ALTER SEQUENCE resources_id_seq OWNED BY resources.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE role_permissions (
    role integer NOT NULL,
    permission integer NOT NULL
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
    "user" integer NOT NULL,
    role integer NOT NULL
);


ALTER TABLE public.user_roles OWNER TO ecouser;

--
-- Name: users; Type: TABLE; Schema: public; Owner: ecouser; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100),
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

ALTER TABLE ONLY resources ALTER COLUMN id SET DEFAULT nextval('resources_id_seq'::regclass);


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
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('comments_id_seq', 1, false);


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY pages (id, alias, title, content, is_resource) FROM stdin;
1	about	Про проект	  <p>Дуже часто про локальні проблеми знають тільки місцеві організації та декілька сот жителів. А як було б добре підключити до їх вирішення однодумців з інших частин країни!</p><p><br/></p><p>Цей проект замислювався Всесвітнім фондом природи в Україні як платформа, здатна об’єднати зусилля громадян, різних неурядових організацій та компаній для обміну досвідом та покращення стану навколишнього середовища в Україні.</p><p><br/></p><p>Ви можете позначити екологічну проблему на карті, дізнатися у розділі Ресурси про те, як її вирішити та разом з однодумцями взятися до справи. Або долучитися до вирішення інших проблем у різних куточках України. Якщо Вам необхідна додаткова інформація, надішліть нам лист із запитом. Якщо у Вас є досвід, поділіться ним! Майбутнє країни у наших руках!</p><p><br/></p><p>До вирішення 3-х найважливіших проблем (за результатами голосування) долучиться безпосередньо команда WWF в Україні.</p><p><br/></p><p>Практичну реалізацію проект отримав, як і всі добрі починання, силами активних та небайдужих людей. Початковий варіант цього сайту був написаний 3-ма людьми за 48 годин в межах доброчинного хакатону Hack4Good.</p><p><br/></p><p>Післі того екологічна карта була повністю оновлена та дороблена командою молодих програмістів IT Академії компанії SoftServe під керівництвом Ігоря Цвєткова. Дякуємо всім активістам за допомогу в реалізації цього корисного проекту!</p><p><br/></p><p>Але нам також потрібна Ваша посильна допомога для підтримки та покращення екокарти. Долучайтесь!</p><p><br/></p><p>Якщо Ви вмілий програміст і бажаєте допомагати в розвитку проекту – ми будемо раді бачити Вас в нашій команді;</p><p>Якщо Ви маєте зауваження чи побажання щодо розширення функціональності проекту;</p><p>Ми також шукаємо людей для наповнення інформаційної секції «Ресурси»;</p><p>На початковій стадії запуску цього сервісу кожний активний користувач для нас на вагу золота, тож люб’язно просимо нас лайкати і про нас щебетати.</p><p>Що більше людей та організацій долучаться, то більше ми зможемо зробити для природи України!</p><p>Контакти</p><p>Oлександра Ковбаско: alex.kovbasko@gmail.com</p><p>Дмитро Григор'єв: grigorev007@gmail.com</p><ul>&#10;    </ul>&#10;  <p></p>&#10;	t
2	cleaning	Як організувати прибирання в парку	  <ol>\n    <li>Обійди територію парку\n      <ol>\n        <li>запиши собі місця найбільших засмічень</li>\n        <li>вибери місце з гарним орієнтиром для зустрічі з активістами</li>\n        <li>вибери місце зручне для під&#8217;їзду сміттєвоза</li>\n      </ol>\n    </li>\n    <li>Вибери зручний день і час для проведення прибирання протягом 2-3 годин. Домовся про це з адміністрацією парку, якщо така є</li>\n    <li>Домовся із перевізником про вивезення сміття в зазначений день і потрібний час із місця зручного для під&#8217;їзду сміттєвоза\n      <ol>\n        <li>Перевізнику відходів важливо, щоб вони були якісно посортовані &#8208; домовся з ним про кількість фракцій і про те, які типи сміття можна класти разом з іншими</li>\n        <li>Домовся про мінімальну кількість відходів, яку готовий вивезти перевізник. В середньому за 2-3 години один учасник збирає 3-4 120-літрових пакети зі сміттям. Загалом же більше половини сміття буде змішане (деякі перевізники його не забирають принципово), а все інше буде окремо скло і окремо пластик у різних співвідношеннях (яке залежить від багатьох факторів)</li>\n        <li>Перевізнику важливо, щоб про нього написали (на сайті і в соц.мережах), що він зробив таку гарну справу &#8208; допоміг вивезти відходи! Підготуйся зробити це і розказати про такі плани на зустрічі з його представником</li>\n        <li>Перевізник зможе краще виконати свою частину роботи, якщо матиме на руках карту із точними вказівками, куди їхати. <a href="http://purpose.com.ua/LDU/Maps.doc">Ось приклад</a> такої карти (зроблено за допомогою Google Maps)</li>\n      </ol>\n    </li>\n\n    <li>Максимально широко повідом про заплановану акцію\n      <ol>\n        <li>в різних соціальних мережах</li>\n        <li>за допомогою об&#8217;яв на дошках для оголошень на будинках навколо парку</li>\n        <li>попроси друзів та знайомих поширити запрошення на акцію і прийти самим</li>\n        <li>Залучи на акцію найближчі до парку організації &#8208; домовся про участь хоча б 5-10 чоловік від кожної:\n          <ol>\n            <li>школи</li>\n            <li>ВНЗ\n              <ol>\n                <li>За декілька днів до акції обов&#8217;язково особисто поговоріть із тими, хто приведе на акцію студентів або школярів &#8208; важливо налаштувати цих керівників на позитивне ставлення до акції &#8208; щоб вони саме так подавали її своїм підопічним (щоб участь в акції не була зіпсована негативним до неї ставленням!)</li>\n              </ol>\n            </li>\n            <li>громадські організації</li>\n            <li>компанії та підприємства\n              <ol>\n                <li>Організаціям та компаніям часто важливо, щоб про них написали (на сайті і в соц.мережах), що вони зробили таку гарну справу &#8208; допомогли провести акцію! Підготуйся зробити це і розказати про такі плани на зустрічі з їх представниками</li>\n                <li>Ось приклад <a href="https://docs.google.com/document/pub?id=1DdguRFaLp3Mb5tl4AB4QnEZn2KZNiNi6i3HiPSaG3LQ">партнерської пропозиції</a> і того, що партнер може <a href="https://docs.google.com/document/pub?id=1QMTIpVDrzE3zi8r4mxA4a42awDlUnSh3QHAarmq9IrY">отримати за підтримку</a> акції</li>\n              </ol>\n            </li>\n            <li>відомих людей\n              <ol>\n                <li>Ось приклад <a href="https://docs.google.com/document/pub?id=1j9k5OZkg9Sq9SUALsDcm5ONga4MkjwcPlF9LEU2h13w">пропозиції для відомої людини</a></li>\n              </ol>\n            </li>\n          </ol>\n        </li>\n      </ol>\n    </li>\n  \n\n    <li>Оціни можливу кількість учасників акції і забезпеч кожного матеріалами для прибирання (іх можна придбати за допомогою організацій з п.5)\n      <ol>\n        <li>Три пакети для сміття по 120 літрів кожен</li>\n        <li>Пара рукавичок з матерії</li>\n        <li>не обов&#8217;язково 0,5 літрів води</li>\n        <li>не обов&#8217;язково 1-2 вологих серветки або рідкий антисептик\n          <ul>\n            <li>Ось <a href="https://docs.google.com/spreadsheet/pub?hl=uk&hl=uk&key=0AiZ6hAt9NrE_dDhuR2hHTGN4NnFhMXFVNTM0QUZOOHc&output=html">приклад розрахунку бюджету</a> акції</li>\n          </ul>\n        </li>\n      </ol>\n    </li>\n\n    <li>Знайди собі 1-2 помічників. Чітко розподіліть між собою ролі під час проведення акції\n      <ol>\n        <li>інструктаж учасників про роздільний збір сміття і обережність поводження з ним\n          <ul>\n            <li>Ось <a href="https://docs.google.com/document/pub?id=1EPoVAX8_8m3MIf9p3xBlk9RRprY-Nw2r7qVeb_uW8hc">приклад інструкції для учасників</a> &#8208; краще її зачитати вголос (з листочків її не читають)</li>\n          </ul>\n        </li>\n        <li>видача матеріалів для прибирання</li>\n        <li>фотографування, запис відео-інтерв&#8217;ю</li>\n        <li>залучення до прибирання відвідувачів парку</li>\n        <li>зв&#8217;язок з водієм сміттєвоза</li>\n        <li>облік результатів акції (ось приклад анкети для координатораприбирання в парку)\n          <ol>\n            <li>кількість учасників прибирання &#8208; їх краще рахувати під час видачі рукавиць<li>\n            <li>кількість зібраних пакетів з пластиком<li>\n            <li>кількість зібраних пакетів зі склом<li>\n            <li>кількість зібраних пакетів з іншим сміттям<li>  \n          </ol>\n        </li>\n      </ol>\n    </li>\n  \n    <li>Проведи акцію</li>\n  </ol>\n\n  <p>Подякуй учасникам (у найкращих і найбільш свідомих бажано взяти контакти для подальшої співпраці) та залученим організаціям. Опублікуй подяку, результати акції, фото та записані відео-інтерв&#8217;ю в соціальних мережах і в блогах. Перешли на <a href="mailto:info@letsdoit.org.ua">info@letsdoit.org.ua</a> результати акції та посилання на фотографії та відео.</p>\n\n  <p>Все про сміття та як з ним боротися знає аполітична некомерційна громадська ініціатива &laquo;Зробимо Україну чистою!&raquo;, частина Всесвітнього руху <a href="http://letsdoitworld.org">&quot;Let&#8217;s do it!&quot; (http://letsdoitworld.org)</a>.</p>\n\n  <p>Мета ініціативи &#8208; докорінно змінити ставлення українців до життєвого простору, прищепити в суспільстві потребу не смітити та дбати про довкілля. Досягти її можна, змінивши повсякденні звички людей &#8208; шляхом дій, спрямованих на створення в Україні чистоти і краси (працюючи над вирішенням проблеми, людина стає частиною рішення).</p>\n\n  <a href="http://letsdoit.org.ua/">http://letsdoit.org.ua/</a>\n	t
3	removing	Як добитись ліквідації незаконного звалища?	  <p>В Україні налічуються десятки тисяч несанкціонованих звалищ побутових або будівельних відходів. Більшість таких звалищ розміщені  на природних ділянках, особливо  часто &#8208; в ярах, балках, на узліссях і берегах річок.</p>\n  \n  <p>Звалища являють собою ділянки землі, на яких безконтрольно зберігаються побутові відходи. Часто для зменшення об&#8217;єму відходів звалища підпалують. Такий підхід є неприпустимим, оскільки звалища є серйозним джерелом забруднення як повітряного так і водного середовища. Жоден з таких самовільно створених пунктів скидання відходів не обладнаний відповідним чином, продукти гниття і розпаду потрапляють у ґрунт і ґрунтові води. Температура гниття подекуди настільки висока, що часто легко призводить до їх займання, до того ж у повітря викидається неймовірна кількість шкідливих речовин.</p>\n\n  <p>Згідно законодавства України про відходи, відповідальність за відходи перш за все покладається на власника відходів.</p>\n\n  <p>Стаття 12 Закону визначає, що відходи без власника визначаються як безхазяйні. У випадку, якщо безхазяйні відходи виявлено на земельній ділянці, яка належить приватній особі, ця особа зобов&#8217;язана повідомити про ці відходи органи влади, які, в свою чергу, повинні вжити заходів для визначення власника відходів, класу їх небезпеки, здійснення обліку цих відходів та прийняти рішення щодо поводження з ними.</p>\n\n  <p>Стаття 9. предбачає, що безхазяйні відходи, які знаходяться на об&#8217;єктах територіальної громади, є власністю цієї територіальної громади. Власником безхазяйних відходів, які знаходяться на території України, однак не належать до власності територіальної громади, вважається держава.</p>\n\n  <p>Іншими словами, якщо власника безхазяйних відходів неможливо визначити, то держава або місцеві органи самоврядування беруть на себе відповідальність за такі відходи способом, визначеним в Статті 9 та Статті 12.</p>\n\n  <p>Щоб побороти таке порушення, необхідно відправити поштою кілька листів.</p>\n  \n  <p>Зразок листа дивіться нижче. У доданому нижче зразку заповніть пропуски та замініть підкреслені слова на Ваші дані. По кожному сміттєзвалищу треба окремий листі картинка в додаток (фото і карта де знаходиться звалище; можна принтскрін з Гуглкарт, Яндекскарт тощо).<br/><br/>\n\n  <a href="/docs/official-letter-to-clear-up-illegal-dump.docx">Качнути зразок листа (Word Document)</a></p>\n\n  <p>Інформація надана Національним екологічним центром України <a href="http://necu.org.ua/">http://necu.org.ua/</a></p>\n	t
4	stopping-exploitation	Як зупинити комерційну експлуатацію тварин?	  <p>Дуже часто в туристичних містах людям пропонують сфотографуватись з тваринами, найчастіше це хижі птахи і сови. Більшість видів хижих птахів в Україні занесені до Червоної книги України. Крім того, така діяльність є жорстоким поводженням з птахами.</p>\n\n  <p>Щоб побороти таке порушення, необхідно відправити поштою кілька листів.</p>\n\n  <p>Зразок листа дивіться нижче. По кожному випадку треба окремий лист і фотографія в додаток. У доданому нижче зразку заповніть пропуски та замініть підкреслені слова на Ваші дані.<br/><br/>\n\n  <a href="/docs/official-letter-to-stop-animal-exploitation.docx">Качнути зразок листа (Word Document)</a></p>\n\n  <p>Інформація надана Національним екологічним центром України <a href="http://necu.org.ua/">http://necu.org.ua/</a></p>\n	t
5	stopping-trade	Торгують первоцвітами - телефонуй: "102-187!"	  <p>Активісти природоохоронних організацій закликають кожного не бути байдужим до нищення зникаючих видів рослин та викликати міліцію кожного разу, коли ви бачите торгівлю первоцвітами. Природоохоронці впевнені, що громадяни мають бути свідомими і не допускати порушення законодавства, міліція має виконувати свої обв&#8217;язки, а порушники мають отримати передбачене покарання.</p>\n\n  <p>Всі види підсніжників і більшість інших ранньоквітучих рослин зникають в природі через торгівлю букетами з їх квітів і тому занесені до Червоної книги. Те саме стосується черемші. Збір та торгівля первоцвітами в Україні заборонені низкою законів, зокрема, законом &#171;Про Червону книгу України&#187; та законом &#171;Про рослинний світ&#187;. На порушників накладається штраф відповідно до статей 88-1 та 160 Кодексу України про адміністративні правопорушення. Також за кожну рослину нараховуються збитки, нанесені державі її знищенням.</p>\n\n  <p>Що робити? Кожен з нас має усвідомити особисту відповідальність у справі збереження рідкісних видів рослин. Головне, не бути байдужим і не проходити повз порушників; у разі виявлення фактів торгівлі первоцвітами потрібно обов&#8217;язково звертатись по допомогу до працівників міліції, якщо вони є поруч, або телефонувати 102 та викликати підрозділ ППС на місце незаконної торгівлі. Міліція зобов&#8217;язана реагувати на подібні виклики, зокрема, у рамках операції &#171;Первоцвіт&#187;, яка триває в Україні. Міліціонер повинен зупинити торгівлю і  бажано &#8208; вилучити або знищити квіти.</p>\n\n  <p>Знищення букетів не є чимось аморальним. Кожен роздрібний торгівець купує зранку квіти на вокзалі у оптовиків, які привезли їх у велике місто з Криму або Карпат, витрачаючи кілька тисяч гривень на оптову партію. Вилучення букетів гарантує матеріальний удар по порушнику, що відбиває бажання наступного дня повторити протиправну торгівлю.</p>\n\n  <p>Інформація для журналістів. Практика показує, що працівники міліції дуже старанно виконують свої обов&#8217;язки, коли їх про це просить людина з посвідченням журналіста.</p>\n\n  <p>Інформація надана Національним екологічним центром України <a href="http://necu.org.ua/">http://necu.org.ua/</a></p>\n	t
6	testing	Test	<p>lololololo</p>	t
\.


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('pages_id_seq', 6, true);


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY permissions (id, resource_id, action, modifier) FROM stdin;
\.


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('permissions_id_seq', 1, false);


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY photos (id, name, datetime, comment, problem_id, user_id) FROM stdin;
\.


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('photos_id_seq', 1, false);


--
-- Data for Name: problem_types; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY problem_types (id, type) FROM stdin;
\.


--
-- Name: problem_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('problem_types_id_seq', 1, false);


--
-- Data for Name: problems; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY problems (id, title, content, proposal, severity, location, status, problem_type_id, region_id) FROM stdin;
\.


--
-- Data for Name: problems_activities; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY problems_activities (id, problem_id, user_id, datetime, activity_type) FROM stdin;
\.


--
-- Name: problems_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('problems_activities_id_seq', 1, false);


--
-- Name: problems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('problems_id_seq', 1, false);


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY regions (id, name, location) FROM stdin;
\.


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('regions_id_seq', 1, false);


--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY resources (id, name) FROM stdin;
\.


--
-- Name: resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('resources_id_seq', 1, false);


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY role_permissions (role, permission) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY roles (id, name) FROM stdin;
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('roles_id_seq', 1, false);


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

COPY user_roles ("user", role) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: ecouser
--

COPY users (id, first_name, last_name, email, password, region_id, google_id, facebook_id) FROM stdin;
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ecouser
--

SELECT pg_catalog.setval('users_id_seq', 1, false);


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
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: ecouser; Tablespace: 
--

ALTER TABLE ONLY role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role, permission);


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
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY ("user", role);


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
-- Name: permissions_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES resources(id);


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
-- Name: role_permissions_permission_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY role_permissions
    ADD CONSTRAINT role_permissions_permission_fkey FOREIGN KEY (permission) REFERENCES permissions(id);


--
-- Name: role_permissions_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY role_permissions
    ADD CONSTRAINT role_permissions_role_fkey FOREIGN KEY (role) REFERENCES roles(id);


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
-- Name: user_roles_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_role_fkey FOREIGN KEY (role) REFERENCES roles(id);


--
-- Name: user_roles_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ecouser
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_user_fkey FOREIGN KEY ("user") REFERENCES users(id);


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


DROP DATABASE IF EXISTS ecomap_db;
DROP ROLE IF EXISTS ecouser;
CREATE DATABASE ecomap_db;
CREATE USER ecouser WITH PASSWORD 'ecouser';
ALTER USER ecouser SUPERUSER;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ecouser;

\CONNECT 'ecomap_db';
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
SET SCHEMA 'public';

CREATE TYPE Status AS ENUM ('SOLVED', 'UNSOLVED');`
CREATE TYPE ActivityType AS ENUM ('ADDED', 'REMOVED', 'UPDATED');
CREATE TYPE SeverityTypes AS ENUM ('1', '2', '3');
CREATE TYPE Modifiers AS ENUM ('ANY', 'OWN', 'NONE');
CREATE TYPE Actions AS ENUM ('GET', 'PUT', 'POST', 'DELETE');

CREATE TABLE problem_types
(
  id   SERIAL PRIMARY KEY,
  type VARCHAR(100) NOT NULL
);

CREATE TABLE roles
(
  id   SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(100)       NOT NULL
);

CREATE TABLE regions
(
  id       SERIAL PRIMARY KEY NOT NULL,
  name     VARCHAR(100)       NOT NULL,
  location GEOMETRY           NOT NULL
);

CREATE TABLE users
(
  id          SERIAL PRIMARY KEY NOT NULL,
  first_name  VARCHAR(64)        NOT NULL,
  last_name   VARCHAR(64)        NOT NULL,
  email       VARCHAR(128)       NOT NULL,
  password    VARCHAR            NOT NULL,
  region_id   INT                NOT NULL,
  google_id   VARCHAR(30),
  facebook_id VARCHAR(20),

  FOREIGN KEY (region_id) REFERENCES regions (id) ON DELETE CASCADE
);

CREATE TABLE users_roles (
  user_id INT NOT NULL,
  role_id INT NOT NULL,

  PRIMARY KEY (user_id, role_id),

  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE
);

CREATE TABLE problems
(
  id             SERIAL PRIMARY KEY NOT NULL,
  title          VARCHAR(100)       NOT NULL,
  content        VARCHAR            NOT NULL,
  proposal       TEXT               NOT NULL,
  severity       SeverityTypes      NOT NULL,
  status         Status             NOT NULL,
  problemtype_id INT                NOT NULL,
  region_id      INT                NOT NULL,
  location       GEOMETRY           NOT NULL,

  FOREIGN KEY (problemtype_id) REFERENCES problem_types (id) ON DELETE CASCADE,
  FOREIGN KEY (region_id) REFERENCES regions (id) ON DELETE CASCADE
);

CREATE TABLE photos
(
  id         SERIAL PRIMARY KEY NOT NULL,
  link       VARCHAR(200)       NOT NULL,
  status     Status             NOT NULL,
  coment     VARCHAR(500)       NOT NULL,
  problem_id INT                NOT NULL,
  user_id    INT                NOT NULL,

  FOREIGN KEY (problem_id) REFERENCES problems (id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE photos_activities
(
  id            SERIAL PRIMARY KEY,
  photo_id      INT          NOT NULL,
  problem_id    INT          NOT NULL,
  user_id       INT          NOT NULL,
  date          TIMESTAMP    NOT NULL,
  activity_type ActivityType NOT NULL,

  FOREIGN KEY (photo_id) REFERENCES photos (id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (problem_id) REFERENCES problems (id) ON DELETE CASCADE
);

CREATE TABLE problems_activities
(
  id            SERIAL PRIMARY KEY NOT NULL,
  problem_id    INT                NOT NULL,
  data          JSON               NOT NULL,
  user_id       INT                NOT NULL,
  date          TIMESTAMP          NOT NULL,
  activity_type ActivityType       NOT NULL,

  FOREIGN KEY (problem_id) REFERENCES problems (id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE votes_activities
(
  id         SERIAL PRIMARY KEY NOT NULL,
  problem_id INT                NOT NULL,
  user_id    INT                NOT NULL,
  date       TIMESTAMP          NOT NULL,

  FOREIGN KEY (problem_id) REFERENCES problems (id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES problems (id) ON DELETE CASCADE
);

CREATE TABLE comments
(
  id         SERIAL PRIMARY KEY NOT NULL,
  content    TEXT               NOT NULL,
  user_id    INT                NOT NULL,
  problem_id INT                NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (problem_id) REFERENCES problems (id) ON DELETE CASCADE
);

CREATE TABLE comments_activities
(
  id            SERIAL PRIMARY KEY NOT NULL,
  problem_id    INT                NOT NULL,
  user_id       INT                NOT NULL,
  commet_id     INT                NOT NULL,
  date          TIMESTAMP          NOT NULL,
  activity_type ActivityType       NOT NULL,

  FOREIGN KEY (problem_id) REFERENCES problems (id) ON DELETE CASCADE,
  FOREIGN KEY (commet_id) REFERENCES comments (id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE resources
(
  id   SERIAL PRIMARY KEY,
  name VARCHAR(100)
);

CREATE TABLE permissions
(
  id          SERIAL PRIMARY KEY NOT NULL,
  resource_id INT                NOT NULL,
  action      Actions            NOT NULL,
  modifier    Modifiers          NOT NULL,

  UNIQUE (resource_id, action, modifier),

  FOREIGN KEY (resource_id) REFERENCES resources (id) ON DELETE CASCADE
);

CREATE TABLE roles_permissions
(
  role_id       INT NOT NULL,
  permission_id INT NOT NULL,
  PRIMARY KEY (permission_id, role_id),

  FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE
);

CREATE TABLE solutions
(
  problem_id         INT                NOT NULL,
  administrator_id   INT                NOT NULL,
  problem_manager_id INT                NOT NULL,
  id                 SERIAL PRIMARY KEY NOT NULL,

  FOREIGN KEY (administrator_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (problem_manager_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (problem_id) REFERENCES problems (id) ON DELETE CASCADE
);

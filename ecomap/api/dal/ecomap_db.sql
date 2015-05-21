DROP DATABASE IF EXISTS ecomap_db;
DROP ROLE IF EXISTS ecouser;
CREATE DATABASE ecomap_db;
CREATE USER ecouser WITH password 'ecouser';
GRANT ALL privileges ON DATABASE ecomap_db TO ecouser;

ALTER ROLE ecouser SUPERUSER;
\connect 'ecomap_db';
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
-- ALTER ROLE ecouser NOSUPERUSER;
SET SCHEMA 'public';

CREATE TYPE Status AS ENUM ('USER', 'ADMINISTRATOR', 'UNREGISTERED_USER');
CREATE TYPE ActivityType AS ENUM ('ADDED', 'REMOVED', 'UPDATED');
CREATE TYPE SeverityTypes AS ENUM ('1', '2', '3');
CREATE TYPE Operation AS ENUM ('get', 'put', 'post', 'delete');
CREATE TYPE Modifier AS ENUM ('any', 'own', 'none');


CREATE TABLE problem_types
(
    id SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL
);

CREATE TABLE user_roles
(
    id SERIAL PRIMARY KEY NOT NULL,
    role VARCHAR(100) NOT NULL
);

CREATE TABLE users
(
  id SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(64) NOT NULL,
  surname VARCHAR(64) NOT NULL,
  email VARCHAR(128) NOT NULL,
  password VARCHAR NOT NULL,
  userrole_id INT NOT NULL,

    FOREIGN KEY (userrole_id) REFERENCES user_roles(id)
);

CREATE TABLE region
(
  id SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(100) NOT NULL,
  location GEOMETRY NOT NULL
);

CREATE TABLE problems
(
  id SERIAL PRIMARY KEY NOT NULL,
  title VARCHAR(100) NOT NULL,
  content VARCHAR NOT NULL,
  proposal TEXT NOT NULL,
  severity SeverityTypes NOT NULL,
  votes INT NOT NULL,
  location GEOMETRY NOT NULL,
  status Status NOT NULL,
  problemtype_id INT NOT NULL,
  region_id int NOT NULL,

  FOREIGN KEY (problemtype_id) REFERENCES problem_types(id),
  FOREIGN KEY (region_id) REFERENCES region(id)
);

CREATE TABLE photos
(
    id SERIAL PRIMARY KEY NOT NULL,
    link VARCHAR(200) NOT NULL,
    status Status NOT NULL,
    coment VARCHAR(500) NOT NULL,
    problem_id INT NOT NULL,
    user_id INT NOT NULL,

    FOREIGN KEY (problem_id) REFERENCES problems(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE photos_activities
(
  id SERIAL PRIMARY KEY,
  photo_id INT NOT NULL,
  problem_id INT NOT NULL,
  user_id INT NOT NULL,
  date DATE NOT NULL,
  activity_type ActivityType NOT NULL,

    FOREIGN KEY (photo_id) REFERENCES photos(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (problem_id) REFERENCES problems(id)
);

CREATE TABLE problem_activities
(
  id SERIAL PRIMARY KEY NOT NULL,
  problem_id INT NOT NULL,
  data JSON NOT NULL,
  user_id INT NOT NULL,
  date DATE NOT NULL,
  activity_type ActivityType NOT NULL,

    FOREIGN KEY (problem_id) REFERENCES problems(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE votes_activities
(
  id SERIAL PRIMARY KEY NOT NULL,
  problem_id INT NOT NULL,
  user_id INT NOT NULL,
  date DATE NOT NULL,

  FOREIGN KEY (problem_id) REFERENCES problems(id),
  FOREIGN KEY (user_id) REFERENCES problems(id)
);

CREATE TABLE comments
(
  id SERIAL PRIMARY KEY NOT NULL,
  content TEXT NOT NULL,
  user_id INT NOT NULL,
  problem_id INT NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (problem_id) REFERENCES problems(id)
);

CREATE TABLE comments_activities
(
  id SERIAL PRIMARY KEY NOT NULL,
  problem_id INT NOT NULL,
  user_id INT NOT NULL,
  commet_id INT NOT NULL,
  date DATE NOT NULL,
  activity_type ActivityType NOT NULL,

  FOREIGN KEY (problem_id) REFERENCES problems(id),
  FOREIGN KEY (commet_id) REFERENCES comments(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE resources (
  id SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE permissions
(
    id SERIAL PRIMARY KEY NOT NULL,
    resource_id INT NOT NULL,
    operation Operation,
    modifier Modifier,

    FOREIGN KEY (resource_id) REFERENCES resources(id)
);

CREATE TABLE roles2permissions
(
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),

    FOREIGN KEY (permission_id) REFERENCES permissions(id),
    FOREIGN KEY (role_id) REFERENCES user_roles(id)
);

CREATE TABLE solutions
(
    problem_id INT NOT NULL,
    administrator_id INT NOT NULL,
    problemmaager_id INT NOT NULL,
    id SERIAL PRIMARY KEY NOT NULL,

    FOREIGN KEY (administrator_id) REFERENCES users(id),
    FOREIGN KEY (problemmaager_id) REFERENCES users(id),
    FOREIGN KEY (problem_id) REFERENCES problems(id)
);

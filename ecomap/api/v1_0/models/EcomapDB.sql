--CREATE TYPE ;

CREATE TABLE activities
(
    id SERIAL PRIMARY KEY NOT NULL,
    content VARCHAR,
    date TIMESTAMP NOT NULL,
    activitytype_id INT NOT NULL,
    user_id INT NOT NULL,
    problem_id INT NOT NULL,
  FOREIGN KEY (activitytype_id) REFERENCES activitytypes (id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (problem_id) REFERENCES problems (id)
);

CREATE TABLE activitytypes
(
    id SERIAL PRIMARY KEY NOT NULL,
    type VARCHAR(100) NOT NULL
);

CREATE TABLE permissions
(
    id SERIAL PRIMARY KEY NOT NULL,
    permission VARCHAR(100) NOT NULL
);

CREATE TABLE photos
(
    id SERIAL PRIMARY KEY NOT NULL,
    link VARCHAR(200) NOT NULL,
    status INT NOT NULL,
    coment VARCHAR(500) NOT NULL,
    problem_id INT NOT NULL,
    user_id INT NOT NULL,
  FOREIGN KEY (problem_id) REFERENCES problems(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE problems
(
    id SERIAL PRIMARY KEY NOT NULL,
    title VARCHAR(100) NOT NULL,
    content VARCHAR NOT NULL,
    proposal INT NOT NULL,
    severity INT NOT NULL,
    moderation INT NOT NULL,
    votes INT NOT NULL,
    location INT NOT NULL,
    status INT NOT NULL,
    problemtype_id INT NOT NULL,
  FOREIGN KEY (problemtype_id) REFERENCES problemtypes(id)
);

CREATE TABLE problemtypes
(
    id SERIAL PRIMARY KEY NOT NULL,
    type VARCHAR(100) NOT NULL
);

CREATE TABLE rolepermission
(
    permission_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (permission_id, role_id),
  FOREIGN KEY (permission_id) REFERENCES permissions(id),
  FOREIGN KEY (role_id) REFERENCES userroles(id)
);
CREATE TABLE solutions
(
    problem_id INT NOT NULL,
    administrator_id INT NOT NULL,
    problemmaager_id INT NOT NULL,
    id SERIAL PRIMARY KEY NOT NULL,
  FOREIGN KEY (administrator_id) REFERENCES users(id),
  FOREIGN KEY (problemmaager_id) REFERENCES users(id)
);

CREATE TABLE userroles
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
  FOREIGN KEY (userrole_id) REFERENCES userroles(id)
);

CREATE TYPE Status AS ENUM ('User', 'Administrator', 'Unregistered user');
CREATE TYPE ActivityType AS ENUM ('added', 'removed', 'updated');
CREATE TYPE SeverityTypes AS ENUM ('', '', '', '', '');

CREATE TABLE PhotosActivity
(
  id SERIAL PRIMARY KEY NOT NULL,
  photo_id INT NOT NULL,
  problem_id INT NOT NULL,
  user_id INT NOT NULL,
  date DATE NOT NULL,
  activity_type ActivityType NOT NULL,
  FOREIGN KEY (photo_id) REFERENCES photos(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (problem_id) REFERENCES problems(id)
);

CREATE TABLE Region
(
  id SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(100) NOT NULL,
  location GEOMETRY NOT NULL,
);

CREATE TABLE ProblemActivities
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

CREATE TABLE VotesActivities
(
  id SERIAL PRIMARY KEY NOT NULL,
  problem_id INT NOT NULL,
  user_id INT NOT NULL,
  date DATE NOT NULL,
  FOREIGN KEY (problem_id) REFERENCES problems(id),
  FOREIGN KEY (user_id) REFERENCES problems(id)
);

CREATE TABLE CommentsActivities
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

CREATE TABLE comments
(
  id SERIAL PRIMARY KEY NOT NULL,
  content TEXT NOT NULL,
  user_id INT NOT NULL,
  problem_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (problem_id) REFERENCES problems(id)
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
    status Status NOT NULL,
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
    proposal TEXT NOT NULL,
    severity SeverityTypes NOT NULL,
    votes INT NOT NULL,
    location GEOMETRY NOT NULL,
    status Status NOT NULL,
    problemtype_id INT NOT NULL,
  region_id int NOT NULL,
  FOREIGN KEY (problemtype_id) REFERENCES problemtypes(id),
  FOREIGN KEY (region_id) REFERENCES Region(id)
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
  FOREIGN KEY (problemmaager_id) REFERENCES users(id),
  FOREIGN KEY (problem_id) REFERENCES problems(id)
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

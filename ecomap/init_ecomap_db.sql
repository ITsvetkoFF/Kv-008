DROP DATABASE IF EXISTS ecomap_db;
DROP ROLE IF EXISTS ecouser;
CREATE DATABASE ecomap_db;
CREATE USER ecouser WITH PASSWORD 'ecouser';
ALTER USER ecouser WITH SUPERUSER;

-- careful when auto-formatting, this \CONNECT always breaks
\c ecomap_db;
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;

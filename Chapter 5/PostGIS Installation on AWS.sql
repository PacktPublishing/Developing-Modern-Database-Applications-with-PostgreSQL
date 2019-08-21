CREATE EXTENSION postgis;

CREATE EXTENSION postgis_topology;

CREATE EXTENSION fuzzystrmatch;

CREATE EXTENSION postgis_tiger_geocoder;

CREATE EXTENSION address_standardizer;

SELECT name, default_version,installed_version
FROM pg_available_extensions WHERE name LIKE 'postgis%' or name LIKE 'address%';
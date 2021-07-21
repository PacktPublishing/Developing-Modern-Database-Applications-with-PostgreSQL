CREATE VIEW "ATM coordinates" AS
SELECT al.*, zc."geog"
FROM "ATM locations" al
INNER JOIN "Zip coordinates" zc
ON al."ZipCode" = zc."zip";

SELECT atm."BankName", atm."Address"
FROM "ATM coordinates" atm
ORDER BY geog <-> ST_SetSRID(ST_MakePoint(-74.00365, 40.709677), 4326);

SELECT atm."BankName", atm."Address"
FROM "ATM coordinates" atm
WHERE ST_DWithin(geog, ST_SetSRID(ST_MakePoint(-73.99337, 40.755101), 4326), 1000);


CREATE TABLE "Currencies"
(
    currencycode character varying(3) PRIMARY KEY, 
    currencyname text
);	

CREATE TABLE "ExchangeRates"
(
    "time" timestamp with time zone NOT NULL,
    openingrate double precision,
    highestrate double precision,
    lowestrate double precision,
    closingrate double precision,
    currencycode character varying(3) REFERENCES public."Currencies" (currencycode) ON DELETE CASCADE,
    PRIMARY KEY ("time", currencycode)
);

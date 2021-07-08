CREATE SEQUENCE public."ATM locations_ID_seq"
    INCREMENT 1
    START 658
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public."ATM locations_ID_seq"
    OWNER TO dba;

GRANT ALL ON SEQUENCE public."ATM locations_ID_seq" TO dba;

CREATE TABLE public."ATM locations"
(
    "ID" integer NOT NULL DEFAULT nextval('"ATM locations_ID_seq"'::regclass),
    "BankName" character varying(60) COLLATE pg_catalog."default" NOT NULL,
    "Address" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    "County" character varying(15) COLLATE pg_catalog."default" NOT NULL,
    "City" character varying(15) COLLATE pg_catalog."default" NOT NULL,
    "State" character(2) COLLATE pg_catalog."default" NOT NULL,
    "ZipCode" integer NOT NULL,
    CONSTRAINT "ATM locations_pkey" PRIMARY KEY ("ID")
)

TABLESPACE pg_default;

ALTER TABLE public."ATM locations"
    OWNER to dba;

GRANT ALL ON TABLE public."ATM locations" TO dba;

COMMENT ON TABLE public."ATM locations"
    IS 'ATM locations of New York city';

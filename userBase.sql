CREATE TABLE public."CLIENTS"
(
    nom "char",
    "numPass" "char" NOT NULL,
    ville "char",
    CONSTRAINT "CLIENTS_pkey" PRIMARY KEY ("numPass")
)

TABLESPACE pg_default;

ALTER TABLE public."CLIENTS"
    OWNER to postgres;
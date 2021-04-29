CREATE TABLE Clients
(
    numPass VARCHAR(9) PRIMARY KEY,
    nom VARCHAR(255) NOT NULL UNIQUE,
    ville VARCHAR(255) NOT NULL
);

---

CREATE TABLE Chambres
(
    numC NUMERIC(11) PRIMARY KEY,
    lits NUMERIC(11) NOT NULL DEFAULT 2,
    prix NUMERIC(11) NOT NULL
);

---

CREATE TABLE Reservations
(
    numR NUMERIC(11) PRIMARY KEY,
    date_arrivee date NOT NULL,
    date_depart date,
    numPass VARCHAR(9),
    numC NUMERIC(11),
    CONSTRAINT fk_reservation FOREIGN KEY(numPass) REFERENCES Clients(numPass) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_chambres FOREIGN KEY(numC) REFERENCES Chambres(numC) ON DELETE CASCADE ON UPDATE CASCADE

);

---

INSERT INTO Clients
VALUES
    ('HH123221', 'TAHA SRHAYAR', 'SAFI');
INSERT INTO Clients
VALUES
    ('HH124541', 'ADIL KHALID', 'CASABLANCA');
INSERT INTO Clients
VALUES
    ('HH123234', 'KHALID HAMDI', 'AGADIR');
INSERT INTO Clients
VALUES
    ('ZE762288', 'SALAH ADLI', 'SAFI');

---

INSERT INTO Reservations
VALUES
    (1, 1, '27/08/2021', '01/12/2020', 'HH123221');
INSERT INTO Reservations
VALUES
    (2, 1, '27/08/2021', '01/12/2020', 'HH123234');
INSERT INTO Reservations
VALUES
    (2, 3, '27/08/2021', '01/12/2020', 'HH124541');
INSERT INTO Reservations
VALUES
    (3, 4, '27/08/2021', '01/12/2020', 'ZE762288');


CREATE or replace FUNCTION chambresReserveLeMois8
()
RETURNS TABLE
(numC Numeric ,lits Numeric,prix Numeric) as $list$

---

BEGIN
    RETURN QUERY
    SELECT
        ch.*
    FROM
        chambres AS ch, reservations AS r
    WHERE ch.numC=r.numC AND EXTRACT(MONTH FROM r.date_arrivee )=08
    GROUP BY ch.numC;
END;
$list$ LANGUAGE 'plpgsql';
SELECT public.chambresreservelemois8()

CREATE or replace FUNCTION clientPlus700Dh
()
RETURNS TABLE
(numPass varchar ,nom varchar,ville varchar) as $list$

---

BEGIN
    RETURN QUERY
    SELECT
        cl.*
    FROM
        chambres AS ch, reservations AS r, "clients" AS cl
    WHERE ch.numC=r.numC AND r.numPass = cl.numPass AND ch.prix>700
    GROUP BY cl.numPass;
END;
$list$ LANGUAGE 'plpgsql';
SELECT public.clientPlus700Dh()

---

CREATE or replace FUNCTION chambreFirstA
()
RETURNS TABLE
(numC Numeric ,lits Numeric,prix Numeric) as $list$

BEGIN
    RETURN QUERY
    SELECT
        ch.*
    FROM
        chambres AS ch, reservations AS r, clients AS cl
    WHERE ch.numC=r.numC AND r.numPass = cl.numPass AND cl.nom Like'A%'
    GROUP BY ch.numC;
END;
$list$ LANGUAGE 'plpgsql';
SELECT public.chambreFirstA()

---

CREATE or replace FUNCTION client2Chambre
()
RETURNS TABLE
(numPass varchar ,nom varchar,ville varchar) as $list$
BEGIN
    RETURN QUERY
    SELECT
        cl.*
    FROM
        chambres AS ch, reservations AS r, clients AS cl
    WHERE ch.numC= r.numC AND r.numPass = cl.numPass
    GROUP BY cl.numPass
    having count(ch.numC)>2;
END;
$list$ LANGUAGE 'plpgsql';
SELECT public.client2Chambre()

---

CREATE or replace FUNCTION clientFromCasa
()
RETURNS TABLE
(numPass varchar ,nom varchar,ville varchar) as $list$
BEGIN
    RETURN QUERY
    SELECT
        cl.*
    FROM
        chambres AS ch, reservations AS r, clients AS cl
    WHERE ch.numC= r.numC AND r.numPass = cl.numPass AND cl.ville='Casablanca'
    GROUP BY cl.numPass
    having count(ch.numC)>2 AND count(r.numPass)>2
;
END;
$list$ LANGUAGE 'plpgsql';
SELECT public.clientFromCasa()

---

CREATE OR REPLACE PROCEDURE public.updatePrice
(
	)
LANGUAGE 'sql'
AS $BODY$
UPDATE chambres SET prix  = '1000' WHERE prix>700
$BODY$;

---

create or replace procedure supprimerClientplusdeuxreserv
()
language plpgsql    
as $delete$
begin
    delete from "clients" WHERE clients.numPass Not in(select numPass
    FROM reservations );
end;
$delete$
CALL public.supprimerclientplusdeuxreserv
()

---

create or replace procedure add100DhForBed
()
language plpgsql    
as $updatePrice$
begin
    update chambres 
    set prix = prix + 100
    where lits > 1;
end;$updatePrice$
CALL public.add100DhForBed
()

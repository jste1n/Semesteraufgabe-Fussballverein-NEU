-- df vornamen: word=givennames.list
-- df family: word=familynames.list
-- df position: word=position.list
-- df land: word=country.list
-- df plz: word=plz.list
-- df ort: word=ort.list
-- df liga: word=ligen.list


CREATE TABLE Person (			-- df: mult=15000.00
 persnr SERIAL NOT NULL PRIMARY KEY CHECK (persnr> 9999 and persnr%2=0),	-- df: offset=10000 step=2 size=3010001
 vname VARCHAR(255) NOT NULL,	-- df: text=vornamen length=1
 nname VARCHAR(255) NOT NULL,	-- df: text=family length=1
 geschlecht CHAR(1) NOT NULL CHECK (geschlecht ~* 'm|w|n'),	-- df: pattern='(M|W|N)' null=0.0
 gebdat DATE NOT NULL CHECK (gebdat between '1900-01-01' and '2017-01-01')			-- df: start=1916-01-01 end=2010-01-01
);
ALTER SEQUENCE Person_persnr_seq INCREMENT 2 MINVALUE 10000 START 10000 RESTART 10000 OWNED by Person.persnr;


CREATE TABLE Spieler (				-- df: mult=11000.00
 persnr INT NOT NULL PRIMARY KEY,	-- df: offset=10000 step=2 size=2200001
 position VARCHAR(255) NOT NULL,	-- df: text=position length=1
 gehalt DECIMAL NOT NULL,		--df: pattern='[0-9]{3,9}'
 von DATE NOT NULL,		-- df: start=1916-01-01 end=1960-01-01
 bis DATE NOT NULL,		-- df: start=1960-02-01 end=2016-01-01
 CHECK (von < bis),
 
 FOREIGN KEY (persnr) REFERENCES Person (persnr)
);


CREATE TABLE Standort (				-- df: mult=1000.00
 sid SERIAL NOT NULL PRIMARY KEY, 	-- df: offset=1
 land VARCHAR(255) NOT NULL,		-- df: text=land length=1
 plz INT NOT NULL,					-- df: text=plz length=1
 ort VARCHAR(255) NOT NULL,			-- df: text=ort length=1
 UNIQUE (plz, ort),	
 CHECK (sid > 0)
);
ALTER SEQUENCE Standort_sid_seq MINVALUE 1 OWNED BY Standort.sid;


CREATE TABLE Trainer (	-- df: mult=2000.00
 persnr INT NOT NULL PRIMARY KEY,	-- df: offset=2210000 step=2 size=400001
 gehalt DECIMAL(10) NOT NULL,	--df: pattern='[0-9]{3,8}'
 von DATE NOT NULL,		-- df: start=1916-01-01 end=1960-01-01
 bis DATE NOT NULL,		-- df: start=1960-02-01 end=2016-01-01

 FOREIGN KEY (persnr) REFERENCES Person (persnr)
);


CREATE TABLE Angestellter (	-- df: mult=1000.00
 persnr INT NOT NULL PRIMARY KEY,	-- df: offset=2610000 step=2 size=200001
 gehalt DECIMAL(10) NOT NULL,	--df: pattern='[0-9]{3,5}'
 ueberstunden TIMESTAMP(6) NOT NULL,	--df: start='1990-01-01 00:00:01' end='2016-01-01 23:59:59'
 e_mail VARCHAR(255) NOT NULL,		-- df: pattern='[a-z]{3,8}\.[a-z]{3,8}@(gmail|yahoo|gmx|icloud|me|hotmail|live|)\.(com|at|de|ch|co\.uk|rs|us)'
 CHECK(e_mail LIKE '%@%'),
 FOREIGN KEY (persnr) REFERENCES Person (persnr)
);


CREATE TABLE Mannschaft (		-- df: mult=1000.00
 bezeichnung VARCHAR(255) NOT NULL PRIMARY KEY,		-- df: pattern='Mannschaft#[:count:]'
 klasse VARCHAR(255) NOT NULL,		-- df: text=liga length=1
 naechstes_spiel DATE NOT NULL,		-- df: start=2016-01-01 end=2018-01-01
 kapitaen INT NOT NULL UNIQUE,		-- df: offset=10000 step=2 size=2200001
 anzahlSpieler INT NOT NULL CHECK (anzahlSpieler>10),	-- df: pattern='11'
 chefTrainer INT NOT NULL UNIQUE,		-- df: offset=2210000 step=2 size=200001
 trainerAssisten INT NOT NULL UNIQUE,		-- df: offset=2410000 step=2 size=200001

 UNIQUE (chefTrainer, trainerAssisten),	
 
 FOREIGN KEY (chefTrainer) REFERENCES Trainer (persnr),
 FOREIGN KEY (trainerAssisten) REFERENCES Trainer (persnr),
 FOREIGN KEY (kapitaen) REFERENCES Spieler (persnr)
);


CREATE TABLE Mitglied (		-- df: mult=1000.00
 persnr INT NOT NULL PRIMARY KEY,	-- df: offset=2810000 step=2 size=200001
 beitrag DECIMAL(10) NOT NULL,	--df: pattern='[0-9]{2,4}\.[0-9]{2}'

 FOREIGN KEY (persnr) REFERENCES Person (persnr)
);


CREATE TABLE Spiel (		-- df: mult=1000.00
 datum DATE NOT NULL PRIMARY KEY,	-- df: start=1900-01-01 end=2175-01-01
 mannschaft VARCHAR(255) NOT NULL UNIQUE,	-- df: pattern='Mannschaft#[:count:]'
 gegner VARCHAR(255) NOT NULL,		-- df: text=ort length=1
 ergebnis VARCHAR(13) NOT NULL,		-- df: pattern='[0-9]:[0-9]'

 FOREIGN KEY (mannschaft) REFERENCES Mannschaft (bezeichnung)
);


CREATE TABLE SpielerInMannschaft (		-- df: mult=11000.00
 persnr INT NOT NULL PRIMARY KEY,		-- df: offset=10000 step=2 size=2200001
 bezeichnung VARCHAR(255) NOT NULL,		-- df: pattern='Mannschaft#[:int size=50000:]'
 nummer INT NOT NULL CHECK (nummer>0 and nummer<100),		-- df: size=99

 UNIQUE(persnr, nummer),

 FOREIGN KEY (bezeichnung) REFERENCES Mannschaft (bezeichnung),
 FOREIGN KEY (persnr) REFERENCES Spieler (persnr)
);


CREATE TABLE BeteiligteSpieler (		-- df: mult=1000.00
 persnr INT NOT NULL PRIMARY KEY ,		-- df: offset=10000 step=2 size=2200001
 datum DATE NOT NULL UNIQUE,		-- df: start=1900-01-01 end=2175-01-01
 mannschaft VARCHAR(255) NOT NULL UNIQUE,		-- df: pattern='Mannschaft#[:count:]'
 dauer INT NOT NULL,		-- df: size=90

 FOREIGN KEY (persnr) REFERENCES Spieler (persnr),
 FOREIGN KEY (datum) REFERENCES Spiel (datum),
 FOREIGN KEY (mannschaft) REFERENCES Spiel (mannschaft)
);


CREATE TABLE FanClub (		-- df: mult=1000.00
 name VARCHAR(255) NOT NULL PRIMARY KEY,	-- df: pattern='Club#[:count:]'
 sid INT NOT NULL UNIQUE,				-- df: offset=1
 gegruendet DATE NOT NULL,		-- df: start=1916-01-01 end=2000-01-01
 obmann INT NOT NULL UNIQUE,	-- df: offset=2810000 step=2 size=200001

 FOREIGN KEY (sid) REFERENCES Standort (sid),
 FOREIGN KEY (obmann) REFERENCES Mitglied (persnr)
);


CREATE TABLE Zeitraum (		-- df: mult=1000.00
 persnr INT NOT NULL PRIMARY KEY,		-- df: offset=2610000 step=2 size=200001
 name VARCHAR(255) NOT NULL UNIQUE,		-- df: pattern='Club#[:count:]'
 sid INT NOT NULL UNIQUE,		-- df: offset=1
 anfang DATE NOT NULL,		-- df: start=1916-01-01 end=1960-01-01
 ende DATE NOT NULL,		-- df: start=1960-02-01 end=2016-01-01

 FOREIGN KEY (persnr) REFERENCES Angestellter (persnr),
 FOREIGN KEY (name) REFERENCES FanClub (name),
 FOREIGN KEY (sid) REFERENCES FanClub (sid)
);




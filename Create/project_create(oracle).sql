-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2018-04-11 10:42:41.357

-- tables
-- Table: Druzyna
CREATE TABLE Druzyna (
    idDruzyny integer  NOT NULL,
    nazwaPanstwa varchar2(30)  NOT NULL,
    Trener_idTrenerra integer  NOT NULL,
    Grupa_NazwaGrupy char(1)  NOT NULL,
    CONSTRAINT Druzyna_pk PRIMARY KEY (idDruzyny)
) ;

-- Table: Grupa
CREATE TABLE Grupa (
    NazwaGrupy char(1)  NOT NULL,
    CONSTRAINT Grupa_pk PRIMARY KEY (NazwaGrupy)
) ;

-- Table: Mecz
CREATE TABLE Mecz (
    idMecza integer  NOT NULL,
    idDruzyny1 integer  NOT NULL,
    idDruzyny2 integer  NOT NULL,
    data date  NOT NULL,
    Wynik_D1 smallint  NULL,
    Wynik_D2 smallint  NULL,
    Stadion_idStadionu integer  NOT NULL,
    CONSTRAINT Mecz_pk PRIMARY KEY (idMecza)
) ;

-- Table: Miasto
CREATE TABLE Miasto (
    idMiasta integer  NOT NULL,
    nazwaMiasta varchar2(30)  NOT NULL,
    CONSTRAINT Miasto_pk PRIMARY KEY (idMiasta)
) ;

-- Table: Pilkarz
CREATE TABLE Pilkarz (
    idPilkarz integer  NOT NULL,
    imie varchar2(30)  NOT NULL,
    nazwisko varchar2(30)  NOT NULL,
    numer integer  NOT NULL,
    Druzyna_idDruzyny integer  NOT NULL,
    CONSTRAINT Pilkarz_pk PRIMARY KEY (idPilkarz)
) ;

-- Table: RolaPikarza
CREATE TABLE RolaPikarza (
    Pilkarz_idPilkarz integer  NOT NULL,
    Mecz_idMecza integer  NOT NULL,
    rolePilkarza varchar2(30)  NULL,
    CONSTRAINT RolaPikarza_pk PRIMARY KEY (Pilkarz_idPilkarz,Mecz_idMecza)
) ;

-- Table: Sedzia
CREATE TABLE Sedzia (
    idSedzi integer  NOT NULL,
    imieSedzi varchar2(30)  NOT NULL,
    nazwiskoSedzi varchar2(30)  NOT NULL,
    CONSTRAINT Sedzia_pk PRIMARY KEY (idSedzi)
) ;

-- Table: Sedziowanie
CREATE TABLE Sedziowanie (
    Mecz_idMecza integer  NOT NULL,
    Sedzia_idSedzi integer  NOT NULL,
    funkcja varchar2(45)  NOT NULL,
    CONSTRAINT Sedziowanie_pk PRIMARY KEY (Mecz_idMecza,Sedzia_idSedzi)
) ;

-- Table: Stadion
CREATE TABLE Stadion (
    idStadionu integer  NOT NULL,
    NazwaStadionu varchar2(30)  NOT NULL,
    Miasto_idMiasta integer  NOT NULL,
    CONSTRAINT Stadion_pk PRIMARY KEY (idStadionu)
) ;

-- Table: Trener
CREATE TABLE Trener (
    idTrenerra integer  NOT NULL,
    imieTrenera varchar2(30)  NOT NULL,
    nazwiskoTrenera varchar2(30)  NOT NULL,
    CONSTRAINT Trener_pk PRIMARY KEY (idTrenerra)
) ;

-- foreign keys
-- Reference: Druzyna_Grupa (table: Druzyna)
ALTER TABLE Druzyna ADD CONSTRAINT Druzyna_Grupa
    FOREIGN KEY (Grupa_NazwaGrupy)
    REFERENCES Grupa (NazwaGrupy);

-- Reference: Druzyna_Trener (table: Druzyna)
ALTER TABLE Druzyna ADD CONSTRAINT Druzyna_Trener
    FOREIGN KEY (Trener_idTrenerra)
    REFERENCES Trener (idTrenerra);

-- Reference: ListaZdarzen_Mecz (table: RolaPikarza)
ALTER TABLE RolaPikarza ADD CONSTRAINT ListaZdarzen_Mecz
    FOREIGN KEY (Mecz_idMecza)
    REFERENCES Mecz (idMecza);

-- Reference: ListaZdarzen_Pilkarz (table: RolaPikarza)
ALTER TABLE RolaPikarza ADD CONSTRAINT ListaZdarzen_Pilkarz
    FOREIGN KEY (Pilkarz_idPilkarz)
    REFERENCES Pilkarz (idPilkarz);

-- Reference: Mecz_Stadion (table: Mecz)
ALTER TABLE Mecz ADD CONSTRAINT Mecz_Stadion
    FOREIGN KEY (Stadion_idStadionu)
    REFERENCES Stadion (idStadionu);

-- Reference: Pilkarz_Druzyna (table: Pilkarz)
ALTER TABLE Pilkarz ADD CONSTRAINT Pilkarz_Druzyna
    FOREIGN KEY (Druzyna_idDruzyny)
    REFERENCES Druzyna (idDruzyny);

-- Reference: Sedziowanie_Mecz (table: Sedziowanie)
ALTER TABLE Sedziowanie ADD CONSTRAINT Sedziowanie_Mecz
    FOREIGN KEY (Mecz_idMecza)
    REFERENCES Mecz (idMecza);

-- Reference: Sedziowanie_Sedzia (table: Sedziowanie)
ALTER TABLE Sedziowanie ADD CONSTRAINT Sedziowanie_Sedzia
    FOREIGN KEY (Sedzia_idSedzi)
    REFERENCES Sedzia (idSedzi);

-- Reference: Spotkanie_Druzyna1 (table: Mecz)
ALTER TABLE Mecz ADD CONSTRAINT Spotkanie_Druzyna1
    FOREIGN KEY (idDruzyny1)
    REFERENCES Druzyna (idDruzyny);

-- Reference: Spotkanie_Druzyna2 (table: Mecz)
ALTER TABLE Mecz ADD CONSTRAINT Spotkanie_Druzyna2
    FOREIGN KEY (idDruzyny2)
    REFERENCES Druzyna (idDruzyny);

-- Reference: Stadion_Miasto (table: Stadion)
ALTER TABLE Stadion ADD CONSTRAINT Stadion_Miasto
    FOREIGN KEY (Miasto_idMiasta)
    REFERENCES Miasto (idMiasta);

-- End of file.


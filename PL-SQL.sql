set serveroutput on;

--Procedury


--I. Napisać procedurę, która zwróci ilość meczy zegranych przez drużynę, której nazwa jest podana jako parametr

Create or replace procedure countMeczy
(v_druzyna Varchar2, v_ile out Number)
As
v_idDruzyny Druzyna.idDruzyny%type;
Begin
Select idDruzyny into v_idDruzyny from Druzyna where Nazwapanstwa = v_druzyna;
Select Count(1) Into v_ile From mecz Where idDruzyny1 = v_idDruzyny or idDruzyny2 = v_idDruzyny;
Exception
When no_data_found then 
     DBMS_OUTPUT.put_line('Brak panstwa o nazwie ' || v_druzyna);
End;

--Test
Declare
v_nazwaPanstwa Varchar2(50) := 'Portugalia';
v_ile Number;
Begin
countMeczy(v_nazwaPanstwa, v_ile);
if v_ile is not null then
   DBMS_OUTPUT.put_line(v_nazwaPanstwa || ' rozegrala ' || v_ile || ' meczy');
end if;
End;

select * from mecz;
select * from druzyna;


--II. Napisać procedurę, która wypisze wszystkich piłkarzy w postaci "Imie Nazwisko Numer Druzyna", których numer podajemy w parametrach procedury

Create or replace Procedure ShowByNumber
(v_numer Pilkarz.Numer%type)
As
Cursor Pilkarz_Num is Select Imie, Nazwisko, Numer, Nazwapanstwa  From Pilkarz p Join Druzyna d on p.Druzyna_idDruzyny = d.IDDRUZYNY Where Numer = v_numer; 
v_ile Number := 0;
Begin
For pilkarz in Pilkarz_Num 
    Loop
    DBMS_OUTPUT.put_line(pilkarz.Imie || ' ' || pilkarz.Nazwisko || ' ' || pilkarz.Numer || ' ' || pilkarz.Nazwapanstwa);
    v_ile := v_ile + 1;
    End loop;
if v_ile = 0 then
   DBMS_OUTPUT.put_line('Nie ma pilkarzy o numerze ' || v_numer);
end if;   
End;

--Test
Declare 
v_num Pilkarz.Numer%type := 1;
Begin
ShowByNumber(v_num);
End;


--Wyzwalacze


--I. Wyzwalacz, który nie dopuści do usunięcia danych z tabeli stadion

Create or replace trigger NoDelStadion
before Delete
on stadion 
Begin
raise_application_error(-20325, 'Nie mozna usuwac stadionu!');
End;

--Test
Delete From stadion;
 
 
--II.Wyzwalacz, który nie dopuści do modyfikacji stadionu w meczu w którym jedna z druzyn jest Hiszpania

Create or replace trigger NoUpdateStadion
before update
on mecz
for each row
Declare
v_info Varchar2(100) := ' ';
v_idSpain Druzyna.idDruzyny%type;       
Begin
if :new.stadion_idstadionu != :old.stadion_idstadionu then
   Select idDruzyny into v_idSpain from Druzyna where Nazwapanstwa = 'Hispania';
   if :new.idDruzyny1 = v_idSpain or :new.idDruzyny2 = v_idSpain then
      :new.stadion_idstadionu := :old.stadion_idstadionu;
      v_info := 'Nie modyfikujemy stadionu w meczu, wktorym gra Hiszpania!';
   end if;
else 
   v_info := 'Zmiany zostaly wprowadzone';
end if;
dbms_output.put_line(v_info);
End;

--Test
Update mecz set Stadion_idStadionu = 5 where idmecza = 3;
select * from mecz;
rollback;

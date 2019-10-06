--Procedury


--I. Procedura służąca do wstawiania nowego piłkarza (imie, nazwisko i numer należy podać w parametrach) do drużyny, której nazwa również jest podana jako parametr

Create Procedure AddPilkarz
@Imie varchar(30), @Nazwisko varchar(30), @Numer int, @Nazwa_druzyny varchar(30)
As
Begin
Declare @idPanstwa int;
Select @idPanstwa = idDruzyny From Druzyna Where nazwaPanstwa = @Nazwa_druzyny;
if @idPanstwa is null
	Raiserror('Druzyna o podanej nazwie nie istnieje!',1,2);
else
	Insert Into Pilkarz
	Values ((Select IsNull(Max(idPilkarz), 0) + 1 From Pilkarz), @Imie, @Nazwisko, @Numer, @idPanstwa);
End;


--II. Procedura, która wypisuje wynik wszystkich meczy w postaci : "<Druzyna1> pokonała <Druzyna2> z rachunkiem <wynik1> : <wynik2> w meczu <data meczu> na stadionie <nazwa Stadionu>".
--W przypadku, gdy mecz jest remisowy : "Mecz <data meczu> pomiędzy <Druzyna1> a <Druzyna2> na stadionie <nazwa stadionu> jest remisowy z rachunkiem <wynik1> : <wynik2>". 
Go

Create Procedure ShowMeczInfo
As
Begin
Declare MeczInfo Cursor for Select M.idDruzyny1, M.idDruzyny2, M.data, M.Wynik_D1, M.Wynik_D2, M.Stadion_idStadionu 
                            From Mecz M;
Declare @ID1 int, @ID2 int, @Data_Meczu Date, @Wynik1 int, @Wynik2 int, @StadionID int, 
        @Druzyna1 Varchar(30), @Druzyna2 Varchar(30), @Stadion Varchar(30), @info Varchar(200);

Open MeczInfo;
Fetch Next From MeczInfo into @ID1, @ID2, @Data_Meczu, @Wynik1, @Wynik2, @StadionID;
While @@FETCH_STATUS = 0 
Begin
	 Select @Stadion = NazwaStadionu From Stadion Where idStadionu = @StadionID;

     if @Wynik1 > @Wynik2
	 begin
	      Select @Druzyna1 = nazwaPanstwa From Druzyna Where idDruzyny = @ID1;
		  Select @Druzyna2 = nazwaPanstwa From Druzyna Where idDruzyny = @ID2;
		  Set @info = @Druzyna1 + ' pokonala ' + @Druzyna2 + ' w meczu ' + CAST(@Data_Meczu as varchar) + ' z rachunkiem ' + 
		  CAST(@Wynik1 as varchar) + ' : ' + CAST(@Wynik2 as varchar) + ' na stadionie ' + @Stadion;

	 end;

	 else if @Wynik1 < @Wynik2
	 begin 
	      Select @Druzyna1 = nazwaPanstwa From Druzyna Where idDruzyny = @ID2;
		  Select @Druzyna2 = nazwaPanstwa From Druzyna Where idDruzyny = @ID1;
		  Set @info = @Druzyna1 + ' pokonala ' + @Druzyna2 + ' w meczu ' + CAST(@Data_Meczu as varchar) + ' z rachunkiem ' + 
		  CAST(@Wynik2 as varchar) + ' : ' + CAST(@Wynik1 as varchar) + ' na stadionie ' + @Stadion;
	 end;

	 else
	 begin
	      Select @Druzyna1 = nazwaPanstwa From Druzyna Where idDruzyny = @ID1;
		  Select @Druzyna2 = nazwaPanstwa From Druzyna Where idDruzyny = @ID2;
		  Set @info = 'Mecz ' + CAST(@Data_Meczu as varchar) + ' pomiedzy ' + @Druzyna1 + ' a ' + @Druzyna2 + ' na stadionie ' + 
		  @Stadion + ' jest remisowy z rachunkiem ' + CAST(@Wynik1 as varchar) + ' : ' + CAST(@Wynik2 as varchar);
	 end;

	 Print @info;
	 Fetch Next From MeczInfo into @ID1, @ID2, @Data_Meczu, @Wynik1, @Wynik2, @StadionID;
End;
		  
Close MeczInfo;
Deallocate MeczInfo;

End;


--Wyzwalacze


--I. Wyzwalacz, który nie dopuści wstawić piłkarza do drużyny jeżeli w niej już istnieje piłkarz o takim numerze
Go

Create Trigger pilkarz_num
On Pilkarz For insert
As
Begin
Declare @NazwaDruzyny Varchar(30), @idPanstwa Int, @ile Int, @info Varchar(100);

Select @idPanstwa = Druzyna_idDruzyny From inserted;
Select @NazwaDruzyny = nazwaPanstwa  From Druzyna Where idDruzyny = @idPanstwa;
Select @ile = count(1) From Pilkarz Where Druzyna_idDruzyny = @idPanstwa AND Numer = (Select Numer From Inserted);

if @ile > 1 
  Begin
   Set @info = 'W druzynie ' + @NazwaDruzyny + ' juz istnieje pilkarz o takim numerze';
   Rollback;
  End;
else
   Set @info = 'Pilkarz zostal dodany do druzyny ' +  @NazwaDruzyny;

Print @info;
End;


--II. Wyzwalacz, który nie pozwala modyfikować dane w meczu, który już odbył
Go

Create Trigger upd_Mecz
On Mecz For update
As
Begin
Declare @CurrentDate date, @MeczDate date, @info varchar(100);
Set @CurrentDate = CONVERT(datetimeoffset, GETDATE());
Select @MeczDate = data From deleted;

if @CurrentDate > @MeczDate
begin
	Set @info = 'Nie zmieniamy danych meczu, ktory juz odbyl';
	rollback;
end;
else
	Set @info = 'Dane zostaly zaktualizowane';
Print @info;
End;
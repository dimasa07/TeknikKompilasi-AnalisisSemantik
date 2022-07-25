program Input_1;

function PI:real;
begin
	 PI := 3.14; // return fungsi
end;

function tambah(x:integer; y:integer):integer;
var
	hasil : integer;
begin
	 hasil := x+y;
	 // warning, return fungsi tidak terdeteksi (Name Related Check)
end;

var
	a : string;
	b : string;
	k : integer;
	
begin
	k := a * k; // error, perkalian pada string (Type Check)
end.
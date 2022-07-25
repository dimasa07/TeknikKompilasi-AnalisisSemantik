program Input_2;

var 
	a, b, c : integer;	
	a : integer; // error, duplikat variable (Uniqueness Check)
	
begin
	a := 1;
	b := 5;
	c := 0;
	
	// Flow of Control Check
	break; // error, kata kunci ini harus disimpan pada perulangan
	
	while a < b do
	begin
		 c := c+a;
		 
		 if a = 3 then
			break;
		 
		 a := a+1;
		 
	end;
end.
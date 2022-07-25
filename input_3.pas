program Input_3;

var 
	a : real;
	b : integer;
	c : string;
	d : integer;
	
begin
	 a := a*b;	 
	 b := a*b; // error, real to integer (Conversion Check)
	 c := 'teks';
	 b := Integer(c); // error, paksa string ke integer (Coercion Check) 
end.
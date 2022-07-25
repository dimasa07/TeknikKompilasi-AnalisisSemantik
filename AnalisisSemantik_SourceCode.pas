program AnalisisSemantik;

uses
    crt, sysutils;

const
     keterangan_true = 'Terdeteksi';
     keterangan_false = 'Tidak Terdeteksi';
     simbols = [':','+','<','>','=','-','*','/',';'];
     blanks = [' ',#9,#10,'.',',','(',')','[',']',#39,#34];
     jumlah_konstant = 7;
     jumlah_keyword = 26;
     konstants : array[1..jumlah_konstant] of string = (
               'STRING','INTEGER','BOOLEAN','CHAR','BYTE','REAL','FILE'
               );
     keywords : array[1..jumlah_keyword] of string = (
              'PROGRAM','VAR','BEGIN','END','IF','NOT','ELSE','THEN',
              'FOR','TO','DO','PROCEDURE','FUNCTION','ARRAY','TYPE',
              'CONST','USES','OR','AND','NIL','TRY','EXCEPT','BREAK',
              'WHILE','REPEAT','UNTIL');


type
    Tpointer = ^Ttoken;
    Ttoken = record
                   prev : Tpointer;
                   token : String;
                   tipe : String;
                   var_tipe : string;
                   next : Tpointer;
             end;

var
   file_input : file of char;
   pilihan : string;
   tokens, tokensTail: Tpointer;

// Fungsi Pilih Menu
function pilih_menu:string;
var
   menu : string;
begin
     clrscr;
     // Banner
     writeln('        Aplikasi Analisis Semantik          ' );
     writeln('       Tugas Besar Teknik Kompilasi         ' );
     writeln('=============================================');
     writeln;

     // Tim
     writeln('- Dimas Agung  - 10119306');
     writeln('- Ihsan Taofik - 10119315');
     writeln;
     writeln('=============================================');
     writeln;

     // Menu
     writeln('1. Analisis Semantik input_1.pas');
     writeln('2. Analisis Semantik input_2.pas');
     writeln('3. Analisis Semantik input_3.pas');
     writeln('4. Tutup aplikasi');
     writeln('---------------------------------------------');
     write('Pilih menu [1, 2, 3, 4] : ');
     readln(menu);

     pilih_menu := menu;
end;

// Fungsi getByToken
function getByToken(token : string):Tpointer;
var
   temp, hasil : Tpointer;
begin
     temp := tokens;
     hasil := nil;
     while temp <> nil do
     begin
          if temp^.token = token then
          begin
               hasil :=temp;
               break;
          end;
          temp := temp^.next;
     end;

     getByToken := hasil;
end;

// Fungsi getextTipe
function getNextTipe(link : Tpointer):Tpointer;
var
   temp, hasil : Tpointer;
begin
     hasil := link;
     temp := link;
     while temp <> nil do
     begin
          if temp^.tipe = 'KONSTANTA' then
          begin
               hasil := temp;
               break;
          end;
          temp := temp^.next;
     end;

     getNextTipe := hasil;
end;

// Fungsi Cari Tipe Token
function cari_tipe(const token : string):string;
var
   i : integer;
   tipe : string;
begin
     tipe := '';
     for i:= 1 to jumlah_keyword do
         if upcase(token) = keywords[i] then
         begin
              tipe := 'KEYWORD';
              break;
         end;

     for i:= 1 to jumlah_konstant do
         if upcase(token) = konstants[i] then
         begin
              tipe := 'KONSTANTA';
              break;
         end;

     if token[1] in simbols then
        tipe := 'OPERATOR';
     if token[1] in blanks then
        tipe := 'DELIMITER';

     cari_tipe := tipe;
end;

// Prosedur Tambah Token
procedure tambah_token(var tokens : Tpointer; token : string);
var
   baru : Tpointer;
   temp: Tpointer;
   exist : boolean;
begin
     exist := false;
     temp := tokens;

     while temp <> nil do
     begin
          if (token = temp^.token)and(token[1] in blanks) then
          begin
               exist := true;
               break;
          end;
          temp := temp^.next;
     end;

     if not exist then
     begin
     // Membuat node baru
     new(baru);

     // Mengisi data node
     baru^.prev := nil;
     baru^.token := token;
     baru^.next := nil;

     // Menambah node ke list token
     if tokens = nil then
     begin
          tokensTail := baru;
          tokens := tokensTail;
     end
     else
     begin
          baru^.prev := tokensTail;
          baru^.next := nil;
          tokensTail^.next := baru;
          tokensTail := baru;
     end;
     end;
end;

// Prosedur Isi Tipe Token
procedure isi_tipe(var tokens :Tpointer);
var
   temp : Tpointer;
   key : string;
   tipe : string;
begin
     key := '';
     tipe := '';
     temp := tokens;
     while temp <> nil do
     begin
          tipe := cari_tipe(temp^.token);
          if tipe = 'KEYWORD' then
          begin
               if (upcase(temp^.token)='VAR') or (upcase(temp^.token)='PROGRAM') then
                  key := 'VAR'
               else key := '';
          end;
          if (key = 'VAR') and(tipe = '') then
          begin
               tipe := 'VAR';
          end;
          if tipe = '' then
             tipe := 'KONSTANTA';
          temp^.tipe := tipe;

          temp := temp^.next;
     end;
end;

// Fungsi isi_tipe_var
procedure isi_tipe_var(var tokens : Tpointer);
var
   temp : Tpointer;
begin
     temp := tokens;
     while temp <> nil do
     begin
          if temp^.tipe ='VAR' then
             temp^.var_tipe := getNextTipe(temp)^.token;
          temp := temp^.next;
     end;

     temp := tokens;
     while temp <> nil do
     begin
          if temp^.tipe ='KONSTANTA' then
             if getByToken(temp^.token) <> nil then
                temp^.var_tipe := getByToken(temp^.token)^.var_tipe;
          temp := temp^.next;
     end;
end;

// Fungsi Scan Character
function scan_char(c : char):boolean;
begin
     if (upcase(c) in blanks)  then
        scan_char := true
     else if upcase(c) in simbols then
          scan_char := true
     else
         scan_char := false;
end;

procedure print_table(tokens: Tpointer);
var
   i,j,y : integer;
   nKw,nVar,nKons,nOp,nDel,nMax: integer;
   temp : Tpointer;
begin
     textcolor(white);
     writeln;
     writeln;
     writeln;
     writeln('Tabel output Token List :');
     textcolor(yellow);

     y := wherey;

     // Print isi tabel
     nKw := 0;
     nVar := 0;
     nKons := 0;
     nOp := 0;
     nDel := 0;
     temp := tokens;

     while temp <> nil do
     begin
          if temp^.tipe = 'KEYWORD' then
          begin
               gotoxy(2, 4+y+nKw);write(temp^.token);
               nKw := nKw + 1;
          end
          else if temp^.tipe = 'VAR' then
          begin
               gotoxy(16, 4+y+nVar);write(temp^.token, '(',temp^.var_tipe,')');
               nVar := nVar + 1;
          end
          else if temp^.tipe = 'KONSTANTA' then
          begin
               gotoxy(37, 4+y+nKons);write(temp^.token);
               nKons := nKons + 1;
          end
          else if temp^.tipe = 'OPERATOR' then
          begin
               gotoxy(58, 4+y+nOp);write(temp^.token);
               nOp := nOp + 1;
          end
          else if temp^.tipe = 'DELIMITER' then
          begin
               gotoxy(69, 4+y+nDel);
               if temp^.token[1] = ' ' then
                  write('SPASI')
               else if temp^.token[1] = #9 then
                    write('TAB')
               else if temp^.token[1] = #13 then
                    write('ENTER')
               else if temp^.token[1] = #10 then
                    write('ENTER')
               else
                   write(temp^.token);
               nDel := nDel + 1;
          end;
          temp := temp^.next;
     end;

     // Print tabel
     gotoxy(4,2+y);write('Keywords');
     gotoxy(22,2+y);write('Variable');
     gotoxy(43,2+y);write('Konstants');
     gotoxy(59,2+y);write('Operator');
     gotoxy(70,2+y);write('Delimiter');
     nMax := 0;
     if nKw > nVar then nMax := nKw else nMax := nVar;
     if nKons > nMax then nMax := nKons;
     if nOp > nMax then nMax := nOp;
     if nDel > nMax then nMax := nDel;
     for i:=(1+y) to (nMax+4+y) do
         for j:=1 to 80 do
             if (j=1)or(j=15)or(j=36)or(j=57)or(j=68)or(j=80)then
             begin
                  gotoxy(j,i);
                  if (i=1+y)and(j=1)then write(#218)
                  else if(i=1+y)and(j=80)then write(#191)
                  else if(i=3+y)and(j=1)then write(#195)
                  else if(i=nMax+4+y)and(j=1)then write(#192)
                  else if (i=1+y) then write(#194)
                  else if(i=3+y)and(j=80)then write(#180)
                  else if (i=3+y) then write(#197)
                  else if(i=nMax+4+y)and(j<>80)then write(#193)
                  else if(i=nMax+4+y)and(j=80)then write(#217)
                  else write(#179);
             end
             else
             begin
                  gotoxy(j,i);
                  if (i=1+y)or(i=3+y)or(i=nMax+4+y) then write(#196);
             end;
end;

// Prosedur Scan Source Code
procedure scan_source_code(var file_input : file of char);
var
   c : char;
   temp : string;
begin
     temp := '';
     while not eof(file_input) do
     begin
          read(file_input, c);
          if(c = #9) then write('    ')
          else write(c);

          // Proses Analisis Leksikal
          if scan_char(c) then
          begin
               if (temp <> '') and (temp <> #13) then
                  tambah_token(tokens, temp);
               tambah_token(tokens, c);
               temp := ''
          end
          else
              if c <> #13 then
                 temp := temp + c;
      end;
      isi_tipe(tokens);
      isi_tipe_var(tokens);
      print_table(tokens);
end;

// Fungsi Flow of Control Checking
function flow_of_control_check:string;
const
     jumlah_key = 3;
     keys : array[1..jumlah_key] of string = ('REPEAT','FOR','WHILE');
var
   hasil : string;
   temp : Tpointer;
   is_loop : boolean;
   i, jumlah_begin : integer;

begin
     hasil := keterangan_false;
     temp := tokens;
     is_loop := false;
     jumlah_begin := 0;
     while temp <> nil do
     begin
          if temp^.tipe = 'KEYWORD' then
          begin
               for i := 1 to jumlah_key do
                   if upcase(temp^.token) = keys[i] then
                      is_loop := true;

               if is_loop then
               begin
                    if upcase(temp^.token) = 'BEGIN' then
                       jumlah_begin := jumlah_begin+1;
                    if upcase(temp^.token) = 'END' then
                    begin
                         jumlah_begin := jumlah_begin-1;
                         if jumlah_begin = 0 then is_loop := false;
                    end;
               end;

               if upcase(temp^.token)='BREAK' then
                  if is_loop then
                     hasil := keterangan_false
                  else
                  begin
                       hasil := keterangan_true;
                       break;
                  end;

          end;
          temp := temp^.next;
     end;
     flow_of_control_check := hasil;
end;

// Fungsi Uniqueness Checking
function uniqueness_check:string;
var
   temp, temp1 : Tpointer;
   hasil : integer;
begin
     hasil := 0;
     temp := tokens;
     while temp <> nil do
     begin
          if temp^.tipe = 'VAR' then
          begin
               temp1 := tokens;
               if hasil > 1 then break;
                  hasil := 0;
               while temp1 <> nil do
               begin
                    if (temp^.token = temp1^.token)and(temp1^.tipe='VAR') then
                    begin
                         hasil := hasil+1;
                         if hasil = 2 then break;
                    end;
                    temp1 := temp1^.next;
               end;
          end;
          temp := temp^.next;
     end;
     if hasil > 1 then uniqueness_check := keterangan_true
     else uniqueness_check := keterangan_false;
end;

// Fungsi Name Related Checking
function name_related_check:string;
begin

     name_related_check := keterangan_false;
end;

// Fungsi Type Checking
function type_check:string;
const
     math_simbols = ['/','*','-'];
var
   temp : Tpointer;
   hasil : string;
begin
     temp := tokens;
     hasil := keterangan_false;
     while temp <> nil do
     begin
          if temp^.token[1] in math_simbols then
          begin
               if (lowercase(temp^.prev^.var_tipe) = 'string')or
               (lowercase(temp^.next^.var_tipe) = 'string') then
                  hasil := keterangan_true;
          end;
          temp := temp^.next;
     end;
     type_check := hasil;
end;

// Fungsi Type Conversion Checking
function type_conversion:string;
begin

     type_conversion := keterangan_false;
end;

// Fungsi Type Coercion Checking
function type_coercion:string;
begin

     type_coercion := keterangan_false;
end;

// Prosedur Baca File
procedure baca_file(nama_file:string);
var
   y,i,j : integer;
begin
     clrscr;
     try
        // Membaca file input
        assign(file_input, nama_file);

        // Scan file
        reset(file_input);
        scan_source_code(file_input);

        // Print isi file
        reset(file_input);
        {while not eof(file_input) do
        begin
             read(file_input, c);
             if(c = #9) then write('    ')
             else write(c);
        end;}

        writeln;
        writeln;
        writeln;

        // Close file
        close(file_input);

        // Print tabel //
        write('Tabel Output Analisis Semantik');
        y := wherey;
        gotoxy(13,2+y);write('Tipe Kesalahan');
        gotoxy(56,2+y);write('Keterangan');
        // Tipe Kesalahan
        gotoxy(3,4+y);write('Flow of Control Check');
        gotoxy(3,5+y);write('Uniqueness Check');
        gotoxy(3,6+y);write('Name Related Check');
        gotoxy(3,7+y);write('Type Check');
        gotoxy(3,8+y);write('Type Conversion');
        gotoxy(3,9+y);write('Type Coercion');
        // Keterangan
        gotoxy(42,4+y);write(flow_of_control_check);
        gotoxy(42,5+y);write(uniqueness_check);
        gotoxy(42,6+y);write(name_related_check);
        gotoxy(42,7+y);write(type_check);
        gotoxy(42,8+y);write(type_conversion);
        gotoxy(42,9+y);write(type_coercion);

        for i:=(1+y) to (10+y) do
            for j:=1 to 80 do
                if (j=1)or(j=40)or(j=80)then
                begin
                     gotoxy(j,i);
                     if (i=1+y)and(j=1)then write(#218)
                     else if(i=1+y)and(j=80)then write(#191)
                     else if(i=3+y)and(j=1)then write(#195)
                     else if(i=10+y)and(j=1)then write(#192)
                     else if (i=1+y) then write(#194)
                     else if(i=3+y)and(j=80)then write(#180)
                     else if (i=3+y) then write(#197)
                     else if(i=10+y)and(j<>80)then write(#193)
                     else if(i=10+y)and(j=80)then write(#217)
                     else write(#179);
                end
                else
                begin
                     gotoxy(j,i);
                     if (i=1+y)or(i=3+y)or(i=10+y) then write(#196);
                end;

        // Akhir print Tabel //


        // Error handling
        except
              on E : EInOutError do
              begin
                   writeln('File ',nama_file,' tidak terbaca.');
                   writeln('Pastikan file tersebut disimpan satu folder dengan aplikasi ini.');
              end;
     end; // End Try block //

     writeln;
     write('Tekan ENTER untuk kembali ke menu ');
     readln;
end;


begin
     // Mengganti tema
     textbackground(green);
     clrscr;
     textcolor(white);

     repeat
           pilihan := pilih_menu;
           tokens := nil;
           if pilihan = '1' then
              baca_file('input_1.pas')
           else if pilihan= '2' then
                baca_file('input_2.pas')
           else if pilihan = '3' then
                baca_file('input_3.pas');

     until pilihan = '4';

end.


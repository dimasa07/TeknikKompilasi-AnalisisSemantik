program AnalisisSemantik;

uses
    crt, sysutils;

const
     keterangan_true = 'Terdeteksi';
     keterangan_false = 'Tidak Terdeteksi';
     simbols = [':','+','<','>','=','-','*','/'];
     blanks = [' ',#9,#10,';','.',',','(',')','[',']',#39,#34];
     jumlah_konstant = 7;
     jumlah_keyword = 22;
     konstants : array[1..jumlah_konstant] of string = (
               'STRING','INTEGER','BOOLEAN','CHAR','BYTE','REAL','FILE'
               );
     keywords : array[1..jumlah_keyword] of string = (
              'PROGRAM','VAR','BEGIN','END','IF','NOT','ELSE','THEN',
              'FOR','TO','DO','PROCEDURE','FUNCTION','ARRAY','TYPE',
              'CONST','USES','OR','AND','NIL','TRY','EXCEPT');


type
    Tpointer = ^Ttoken;
    Ttoken = record
                  token : String;
                  tipe : String;
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

// Prosedur Scan Variables
procedure scan_variables(var file_input : file of char);
const
     blank = [' ',#9, #10, #13];
     keys : array[1..2] of string = ('asd','asa');
var
   key : string;
   c : char;
   nama_variable, tipe_data, tmp : string;
begin
     key := '';
     tmp := '';
     while not eof(file_input) do
     begin
          read(file_input, c);
          if (key = 'var') then
          begin
               if not(c in blank) then
               begin

               end;
          end
          else
          begin
               if (c = 'v')and(key='') then key := 'v'
               else if (c = 'a')and(key='v') then key := 'va'
               else if (c = 'r')and(key='va') then key := 'var'
               else key := '';
          end;
     end;
end;

// Fungsi Cari Tipe Token
function cari_tipe(const token : string):string;
var
   i : integer;
   tipe : string;
begin
     tipe := '';
     for i:= 1 to jumlah_keyword do
     begin
          if upcase(token) = keywords[i] then
          begin
               tipe := 'KEYWORD';
               break;
          end;
     end;
     for i:= 1 to jumlah_konstant do
     begin
          if upcase(token) = konstants[i] then
          begin
               tipe := 'KONSTANTA';
               break;
          end;
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
     {
     if temp <> nil then
     begin
          repeat
                if token = temp^.token then
                begin
                     exist := true;
                     break;
                end;
                temp := temp^.next;
          until temp = nil;
     end;}

     if not exist then
     begin
     // Membuat node baru
     new(baru);

     // Mengisi data node
     baru^.token := token;
     baru^.next := nil;

     // Menambah node ke list token
     if tokens = nil then
        begin
             tokens := baru;
             tokensTail := baru;
        end
     else
         begin
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
   tipe, lastKeyword : string;
begin
     key := '';
     lastKeyword := '';
     tipe := '';
     temp := tokens;
     if temp <> nil then
     begin
          repeat
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
               if (temp^.token[1] in simbols) and (temp^.next^.token[1] in simbols) then
               begin
                    temp^.token := temp^.token + temp^.next^.token;
                    if(temp^.next^.next <> nil) then
                    temp^.next := temp^.next^.next
                    else
                    temp^.next := nil;
               end;

               temp^.tipe := tipe;
               temp := temp^.next;
          until temp = nil;
     end;
end;

// Fungsi Scan Character
function scan_char(c : char):boolean;
begin
     if (upcase(c) in blanks)  then
     begin
          tambah_token(tokens, c);
          scan_char := true;
     end
     else if upcase(c) in simbols then
     begin
          tambah_token(tokens, c);
          scan_char := true
     end
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
     if temp <> nil then
     begin
          repeat
                if temp^.tipe = 'KEYWORD' then
                begin
                     gotoxy(2, 4+y+nKw);write(temp^.token);
                     nKw := nKw + 1;
                end
                else if temp^.tipe = 'VAR' then
                begin
                     gotoxy(16, 4+y+nVar);write(temp^.token);
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
          until temp = nil;

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
     begin
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
end;

// Prosedur Scan Source Code
procedure scan_source_code(var file_input : file of char);
var
   c, prevChar : char;
   temp : string;
begin
     temp := '';
     prevChar := '0';
     while not eof(file_input) do
        begin
             read(file_input, c);
             if(c = #9) then
             write('    ')
             else
             write(c);

             // Proses Analisis Leksikal
             if (prevChar in simbols) and (c in simbols) then
             begin
                  tambah_token(tokens, c);
                  prevChar := '0';
             end
             else if scan_char(c) then
                begin
                     if (temp <> '') and (temp <> #13) then
                     begin
                          tambah_token(tokens, temp);
                     end;
                     temp := ''
                end
             else
                 begin
                      if c <> #13 then
                      temp := temp + c;
                 end;
             prevChar := c;
        end;
        isi_tipe(tokens);
        print_table(tokens);
end;

// Fungsi Flow of Control Checking
function flow_of_control_check:string;
begin

     flow_of_control_check := keterangan_false;
end;

// Fungsi Uniqueness Checking
function uniqueness_check:string;
begin

     uniqueness_check := keterangan_false;
end;

// Fungsi Name Related Checking
function name_related_check:string;
begin

     name_related_check := keterangan_false;
end;

// Fungsi Type Checking
function type_check:string;
begin

     type_check := keterangan_false;
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
   c : char;
   y,i,j : integer;
begin
     clrscr;
     try
        // Membaca file input
        assign(file_input, nama_file);

        // Scan file
        reset(file_input);
        scan_source_code(file_input);
        {
        // Print isi file
        reset(file_input);
        while not eof(file_input) do
        begin
             read(file_input, c);
             if(c = #9) then write('    ')
             else write(c);
        end;
        }
        writeln;
        writeln;
        writeln;

        // Close file
        close(file_input);
        {
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
        begin
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
        end;
        // Akhir print Tabel //
        }

        // Error handling
        except
              on E : EInOutError do
              begin
                   writeln('File ',nama_file,' tidak terbaca.');
                   writeln('Pastikan file tersebut disimpan satu folder dengan aplikasi ini.');
              end;
     end;
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


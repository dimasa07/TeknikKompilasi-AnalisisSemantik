program AnalisisSemantik;

uses
    crt, sysutils;

const
     keterangan_true = 'Terdeteksi';
     keterangan_false = 'Tidak Terdeteksi';

type
    T_variables_pointer = ^T_variables;
    T_variables = record
                        nama_variable : string;
                        tipe_data : string;
                  end;

var
   file_input : file of char;
   pilihan : string;

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

// Prosedur Scan Source Code
procedure scan_source_code(var file_input : file of char);
begin
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

        // Print isi file
        reset(file_input);
        while not eof(file_input) do
        begin
             read(file_input, c);
             if(c = #9) then write('    ')
             else write(c);
        end;

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

           if pilihan = '1' then
              baca_file('input_1.pas')
           else if pilihan= '2' then
                baca_file('input_2.pas')
           else if pilihan = '3' then
                baca_file('input_3.pas');

     until pilihan = '4';

end.


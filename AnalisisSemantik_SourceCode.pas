program AnalisisSemantik;

uses
    crt, sysutils;

var
   file_input : file of char;
   pilihan : string;

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

procedure baca_file(nama_file:string);
begin
     clrscr;
     try
        // Membaca file input
        assign(file_input, nama_file);
        reset(file_input);


        // Close file
        close(file_input);

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


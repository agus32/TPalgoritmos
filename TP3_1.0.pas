Program TP3;
Uses crt;
Const
clave_empresas = 'a';
clave_clientes = 'b';
Type
unaEmpresa = record
           cod_emp: string[3];
           nom: string[20];
           dire: string[20];
           mail: string[20];
           tel: string[20];
           cod_ciu: string[3];
           cont: integer;
           end;

unaCiudad = record
          cod_ciu: string[3];
          nom: string[25];
          cont: integer;
          end;

unCliente = record
          dni: string[8];
          nya: string[30];
          mail: string[15];
          end;

arreglo = array[1..3] of integer;

unProyecto = record
           cod_proy: string[3];
           cod_emp: string[3];
           etapa: char;
           tipo: char;
           cod_ciu: string[3];
           cant: arreglo;
           cont: integer;
           end;

unProducto = record
           cod_prod: string[3];
           cod_proy: string[3];
           prec: real;
           estado: boolean;
           detall: string[50];
           end;

empresas = file of unaEmpresa;
ciudades = file of unaCiudad;
clientes = file of unCliente;
proyectos = file of unProyecto;
productos = file of unProducto;
Var
emp: empresas;
e: unaEmpresa;
ciu: ciudades;
ci: unaCiudad;
cli: clientes;
cl: unCliente;
proyec: proyectos;
proy: unProyecto;
produ: productos;
prod: unProducto;
opc: integer;

function valida_clave(clave_ingresada,clave_correcta: string[11]): boolean;
var cont: integer;
tecla: char;
begin
cont:= 3;
if clave_ingresada=clave_correcta then valida_clave:= true
else
    begin
         repeat
         cont:= cont-1;
         writeln();
         writeln('Clave incorrecta');
         writeln('Te quedan ',cont,' intentos');
         writeln();
         writeln('Ingrese la clave: ');
         clave_ingresada:='';
                   repeat
                   tecla:=readkey;
                   if tecla<>#13 then
                      begin
                      clave_ingresada:=clave_ingresada+tecla;
                      write('*');
                      end;
                   until tecla=#13;
         until (clave_ingresada=clave_correcta) or (cont=1);
         if (clave_ingresada=clave_correcta) then valida_clave:= true
         else valida_clave:= false;
    end;
end;


procedure asigna_y_abre;
begin
assign(emp,'C:\TP3\EMPRESAS-CONSTRUCTORAS.DAT');
assign(ciu,'C:\TP3\CIUDADES.DAT');
assign(cli,'C:\TP3\CLIENTES.DAT');
assign(proyec,'C:\TP3\PROYECTOS.DAT');
assign(produ,'C:\TP3\PRODUCTOS.DAT');
{$I-}
reset(emp);
if (ioresult = 2) then rewrite(emp);
reset(ciu);
if (ioresult = 2) then rewrite(ciu);
reset(cli);
if (ioresult = 2) then rewrite(cli);
reset(proyec);
if (ioresult = 2) then rewrite(proyec);
reset(produ);
if (ioresult = 2) then rewrite(produ);
{$I+}
end;

FUNCTION BUSQUEDA_DICOT(valor:string):boolean;
VAR 
    sup,inf,med : integer;
    band : boolean;

begin
    reset(ciu);
    sup:= filesize(ciu)-1;
    inf := 0;
    band := false;
    while (band = false) and (inf<=sup) do
        begin
            med:= (inf + sup) div 2;
            seek(ciu,med);
            read (ciu,ci);
            if ci.cod_ciu = valor then
                band := true
            else 
                if ci.cod_ciu > valor then
                    sup:= med - 1
                else
                    inf:= med + 1;

        end;
    BUSQUEDA_DICOT := band;
end;

FUNCTION BUSQUEDA_SEC(valor:string):boolean;
var
    band : boolean;

begin
    band := false;
    reset(emp);
    while not(EOF(emp)) do
    begin
        read(emp,e);
        if e.cod_emp = valor then
        band := true;
    end;
BUSQUEDA_SEC := band;
end;



PROCEDURE alta_empresas;
VAR 
    k: char;
    nombre_emp, direccion, mail, telefono: string[20];
    cod_emp,COD_ciudad: string[3];

BEGIN
    repeat
        writeln('Ingrese el codigo de la empresa');
        repeat
            readln(cod_emp);
        until BUSQUEDA_SEC(cod_emp);
        writeln('Ingrese el nombre de la empresa');
        readln(nombre_emp);
        writeln('Ingrese la direccion');
        readln(direccion);
        writeln('Ingrese el mail de la empresa');
        readln(mail);
        writeln('Ingrese el telefono');
        readln(telefono);
        repeat
            writeln('Ingrese el codigo de la ciudad (codigo valido)');
            readln(COD_ciudad);
        until not(BUSQUEDA_DICOT(COD_ciudad));
        writeln('---------------------------');
        e.cod_emp := cod_emp;
        e.nom := nombre_emp;
        e.dire := direccion;
        e.mail := mail;
        e.tel := telefono;
        e.cod_ciu := COD_ciudad;
        e.cont := 0; 
        if not(eof(emp)) then
            seek(emp,filesize(emp));
        write(emp,e);
        repeat
            writeln('Desea agregar otra empresa? Presione S para continuar, N para terminar');
            readln(k)
        until (k='S')or(k='N');
    until (k='N');
    writeln('---------------------------');

END;

function encontro_proyecto(dato: string[3]): boolean;
var reg: unProyecto;
begin
if (filesize(proyec) = 0) then encontro_proyecto:= false
else
    begin
    seek(proyec,0);
    repeat
          read(proyec,reg);
    until (reg.cod_proy = dato) or eof(proyec);
    if (reg.cod_proy = dato) then encontro_proyecto:= true
    else encontro_proyecto:= false;
    end;
end;

procedure alta_proyectos;
var opc: char;
begin
clrscr;
writeln('Alta de PROYECTOS');
writeln();
writeln();
repeat
      writeln('-------------------------------------------------------------------------------------');
      writeln();
      write('Ingrese el codigo del proyecto: ');
      repeat
      readln(proy.cod_proy);
      if encontro_proyecto(proy.cod_proy) then write('El codigo ingresado ya existe, intentelo de nuevo: ');
      until not encontro_proyecto(proy.cod_proy);
      writeln();
      write('Ingrese el codigo de la empresa: ');
      //repeat
      readln(proy.cod_emp);
      //until busqueda_sec(proy.cod_emp);
      writeln();
      write('Ingrese la etapa del proyecto (P - O - T: Preventa - Obra - Terminado): ');
      repeat
      readln(proy.etapa);
      proy.etapa:= upcase(proy.etapa);
      if (proy.etapa <> 'P') and (proy.etapa <> 'O') and (proy.etapa <> 'T') then write('La etapa ingresada no es valida, intentelo de nuevo: ');
      until (proy.etapa = 'P') or (proy.etapa = 'O') or (proy.etapa = 'T');
      writeln();
      writeln('Ingrese el tipo de proyecto');
      write('Casa - Edificio departamento - Edificio oficina - Loteos (C - D - O - L): ');
      repeat
      readln(proy.tipo);
      proy.tipo:= upcase(proy.tipo);
      if (proy.tipo <> 'C') and (proy.tipo <> 'D') and (proy.tipo <> 'O') and (proy.tipo <> 'L') then write('El tipo ingresado no es valido, intentelo de nuevo: ');
      until (proy.tipo = 'C') or (proy.tipo = 'D') or (proy.tipo = 'O') or (proy.tipo = 'L');
      writeln();
      write('Ingrese el codigo de ciudad: ');
      //repeat
      readln(proy.cod_ciu);
      //until funcion();
      writeln();
      write('Ingrese la cantidad de productos: ');
      readln(proy.cant[1]);
      writeln();
      write('Ingrese la cantidad de consultas: ');
      readln(proy.cant[2]);
      writeln();
      write('Ingrese la cantidad de vendidos: ');
      readln(proy.cant[3]);
      writeln();
      writeln();
      proy.cont:= 0;
      seek(proyec,filesize(proyec));
      write(proyec,proy);
      write('Desea seguir cargando empresas [S/N]: ');
      repeat
      readln(opc);
      opc:= upcase(opc);
      until (opc = 'S') or (opc = 'N');
      writeln();
      writeln();
until (opc = 'N');
end;

procedure codciudad;
var
cod_ciudad: string[3];
nom_ciu:string[25];
respuesta:string[2];
begin
reset (ciu);
     writeln('Alta de ciudades');
     repeat
              repeat

                    writeln('Ingrese codigo de la ciudad');
                    writeln ('CBA. CORDOBA');
                    writeln ('ROS. ROSARIO');
                    writeln('BSA. BUENOS AIRES');
                    readln (cod_ciudad)
              until (cod_ciudad='ROS') OR (cod_ciudad='CBA') OR (cod_ciudad='BSA') ;
         writeln('Ingrese el nombre de la ciudad');
         readln(nom_ciu);
         writeln('¿Desea ingresar otra ciudad?');
         readln(respuesta)
         until(respuesta='NO');
close(ciu);
readln();
end.

procedure opciones_menup;
begin
writeln('MENU PRINCIPAL');
writeln();
writeln('      1. EMPRESAS');
writeln();
writeln('      2. CLIENTES');
writeln();
writeln('      0. Salir');
writeln();
end;

procedure opciones_menuempresas;
begin
writeln('MENU EMPRESAS DESARROLLADORAS');
writeln();
writeln('      1. Alta de CIUDADES');
writeln();
writeln('      2. Alta de EMPRESAS');
writeln();
writeln('      3. Alta de PROYECTOS');
writeln();
writeln('      4. Alta de PRODUCTOS');
writeln();
writeln('      5. Estadisticas');
writeln();
writeln('      0. Volver al menu principal');
end;

procedure menuempresas;
var opc: integer;
begin
Repeat
     clrscr;
     opciones_menuempresas;
     writeln();
          repeat
          write ('Ingrese una opcion: ');
          readln(opc);
          until (opc >= 0) and (opc <= 5);
     case opc of
          //1: alta_ciudades;
          2: alta_empresas;
          3: alta_proyectos;
          {4: alta_productos;
          5: estadisticas;}
          end;
until (opc=0);
end;

procedure m_empresas;
var
clave: string[11];
tecla: char;
begin
clrscr;
writeln('MENU EMPRESAS DESARROLLADORAS');
writeln();
writeln('Ingrese la clave: ');
clave:='';
repeat
      tecla:=readkey;
      if tecla<>#13 then
         begin
         clave:=clave+tecla;
         write('*');
         end;
until tecla=#13;
if valida_clave(clave,clave_empresas) then menuempresas
   else
   begin
   writeln();
   writeln('Limite de intentos, presione cualquier tecla para volver al menu principal');
   readkey;
   end;
end;

procedure opciones_menuclientes;
begin
clrscr;
writeln('MENU CLIENTES');
writeln();
writeln('      1. Alta de CLIENTE');
writeln();
writeln('      0. Volver al menu principal');
end;

procedure menuclientes;
var opc: integer;
begin
Repeat
     clrscr;
     opciones_menuclientes;
     writeln();
          repeat
          write ('Ingrese una opcion: ');
          readln(opc);
          until (opc >= 0) and (opc <= 1);
     {case opc of
          1: alta_clientes;
          end;}
until (opc=0);
end;

procedure m_clientes;
var
clave: string[11];
tecla: char;
begin
clrscr;
writeln('MENU CLIENTES');
writeln();
writeln('Ingrese la clave: ');
clave:='';
repeat
      tecla:=readkey;
      if tecla<>#13 then
         begin
         clave:=clave+tecla;
         write('*');
         end;
until tecla=#13;
if valida_clave(clave,clave_clientes) then menuclientes
   else
   begin
   writeln();
   writeln('Limite de intentos, presione cualquier tecla para volver al menu principal');
   readkey;
   end;
end;

Begin
asigna_y_abre;
Repeat
     clrscr;
     opciones_menup;
          repeat
          write ('Ingrese una opcion: ');
          readln(opc);
          until (opc >= 0) and (opc <= 2);
     case opc of
          1: m_empresas;
          2: m_clientes;
          end;
until (opc = 0);
close(emp);
close(ciu);
close(cli);
close(proyec);
close(produ);
end.
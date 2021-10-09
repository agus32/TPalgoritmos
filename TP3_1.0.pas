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

arreglo = array[1..4] of integer;

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
    m: unaCiudad;
begin
    reset(ciu);
    sup:= filesize(ciu)-1;
    inf := 0;
    band := false;
    while (band = false) and (inf<=sup) do
        begin
            med:= (inf + sup) div 2;
            seek(ciu,med);
            read (ciu,m);
            if m.cod_ciu = valor then
                band := true
            else 
                if m.cod_ciu > valor then
                    sup:= med - 1
                else
                    inf:= med + 1;
        end;
    BUSQUEDA_DICOT := band;
end;

FUNCTION BUSQUEDA_SEC(valor:string; op_arch:integer):boolean;
var
    band : boolean;
    
begin
    if (op_arch=0) then
    begin
    band := false;
    reset(emp);
    while not(EOF(emp)) do
    begin
        read(emp,e);
        if e.cod_emp = valor then
        band := true
    end;
    BUSQUEDA_SEC := band
    end;

    if (op_arch=1) then
    begin
    band := false;
    reset(produ);
    while not(EOF(produ)) do
    begin
        read(produ,prod);
        if prod.cod_prod = valor then
        begin
        band := true;
        writeln('El Codigo del producto ingresado ya existe, intente otro...');
        writeln()
        end
    end;
    BUSQUEDA_SEC := band
    end;
end;



PROCEDURE alta_empresas;
VAR 
    k: char;
    nombre_emp, direccion, mail, telefono: string[20];
    cod_emp,COD_ciudad: string[3];

BEGIN
clrscr;
    repeat
        writeln('Ingrese el codigo de la empresa');
        repeat
            readln(cod_emp);
        until not(BUSQUEDA_SEC(cod_emp));
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
        until BUSQUEDA_DICOT(COD_ciudad);
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
      writeln();
      writeln();
      proy.cont:= 0;
      proy.cant[2]:=0;
      proy.cant[3]:=0;
      proy.cant[4]:=0;
      seek(proyec,filesize(proyec));
      write(proyec,proy);
      write('Desea seguir cargando proyectos [S/N]: ');
      repeat
      readln(opc);
      opc:= upcase(opc);
      until (opc = 'S') or (opc = 'N');
      writeln();
      writeln();
until (opc = 'N');
end;

function cant_prod_proy(dato:string[3]): boolean;  //dato es el cod_proye
var band: boolean;
    reg: unProyecto;
begin
band:=false;
if (filesize(proyec)= 0) then cant_prod_proy:= false
else
    begin
    seek(proyec,0);
    repeat
          read(proyec,reg);
    until (reg.cod_proy = dato) or eof(proyec);
    if (reg.cod_proy = dato) then band:= true;
    if (band = true) then
       if (reg.cant[4]<reg.cant[1]) then
       begin
       reg.cant[4]:=reg.cant[4]+1;
       seek(proyec,(filepos(proyec)-1));
       write(proyec,reg);
       cant_prod_proy:=true
       end
       else
       begin
       writeln('La cant. de productos ya llego al limite.');
       cant_prod_proy:=false
       end
    end
end;

procedure alta_productos;
var
opc: char;

begin
clrscr;
writeln('-Alta de PRODUCTOS-');
writeln();
repeat
      writeln('----------------------------------------');
      {$I-}
      repeat
            writeln('Ingrese el codigo del producto: ');
            readln(prod.cod_prod);
      until (ioresult=0) and not(BUSQUEDA_SEC(prod.cod_prod,1));
      {$I+}
      repeat
            writeln('Ingrese codigo de proyecto correspondiente: ');
            readln(prod.cod_proy);
            if not (encontro_proyecto(prod.cod_proy)) then write('El codigo de proy. no existe, ingrese uno existente: ');
      until cant_prod_proy(prod.cod_proy);
      {$I-}
      repeat
            writeln('Ingrese el precio de venta');
            readln(prod.prec);
      until (ioresult=0) and (prod.prec>=0);
      {$I+}
      
      prod.estado:=false;
      writeln('Ingrese los detalles del producto: ');
      readln(prod.detall);

      seek(produ,filesize(produ));
      write(produ,prod);

      write('Desea seguir cargando productos [S/N]: ');
      repeat
      readln(opc);
      opc:= upcase(opc);
      until (opc = 'S') or (opc = 'N');
      writeln();
      writeln();
until (opc = 'N');
end;

procedure ordenaci;
var
i,k: integer;
j:unaciudad;
begin
reset(ciu);
for i:= 0 to filesize(ciu)-2 do
       for k := i+1 to filesize(ciu)-1 do
          begin
          Seek (ciu,i);
          READ (ciu, ci);
          Seek (ciu, k );
          READ (ciu , j);
          if ci.cod_ciu > j.cod_ciu
              then
                  begin
                     Seek (ciu,i);
                     Write (ciu, j);
                     Seek (ciu ,k  );
                     write (ciu,ci);
                   end;
         end;
end;

procedure alta_ciudades;
var
cod_ciudad: string[3];
nom_ciu:string[25];
respuesta:string[2];
begin
clrscr;
     writeln('Alta de ciudades');
     repeat
           {$I-}
              repeat
                    writeln('Ingrese codigo de la ciudad');
                    readln (ci.cod_ciu);
              until (ioresult = 0) and (BUSQUEDA_DICOT(ci.cod_ciu) = false);
            {$I+}           
         writeln('Ingrese el nombre de la ciudad');
         readln(ci.nom);
         seek(ciu,filesize(ciu));
         write(ciu,ci);
         ordenaci;
         writeln('¿Desea ingresar otra ciudad?');
         readln(respuesta);
         until(respuesta='NO');
end;

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

procedure datosempresa(valor:string[3]);
    
begin
writeln('Codigo    Nombre      Dirección     Email      Telefono      CodCiudad');
    reset(emp);
    while not(EOF(emp)) do
    begin
        read(emp,e);
        if e.cod_emp = valor then
        writeln(e.cod_emp, e.nom, e.dire, e.mail, e.tel, e.cod_ciu);

    end;

end;

procedure estadisticas;
var g,mayor: integer;
ciud_mayor: string[3];
begin
clrscr;
writeln('ESTADISTICAS');
writeln();
writeln();
writeln('Empresas cuyas consultas fueron mayores a 10: ');
reset(proyec);
for g:= 0 to (filesize(proyec) - 1) do
    begin
    read(proyec,proy);
    if proy.cant[2] > 10 then
       datosempresa(proy.cod_emp);
    end;
writeln('La ciudad con más consultas de proyectos: ');
mayor:= 0;
for g:= 0 to (filesize(proyec) - 1) do
    begin
    read(proyec,proy);
    if proy.cant[2] > mayor then
       mayor:= proy.cant[2];
       ciud_mayor:= proy.cod_ciu;
    end;
writeln(ciud_mayor);
writeln('Los proyectos que vendieron todas las unidades');
for g:= 0 to (filesize(proyec) - 1) do
    begin
    read(proyec,proy);
    if proy.cant[3] = proy.cant[1] then
       writeln(proy.cod_proy);
    end;
readln();
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
          1: alta_ciudades;
          2: alta_empresas;
          3: alta_proyectos;
          4: alta_productos;
          5: estadisticas;
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


procedure precio(dato:string[3]);
begin
    reset(produ);
    while not(EOF(produ)) do
    begin
        read(produ,prod);
        if prod.cod_prod = dato then
        writeln('El precio del producto es de: ', prod.prec);
    end;
end;

procedure cambioavendido(dato:string[3]);
begin
   reset(produ);
    while not(EOF(produ)) do
    begin
        read(produ,prod);
        if prod.cod_prod = dato then
           prod.estado:=true;
    end;
    reset(proyec);
    while not(EOF(proyec)) do
    begin
        read(proyec,proy);
        if proy.cod_proy = dato then
        begin
           proy.cant[3]:=proy.cant[3]+1;
           write(proyec,proy);
        end;
    end;
end;

procedure compraclientes;
var
cod:string[3];
respuesta:string[2];
begin
clrscr;
writeln('Ingrese el codigo del producto que desea comprar');
readln(cod);
precio(cod);
writeln('¿Desea confirma la compra?');
readln(respuesta);
              if respuesta ='si' then
              writeln('Compra realizada con exito');
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

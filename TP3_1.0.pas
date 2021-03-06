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
    cl: unCliente;
    e: unaEmpresa;
    prod: unProducto;
    
begin
    band := false;
    if (op_arch=0) then
    begin
    reset(emp);
    while not(EOF(emp)) do
    begin
        read(emp,e);
        if e.cod_emp = valor then
        band := true
    end;
    end;

    if (op_arch=1) then
    begin
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
    end;
    if (op_arch=2) or (op_arch=3) then
    begin
    reset(cli);
    while not(EOF(cli)) do
    begin
        read(cli,cl);
        if op_arch = 2 then
        begin
        if cl.dni = valor then
        band := true
        end
        else begin
        if cl.mail = valor then
        band := true
        end;
    end;
    end;
    BUSQUEDA_SEC := band;

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
respuesta:string[2];
begin
clrscr;
     writeln('Alta de ciudades');
     repeat
     writeln();
     writeln();
     write('Ingrese codigo de la ciudad: ');
     repeat
           readln (ci.cod_ciu);
           if (BUSQUEDA_DICOT(ci.cod_ciu) = true) then write('La ciudad ya esta cargada, intente nuevamente: ');
     until (BUSQUEDA_DICOT(ci.cod_ciu) = false);
         writeln();
         write('Ingrese el nombre de la ciudad: ');
         readln(ci.nom);
         seek(ciu,filesize(ciu));
         write(ciu,ci);
         ordenaci;
         writeln();
         write('Desea ingresar otra ciudad? [S/N]: ');
         readln(respuesta);
         respuesta:= upcase(respuesta);
     until(respuesta='N');
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
            readln(cod_emp)
        until not(BUSQUEDA_SEC(cod_emp,0));
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
      repeat
      readln(proy.cod_emp);
      if not busqueda_sec(proy.cod_emp,0) then write('El codigo de la empresa no existe, vuelva a intentarlo: ');
      until busqueda_sec(proy.cod_emp,0);
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
      repeat
      readln(proy.cod_ciu);
      if not busqueda_dicot(proy.cod_ciu) then write('El codigo de ciudad no existe, vuelva a intentarlo: ');
      until busqueda_dicot(proy.cod_ciu);
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
      until (ioresult=0) and not (BUSQUEDA_SEC(prod.cod_prod,1));
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

procedure datosempresa(valor:string[3]);
begin
seek(emp,0);
            repeat
                  read(emp,e);
            until (e.cod_emp = valor) or (eof(emp));
            if (e.cod_emp = valor) then
               writeln(e.cod_emp:3,'      ',e.nom:10,'     ',e.dire:14,'        ',e.mail:14,'          ',e.tel:8,'          ',e.cod_ciu:3);
end;

FUNCTION BUSQUEDA_CIU(valor:string):string;
var
    band : string[20];
    ci: unaCiudad;
begin
    band := '';
    reset(ciu);
    while not(EOF(ciu)) do
    begin
        read(ciu,ci);
        if ci.cod_ciu = valor then
        band := ci.nom;
    end;
BUSQUEDA_CIU := band;
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
writeln();
writeln('Codigo          Nombre          Direcci?n                 Email          Telefono          CodCiudad');
writeln('----------------------------------------------------------------------------------------------------');
seek(proyec,0);
for g:= 0 to (filesize(proyec) - 1) do
    begin
    read(proyec,proy);
    if (proy.cant[2] > 10) then datosempresa(proy.cod_emp);
    end;
writeln();
writeln();
mayor:= 0;
for g:= 0 to (filesize(ciu) - 1) do
    begin
    read(ciu,ci);
    if (ci.cont > mayor) then
       mayor:= ci.cont;
       ciud_mayor:= ci.cod_ciu;
    end;
writeln('La ciudad con mas consultas de proyectos fue: ',BUSQUEDA_CIU(ciud_mayor));
writeln();
writeln();
writeln('Los proyectos que vendieron todas las unidades fueron: ');
writeln();
writeln('CODIGO DE PROYECTO');
for g:= 0 to (filesize(proyec) - 1) do
    begin
    read(proyec,proy);
    if proy.cant[3] = proy.cant[1] then
       writeln(proy.cod_proy:18);
    end;
readkey;
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

/////////////////////////////////////////////////
FUNCTION BUSQUEDA_NOM(valor:string):string;
var
    band : string[20];
begin
    band := '';
    reset(emp);
    while not(EOF(emp)) do
    begin
        read(emp,e);
        if e.cod_emp = valor then
        band := e.nom;
    end;
BUSQUEDA_NOM := band;
end;

PROCEDURE BUSQUEDA_PROD(valor:string);
begin
    reset(produ);
    while not(EOF(produ)) do
    begin
        read(produ,prod);
        if (prod.cod_proy = valor) and (prod.estado = false) then
        begin
        writeln('---------------------------------------');
        writeln('Codigo de Producto: ',prod.cod_prod);
        writeln('Cod. de Proyecto Perteneciente: ',prod.cod_proy);
        writeln('Precio de Producto: $',prod.prec);
        writeln('Detalles del Producto: ',prod.detall);
        writeln('---------------------------------------')
        end
    end;
end;

PROCEDURE ACTUALIZAR_CANT_CONSULT(dato: string);

begin
//busco en proy, con el proy.cod_proy
//actualizo +1 en proy.cant[2]
    reset(proyec);
    repeat
          read(proyec,proy);
    until (proy.cod_proy = dato) or eof(proyec);
    if (proy.cod_proy = dato) then
    begin
    proy.cant[2]:=proy.cant[2]+1;
    seek(proyec, filepos(proyec)-1);
    write(proyec,proy)
    end;
//tomo el proy.cod_emp y lo busco en emp
//actualizo en emp, e.cont +1
    seek(proyec, filepos(proyec)-1);
    read(proyec,proy);
    reset(emp);
    repeat
          read(emp,e);
    until (proy.cod_emp = e.cod_emp) or eof(emp);
    if (proy.cod_emp = e.cod_emp) then
    begin
    e.cont:=e.cont+1;
    seek(emp, filepos(emp)-1);
    write(emp,e)
    end;
//Tomo el proy.cod_ciu y lo busco en ciu
//actualizo en ciu, ci.cont +1.
    seek(proyec, filepos(proyec)-1);
    read(proyec,proy);
    reset(ciu);
    repeat
          read(ciu,ci);
    until (proy.cod_ciu = ci.cod_ciu) or eof(ciu);
    if (proy.cod_ciu = ci.cod_ciu) then
    begin
    ci.cont:=ci.cont+1;
    seek(ciu, filepos(ciu)-1);
    write(ciu,ci)
    end;
end;

procedure consulta_proy;
var
    tipo, opc_cons: char;
    etapa, nombre_emp, nombre_ciu, cod_proy_cons: string[20];
    i: integer;

begin
    writeln('Ingrese tipo de proyecto a consultar [C/D/O/L]');
    repeat
        readln(tipo);
    until (tipo='C')or(tipo='D')or(tipo='O')or(tipo='L');
    reset(proyec);
    writeln('  CODIGO PROYECTO  |  NOMBRE EMPRESA  |  ETAPA  |  TIPO  |  CIUDAD  |');
    while not(EOF(proyec)) do
    begin
        read(proyec,proy);
        if proy.tipo = tipo then
        begin
            case proy.etapa of 
                'P': etapa := 'Preventa';
                'O': etapa := 'Obra';
                'T': etapa := 'Terminado';
        end;
        nombre_emp := BUSQUEDA_NOM(proy.cod_emp);
        nombre_ciu := BUSQUEDA_CIU(proy.cod_ciu);
        writeln(proy.cod_proy,'  ', nombre_emp,'  ', etapa,'  ', tipo,'  ', nombre_ciu,'  ');   
    end;
    writeln();
    writeln();
    repeat
    repeat
    writeln('Ingrese el codigo de proyecto existente a consultar: ');
    readln(cod_proy_cons)
    until (encontro_proyecto(cod_proy_cons));
    writeln('Los productos disponibles del proyecto codigo', cod_proy_cons,' son: ');
    BUSQUEDA_PROD(cod_proy_cons);
    ACTUALIZAR_CANT_CONSULT(cod_proy_cons);
    repeat
    writeln('Desea consultar otro proyecto: S/N');
    readln(opc_cons)
    until (opc_cons='S') or (opc_cons='N');
    until (opc_cons='N');
end;
end;

procedure precio(dato:string[3]);
begin
    seek(produ,0);
    repeat
        read(produ,prod);
    until (prod.cod_prod = dato) or (eof(produ));
    if (prod.cod_prod = dato) then
        writeln('El precio del producto es de: $ ', prod.prec);
end;

procedure cambioavendido(dato:string[3]);
begin
seek(produ,0);
    repeat
        read(produ,prod);
    until (prod.cod_prod = dato) or (eof(produ));
if (prod.cod_prod = dato) then
   prod.estado:= true;
seek(produ,(filepos(produ) - 1));
write(produ,prod);
seek(proyec,0);
repeat
        read(proyec,proy);
until (proy.cod_proy = dato) or eof(proyec);
if (proy.cod_proy = dato) then
   begin
        proy.cant[3]:= (proy.cant[3] + 1);
        seek(proyec,(filepos(proyec) - 1));
        write(proyec,proy);
   end;
end;

procedure venta_prod(dni_comprador: string);
var
cod:string[3];
respuesta,respuesta2:string[2];
begin
clrscr;
seek(cli,0);
repeat
      read(cli,cl);
until (cl.dni = dni_comprador) or (eof(cli));
if (cl.dni = dni_comprador) then writeln('Bienvenido ',cl.nya);
repeat
      writeln();
      write('Ingrese el codigo del producto que desea comprar: ');
      repeat
            readln(cod);
            if not (BUSQUEDA_SEC(cod,1)) then write('El codigo de producto ingresado no existe, vuelva a intentarlo: ');
      until (BUSQUEDA_SEC(cod,1));
      writeln();
      precio(cod);
      writeln();
      writeln('Desea confirmar la compra? [S/N]: ');
      repeat
                     readln(respuesta);
                     respuesta:= upcase(respuesta);
      until (respuesta = 'S') or (respuesta = 'N');
            if (respuesta = 'S') then
            begin
            cambioavendido(cod);
            writeln('Compra realizada con exito, le llegara al mail: ',cl.mail);
            end;
      writeln();
      writeln('Desea realizar otra compra: [S/N] ');
      repeat
            readln(respuesta2);
      until (respuesta2 = 'S') or (respuesta2 = 'N');
until (respuesta2 = 'N');
end;

procedure alta_clientes;
var
dni,dni_reg :string;
opc : integer;
mail_reg: string;
begin 
     clrscr;
     writeln('Ingrese DNI cliente');
     readln(dni);
     if (BUSQUEDA_SEC(dni,2)) then
     begin
     writeln('      1. Consulta de proyectos');
     writeln();
     writeln('      2. Compra de productos');
     writeln();
     writeln('      0. Volver al menu principal');
     repeat
     writeln ('Ingrese una opcion: ');
     readln(opc);
     until (opc >= 0) and (opc <= 2);
     case opc of
     1: consulta_proy;
     2: venta_prod(dni);
     end;
end
else
begin
     writeln('Dni no encontrado por favor registrese');
     repeat until keypressed;
     clrscr;
     writeln('        REGISTRO');
     writeln('-----------------------');
     writeln();
     reset(cli);
     {$I-}
     repeat
     writeln('Ingrese dni valido');
     readln(dni_reg);
     if BUSQUEDA_SEC(dni_reg,2) then writeln('Dni ya registrado');
     until (ioresult = 0) and not (BUSQUEDA_SEC(dni_reg,2));
     cl.dni:= dni_reg;
     {$I+}
     writeln('Ingrese nombre y apellido');
     readln(cl.nya);
     repeat
     writeln('Ingrese mail valido');
     readln(mail_reg);
     if BUSQUEDA_SEC(mail_reg,3) then writeln('Mail ya registrado');
     until not(BUSQUEDA_SEC(mail_reg,3));
     cl.mail:= mail_reg;
     seek(cli,filesize(cli));
     write(cli,cl);
end;
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
     case opc of
          1: alta_clientes;
          end;
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

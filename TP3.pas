Program TP3;
Uses crt;
const

type
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
var
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


begin


end.

set foreign_key_checks = 1;
create database DLP;
use dlp;

-- La siguiente es una estructura basica de placas de video y proovedores la cual consta de las marcas NVIDIA y AMD, junto a una tabla de proovedores y clientes.

create table placas (
	marca_id int primary key not null,
	nvidia varchar(20),
	amd varchar(20)	
);

-- los _a corresponden a AMD y los _n a NVIDIA
create table proovedores (
	proovedor_id int,
    dlp_n int,
    brt_n int,
    dlp_a int,
    brt_a int,
    constraint precio check (dlp_n >= 1),
    constraint precio_ check (brt_n >= 1),
     constraint precio__ check (brt_a >= 1),
      constraint precio___ check (dlp_a >= 1),
    foreign key (proovedor_id) references placas (marca_id) on update cascade on delete cascade
);


create table clientes (
	cliente_producto int primary key not null,
    nombre varchar(50),
    producto varchar (50),
    foreign key (cliente_producto) references placas (marca_id) on update cascade on delete cascade
);
alter table clientes add column fecha date;
update clientes set fecha = "2023-05-06" where cliente_producto = 5;
select * from clientes;
insert into clientes values 
	(1, "Julieta gomez", "GTX1050", "2023-05-06"),
    (2, "Damian lopez", "RX6700", "2023-04-06"),
    (3, "Harry Styles", "RX7000", "2023-01-06"),
    (4, "George", "GTX3080", "2023-06-27"),
	(5, "Taylor swift", "GTX4050","2023-03-24");

select * from placas;
insert into placas values
	(1, "GTX1050", "RX6500"),
    (2, "GTX1650", "RX6700"),
    (3, "GTX3060", "RX7000"),
    (4, "GTX3080", "RX8000"),
    (5, "GTX4050", "RX9000");

select * from proovedores;
insert into proovedores values
	(1, 156000, 158000, 145000, 147000),
    (2, 205000, 202000,  198000, 201000),
    (3, 270000, 285000, 245000, 269000),
    (4, 300000, 299000, 286000, 294000),
    (5, 350000, 365000, 315000, 332000);

-- Podemos visualizar el producto junto a los precios de los distintos proovedores

-- AMD
select dlp_a, brt_a, amd from proovedores inner join placas on proovedor_id = marca_id;

-- NVIDIA
select nvidia, dlp_n, brt_n from placas inner join proovedores on marca_id = proovedor_id;

-- Podemos crear una view rapida para los datos de nvidia por ejemplo
create view precios_nvidia as select nvidia, dlp_n, brt_n from placas inner join proovedores on marca_id = proovedor_id;
select * from precios_nvidia;

-- Ordenamos la tabla
alter table proovedores modify dlp_a int after dlp_n;
select * from proovedores;


select nombre, producto, dlp_n, brt_n, dlp_a, brt_a from clientes inner join proovedores on cliente_producto = proovedor_id where nombre like "_a%";
select nombre, producto, dlp_n, brt_n, dlp_a, brt_a from clientes inner join proovedores on cliente_producto = proovedor_id where nombre like "J%";

-- Podemos crear un procedure para llamar cosas mas rapido.
delimiter $$
create procedure cc()
begin
select * from clientes;
end $$
delimiter ;
call cc();


create table ordenes_eliminadas (
	cliente_producto int,
    nombre varchar (50),
    producto varchar (50),
    fecha date,
    usuario varchar (50)
    );
    

-- Triggers 

create trigger ad_ordenes after delete on clientes for each row insert into ordenes_eliminadas (cliente_producto, nombre, producto, fecha, usuario) values 
(old.cliente_producto, old.nombre, old.producto, now(), current_user());

delete from clientes where cliente_producto = 2;
select * from ordenes_eliminadas;

create trigger bu_precios before update on proovedores for each row set new.iva_dlpN = (new.dlp_n * 21 / 100);
create trigger bu1_precios before update on proovedores for each row set new.iva_dlpA = (new.dlp_a * 21 / 100);
create trigger bu2_precios before update on proovedores for each row set new.iva_brtN = (new.brt_n * 21 / 100);
create trigger bu3_precios before update on proovedores for each row set new.iva_brtA = (new.brt_a * 21 / 100);

update proovedores set brt_n = 170000 where proovedor_id = 1;

select * from proovedores;









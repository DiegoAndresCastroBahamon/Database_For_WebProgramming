
-- Creacion De Base de Datos para web service "Dreamotos"

-- Creamos Los roles

CREATE ROLE admin_dreamotos WITH LOGIN ENCRYPTED PASSWORD '234567';
CREATE ROLE asesor_dreamotos WITH LOGIN ENCRYPTED PASSWORD '345678';
CREATE ROLE encargado_dreamotos WITH LOGIN ENCRYPTED PASSWORD '456789';

-- Creamos tabla categorias

CREATE TABLE categorias (
id bigserial NOT NULL,
published integer NOT NULL DEFAULT '0',
name varchar (255) NOT NULL,
icon varchar (255) NOT NULL,
created_at timestamp without time zone DEFAULT now(),
updated_at timestamp without time zone DEFAULT now(),
CONSTRAINT categorias_pkey PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE public.categorias OWNER TO dreamotos;

select * from categorias;

-- Creamos tabla productos

CREATE TABLE productos (
id bigserial NOT NULL,
published integer NOT NULL DEFAULT '0',
rating_cache double precision NOT NULL DEFAULT '3.0',
rating_count integer NOT NULL DEFAULT '0',
category_id bigint NOT NULL,
name varchar (255) NOT NULL,
pricing double precision NOT NULL DEFAULT '0.00',
short_description varchar (255) NOT NULL,
long_description text NOT NULL,
icon varchar (255) NOT NULL,
created_at timestamp without time zone DEFAULT now (),
updated_at timestamp without time zone DEFAULT now (),
CONSTRAINT productos_pkey PRIMARY KEY (id),
CONSTRAINT productos_category_id_fkey FOREIGN KEY (category_id)
REFERENCES public.categorias (id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION
)
WITH (
OIDS=FALSE
);
ALTER TABLE public.productos OWNER TO dreamotos;

select * from productos;

-- Añadimos informacion a la tabla categorias

INSERT INTO categorias ("published", "name", "icon") VALUES
(1, 'Categoria 1', 'categoria01.jpg'),
(1, 'Categoria 2', 'categoria02.jpg'),
(1, 'Category Three', 'categoria03.jpg'),
(1, 'Category Four', 'categoria04.jpg'),
(1, 'Category Five', 'categoria05.jpg');

-- Añadimos informacion a la tabla productos

INSERT INTO productos ("published", "rating_cache", "rating_count", "category_id",
"name", "pricing", "short_description", "long_description", "icon") VALUES
(1, 3.0, 0, 1, 'producto 01', 20.99, 'Short description', 'Lorem ips ...',
'product01.jpg'),
(1, 3.0, 0, 1, 'producto 02', 55.00, 'Short description', 'Lorem ips ...',
'product02.jpg'),
(1, 3.0, 0, 1, 'producto 03', 65.00, 'Short description', 'Lorem ips ...',
'product03.jpg'),
(1, 3.0, 0, 1, 'producto 04', 85.00, 'Short description', 'Lorem ips ...',
'product04.jpg'),
(1, 3.0, 0, 1, 'producto 05', 95.00, 'Short description', 'Lorem ips ...',
'product05.jpg'),
(1, 3.0, 0, 2, 'Producto 06', 35.00, 'Short description', 'Lorem ips ...',
'product06.jpg'),
(1, 3.0, 0, 2, 'Producto 07', 45.00, 'Short description', 'Lorem ips ...',
'product07.jpg'),
(1, 3.0, 0, 3, 'Producto 08', 52.00, 'Short description', 'Lorem ips ...',
'product08.jpg'),
(1, 3.0, 0, 3, 'Producto 09', 62.00, 'Short description', 'Lorem ips ...',
'product09.jpg'),
(1, 3.0, 0, 4, 'Producto 10', 14.00, 'Short description', 'Lorem ips ...',
'product10.jpg'),
(1, 3.0, 0, 4, 'Producto 11', 18.00, 'Short description', 'Lorem ips ...',
'product11.jpg'),
(1, 3.0, 0, 5, 'Producto 12', 40.00, 'Short description', 'Lorem ips ...',
'product12.jpg'),
(1, 3.0, 0, 5, 'Producto 13', 44.00, 'Short description', 'Lorem ips ...',
'product13.jpg');

-- Verificamos el contenido de las tablas

select * from productos;

select * from categorias;

-- Añadimos permisos a los diferentes roles

grant select, insert, update, delete on categorias to admin_dreamotos;
grant select, insert, update, delete on productos to admin_dreamotos;
grant usage, select on all sequences in schema public to admin_dreamotos;


grant select on categorias to asesor_dreamotos;
grant select on productos to asesor_dreamotos;
grant select on all sequences in schema public to asesor_dreamotos;


grant select on categorias to encargado_dreamotos;
grant select on productos to encargado_dreamotos;
grant select on all sequences in schema public to encargado_dreamotos;


--   && Auditorias y Disparadores &&


-- Creamos tabla donde se guardaran los datos de categorias

CREATE TABLE Disparadores (
id bigserial NOT NULL,
published integer NOT NULL DEFAULT '0',
name varchar (255) NOT NULL,
icon varchar (255) NOT NULL,
created_at timestamp without time zone DEFAULT now(),
updated_at timestamp without time zone DEFAULT now(),
CONSTRAINT disparadores_pkey PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE public.disparadores OWNER TO dreamotos;

-- Creamos tabla donde se guardaran los datos de productos

CREATE TABLE Bk_Productos (
id bigserial NOT NULL,
published integer NOT NULL DEFAULT '0',
rating_cache double precision NOT NULL DEFAULT '3.0',
rating_count integer NOT NULL DEFAULT '0',
category_id bigint NOT NULL,
name varchar (255) NOT NULL,
pricing double precision NOT NULL DEFAULT '0.00',
short_description varchar (255) NOT NULL,
long_description text NOT NULL,
icon varchar (255) NOT NULL,
created_at timestamp without time zone DEFAULT now (),
updated_at timestamp without time zone DEFAULT now (),
CONSTRAINT Bk_Productos_pkey PRIMARY KEY (id),
CONSTRAINT Bk_Productos_category_id_fkey FOREIGN KEY (category_id)
REFERENCES public.disparadores (id) MATCH SIMPLE
ON UPDATE NO ACTION
ON DELETE NO ACTION
)
WITH (
OIDS=FALSE
);
ALTER TABLE public.Bk_Productos OWNER TO dreamotos;

-- Verificamos el contenido de las tablas

select * from categorias;

select * from productos;

select * from Disparadores;

select * from Bk_Productos;

-- Creamos una funcion para los datos de la tabla categorias

create function SP_Test() returns Trigger
as
$$
begin


insert into Disparadores values (old.id, old.published, old.name, old.icon);

return new;
End
$$
Language plpgsql;

-- Creamos una funcion para los datos de la tabla productos

create function SP_Test2() returns Trigger
as
$$
begin


insert into Bk_Productos values (old.id, old.published, old.name, old.icon);

return new;
End
$$
Language plpgsql;


-- Creamos los Triggers (Disparadores)


create trigger TR_Update before Update on categorias
for each row 
execute procedure SP_Test();


create trigger TR_Update2 before Update on productos
for each row 
execute procedure SP_Test2();



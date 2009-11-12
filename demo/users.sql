\connect almidondemo

CREATE TABLE alm_table (idalm_table varchar(16) PRIMARY KEY, alm_table varchar(100), key varchar(32), orden varchar (100));
ALTER TABLE public.alm_table OWNER TO almidondemo;

CREATE TABLE alm_column (idalm_column varchar (32), idalm_table varchar (32) REFERENCES alm_table, type varchar (16), size int, pk bool, fk varchar(16), alm_column varchar(100), extra varchar(500), PRIMARY KEY (idalm_column, idalm_table));
ALTER TABLE public.alm_column OWNER TO almidondemo;

CREATE TABLE alm_role (idalm_role varchar(8) PRIMARY KEY, alm_role varchar(100));
ALTER TABLE public.alm_role OWNER TO almidondemo;

CREATE TABLE alm_user (idalm_user varchar(16) PRIMARY KEY, idalm_role varchar(8) REFERENCES alm_role, password varchar(200) NOT NULL, alm_user varchar(200) NOT NULL, email varchar(200));
ALTER TABLE public.alm_user OWNER TO almidondemo;

CREATE TABLE alm_access (idalm_role varchar(8) REFERENCES alm_role NULL, idalm_user varchar(16) REFERENCES alm_user , idalm_table varchar(16) REFERENCES alm_table, idalm_access serial PRIMARY KEY);
ALTER TABLE public.alm_access OWNER TO almidondemo;

-- especificamos id porque puede usarse 'hard-coded' en algun lado
INSERT INTO alm_role VALUES ('full', 'Control Total');
INSERT INTO alm_role VALUES ('edit', 'Edicion');
INSERT INTO alm_role VALUES ('delete', 'Correccion');
INSERT INTO alm_role VALUES ('read', 'Lectura');
INSERT INTO alm_role VALUES ('deny', 'Sin Accesso');

INSERT INTO alm_user VALUES ('admin', 'full', '21232f297a57a5a743894a0e4a801fc3', 'Admin', 'admin@example.com');
INSERT INTO alm_user VALUES ('demo', 'read', 'fe01ce2a7fbac8fafaed7c982a04e229', 'Demo', 'demo@example.com');
INSERT INTO alm_user VALUES ('alice', NULL, 'fe01ce2a7fbac8fafaed7c982a04e229', 'Alice', 'alice@example.com');

-- tablas a las cuales el acceso se puede personalizar
INSERT INTO alm_table (idalm_table, alm_table, key, orden) VALUES ('agenda', 'Agenda', 'idagenda', 'agenda');
INSERT INTO alm_table (idalm_table, alm_table, key, orden) VALUES ('doc', 'Documentos', 'iddoc', 'doc');
INSERT INTO alm_table (idalm_table, alm_table, key, orden) VALUES ('enlace', 'Enlaces', 'idenlace', 'enlace');
INSERT INTO alm_table (idalm_table, alm_table, key, orden) VALUES ('foto', 'Fotos', 'idfoto', 'foto');
INSERT INTO alm_table (idalm_table, alm_table, key, orden) VALUES ('galeria', 'Galerias', 'idgaleria', 'galeria');
INSERT INTO alm_table (idalm_table, alm_table, key, orden) VALUES ('noticia', 'Noticias', 'idnoticia', 'fecha');
INSERT INTO alm_table (idalm_table, alm_table, key, orden) VALUES ('pagina', 'Paginas', 'idpagina', 'pagina');

-- 'control total' para 'alice' en 'pagina'
INSERT INTO alm_access VALUES ('full', 'alice', 'pagina');

-- campos para tables.class.php
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('idpagina', 'pagina', 'serial', 0, true, '', 'ID', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('foto', 'pagina', 'image', 0, false, '', 'Foto', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('descripcion', 'pagina', 'text', 0, false, '', 'Descripcion', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('pagina', 'pagina', 'varchar', 500, false, '', 'Titulo', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('idgaleria', 'galeria', 'serial', 0, true, '', 'ID', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('galeria', 'galeria', 'varchar', 500, false, '', 'Titulo', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('fecha', 'galeria', 'date', 0, false, '', 'Fecha', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('idfoto', 'foto', 'serial', 0, true, '', 'ID', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('foto', 'foto', 'varchar', 500, false, '', 'Titulo', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('idgaleria', 'foto', 'int', 0, false, 'galeria', 'Galeria', NULL);
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('imagen', 'foto', 'image', 0, false, '', 'Foto', '100,300x300');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('idagenda', 'agenda', 'serial', 0, true, '', 'ID', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('agenda', 'agenda', 'varchar', 500, false, '', 'Titulo', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('fecha', 'agenda', 'date', 0, false, '', 'Fecha', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('lugar', 'agenda', 'varchar', 120, false, '', 'Lugar', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('texto', 'agenda', 'text', 0, false, '', 'Evento', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('organiza', 'agenda', 'varchar', 500, false, '', 'Organizado por', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('iddoc', 'doc', 'serial', 0, true, '', 'ID', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('doc', 'doc', 'varchar', 500, false, '', 'Titulo', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('archivo', 'doc', 'file', 0, false, '', 'Archivo', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('portada', 'doc', 'image', 0, false, '', 'Imagen', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('descripcion', 'doc', 'xhtml', 0, false, '', 'Descripcion', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('idnoticia', 'noticia', 'serial', 0, true, '', 'ID', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('noticia', 'noticia', 'varchar', 500, false, '', 'Titulo', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('fecha', 'noticia', 'datenull', 0, false, '', 'Fecha', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('texto', 'noticia', 'text', 0, false, '', 'Texto', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('foto', 'noticia', 'image', 0, false, '', 'Foto', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('idenlace', 'enlace', 'serial', 0, true, '', 'ID', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('enlace', 'enlace', 'varchar', 500, false, '', 'Titulo', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('url', 'enlace', 'varchar', 600, false, '', 'Direccion web', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('texto', 'enlace', 'text', 0, false, '', 'Texto', '');
INSERT INTO alm_column (idalm_column, idalm_table, type, size, pk, fk, alm_column, extra) VALUES ('imagen', 'enlace', 'image', 0, false, '', 'Imagen', '');
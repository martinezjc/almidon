\connect almidondemo

CREATE TABLE almtable (idalmtable varchar(16) PRIMARY KEY, almtable varchar(100));
ALTER TABLE public.almtable OWNER TO almidondemo;

CREATE TABLE almrole (idalmrole varchar(8) PRIMARY KEY, almrole varchar(100));
ALTER TABLE public.almrole OWNER TO almidondemo;

CREATE TABLE almuser (idalmuser varchar(16) PRIMARY KEY, idalmrole varchar(8) REFERENCES almrole, password varchar(200) NOT NULL, almuser varchar(200) NOT NULL, email varchar(200));
ALTER TABLE public.almuser OWNER TO almidondemo;

CREATE TABLE almaccess (idalmrole varchar(8) REFERENCES almrole NULL, idalmuser varchar(16) REFERENCES almuser , idalmtable varchar(16) REFERENCES almtable, idalmaccess serial PRIMARY KEY);
ALTER TABLE public.almaccess OWNER TO almidondemo;

-- especificamos id porque puede usarse 'hard-coded' en algun lado
INSERT INTO almrole VALUES ('full', 'Control Total');
INSERT INTO almrole VALUES ('edit', 'Edicion');
INSERT INTO almrole VALUES ('delete', 'Correccion');
INSERT INTO almrole VALUES ('read', 'Lectura');
INSERT INTO almrole VALUES ('deny', 'Sin Accesso');

INSERT INTO almuser VALUES ('admin', 'full', '21232f297a57a5a743894a0e4a801fc3', 'Admin', 'admin@example.com');
INSERT INTO almuser VALUES ('demo', 'read', 'fe01ce2a7fbac8fafaed7c982a04e229', 'Demo', 'demo@example.com');
INSERT INTO almuser VALUES ('alice', NULL, 'fe01ce2a7fbac8fafaed7c982a04e229', 'Alice', 'alice@example.com');

-- tablas a las cuales el acceso se puede personalizar
INSERT INTO almtable VALUES ('almaccess','Control de acceso personalizado');
INSERT INTO almtable VALUES ('almtable', 'Tablas');
INSERT INTO almtable VALUES ('almrole', 'Roles');
INSERT INTO almtable VALUES ('almuser', 'Usuarios');
INSERT INTO almtable VALUES ('pagina', 'Paginas');
INSERT INTO almtable VALUES ('agenda', 'Agenda');
INSERT INTO almtable VALUES ('doc', 'Documentos');
INSERT INTO almtable VALUES ('enlace', 'Enlaces');
INSERT INTO almtable VALUES ('foto', 'Fotos');
INSERT INTO almtable VALUES ('galeria', 'Galerias');
INSERT INTO almtable VALUES ('noticia', 'Noticias');

-- 'control total' para 'alice' en 'pagina'
INSERT INTO almaccess VALUES ('full', 'alice', 'pagina');

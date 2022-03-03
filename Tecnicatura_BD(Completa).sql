-- CREACION BASE DE DATOS
CREATE DATABASE Tecnicatura

-- CREACION TABLAS
CREATE TABLE provincias (
id_provincia INT IDENTITY(1,1),
nom_provincia VARCHAR(60) NOT NULL,
CONSTRAINT pk_provincias PRIMARY KEY (id_provincia)
);

CREATE TABLE localidades (
id_localidad INT IDENTITY(1,1),
nom_localidad VARCHAR(60) NOT NULL,
id_provincia INT NOT NULL,
CONSTRAINT pk_localidades PRIMARY KEY (id_localidad),
CONSTRAINT fk_localidades FOREIGN KEY (id_provincia)
REFERENCES provincias(id_provincia)
);

CREATE TABLE barrios (
id_barrio INT IDENTITY(1,1),
nom_barrio VARCHAR(60) NOT NULL,
id_localidad INT NOT NULL,
CONSTRAINT pk_barrios PRIMARY KEY (id_barrio),
CONSTRAINT fk_barrios FOREIGN KEY (id_localidad)
REFERENCES localidades(id_localidad)
);

CREATE TABLE domicilios (
id_domicilio INT IDENTITY(1,1),
calle VARCHAR(120),
nro INT NOT NULL,
piso INT,
departamento VARCHAR(5),
id_barrio INT,
CONSTRAINT pk_domicilios PRIMARY KEY (id_domicilio),
CONSTRAINT fk_domicilios FOREIGN KEY (id_barrio)
REFERENCES barrios(id_barrio)
);

CREATE TABLE sexos (
id_sexo INT IDENTITY(1,1),
sexo VARCHAR(12) NOT NULL,
CONSTRAINT pk_sexos PRIMARY KEY (id_sexo)
);

CREATE TABLE estados_laborales (
id_est_lab INT IDENTITY(1,1),
estado_laboral VARCHAR(80) NOT NULL,
CONSTRAINT pk_estados_laborales PRIMARY KEY (id_est_lab)
);

CREATE TABLE situaciones_habitacionales (
id_sit_hab INT IDENTITY(1,1),
situacion_habitacional VARCHAR(80),
CONSTRAINT pk_situaciones_habitacionales PRIMARY KEY (id_sit_hab)
);

CREATE TABLE tipos_doc (
id_tipo_doc INT IDENTITY (1,1),
tipo VARCHAR(80) NOT NULL,
CONSTRAINT pk_tipos_doc PRIMARY KEY (id_tipo_doc)
);

CREATE TABLE estados_civiles (
id_estado_civil INT IDENTITY(1,1),
estado_civil VARCHAR(80) NOT NULL,
CONSTRAINT pk_estados_civiles PRIMARY KEY (id_estado_civil)
);

CREATE TABLE personas (
id_persona INT IDENTITY(1,1),
nom_persona VARCHAR(120) NOT NULL,
ape_persona VARCHAR(120) NOT NULL,
id_tipo_doc INT NOT NULL,
nro_doc BIGINT NOT NULL,
id_est_lab INT,
id_sit_hab INT,
fecha_ingreso DATE NOT NULL,
fecha_nac DATE NOT NULL,
telefono VARCHAR(30),
id_sexo INT NOT NULL,
email VARCHAR(60),
id_domicilio INT NOT NULL,
id_estado_civil INT,
CONSTRAINT pk_personas PRIMARY KEY (id_persona),
CONSTRAINT fk_personas_tipos_doc FOREIGN KEY (id_tipo_doc)
REFERENCES tipos_doc(id_tipo_doc),
CONSTRAINT fk_personas_estados_laborales FOREIGN KEY (id_est_lab)
REFERENCES estados_laborales(id_est_lab),
CONSTRAINT fk_personas_situaciones_habitacionales FOREIGN KEY (id_sit_hab)
REFERENCES situaciones_habitacionales (id_sit_hab),
CONSTRAINT fk_personas_sexos FOREIGN KEY (id_sexo)
REFERENCES sexos(id_sexo),
CONSTRAINT fk_personas_domicilios FOREIGN KEY(id_domicilio)
REFERENCES domicilios(id_domicilio),
CONSTRAINT fk_personas_estados_civiles FOREIGN KEY (id_estado_civil)
REFERENCES estados_civiles(id_estado_civil)
);

CREATE TABLE alumnos (
legajo_alumno INT,
id_persona INT NOT NULL,
CONSTRAINT pk_alumnos PRIMARY KEY (legajo_alumno),
CONSTRAINT fk_alumnos FOREIGN KEY (id_persona)
REFERENCES personas(id_persona)
);

CREATE TABLE profesores (
legajo_profesor INT,
id_persona INT NOT NULL,
CONSTRAINT pk_profesores PRIMARY KEY (legajo_profesor),
CONSTRAINT fk_profesores FOREIGN KEY (id_persona)
REFERENCES personas(id_persona)
);

CREATE TABLE estados_alumnos (
id_estado_alumno INT IDENTITY(1,1),
estado_alumno VARCHAR(80) NOT NULL,
CONSTRAINT pk_estados_alumnos PRIMARY KEY (id_estado_alumno)
);

CREATE TABLE carreras (
id_carrera INT IDENTITY(1,1),
nom_carrera VARCHAR(120) NOT NULL,
CONSTRAINT pk_carreras PRIMARY KEY (id_carrera)
);

CREATE TABLE materias (
id_materia INT IDENTITY(1,1),
nom_materia VARCHAR(120) NOT NULL,
CONSTRAINT pk_materias PRIMARY KEY (id_materia)
);

CREATE TABLE tipos_examenes (
id_tipo_examen INT IDENTITY(1,1),
tipo_examen VARCHAR(80) NOT NULL,
CONSTRAINT pk_tipos_examenes PRIMARY KEY (id_tipo_examen)
);

CREATE TABLE examenes (
id_examen INT IDENTITY(1,1),
id_materia INT NOT NULL,
id_tipo_examen INT NOT NULL,
legajo_profesor INT NOT NULL,
fecha DATE,
CONSTRAINT pk_examenes PRIMARY KEY (id_examen),
CONSTRAINT fk_examenes_materias FOREIGN KEY (id_materia)
REFERENCES materias(id_materia),
CONSTRAINT fk_examenes_tipos_examenes FOREIGN KEY (id_tipo_examen)
REFERENCES tipos_examenes(id_tipo_examen),
CONSTRAINT fk_examenes_profesores FOREIGN KEY (legajo_profesor)
REFERENCES profesores(legajo_profesor)
);

CREATE TABLE materias_profesores (
id_materia INT NOT NULL,
legajo_profesor INT NOT NULL,
CONSTRAINT pk_materias_profesores PRIMARY KEY (id_materia, legajo_profesor),
CONSTRAINT fk_materias_profesores_materias FOREIGN KEY (id_materia)
REFERENCES materias(id_materia),
CONSTRAINT fk_materias_profesores_profesores FOREIGN KEY (legajo_profesor)
REFERENCES profesores(legajo_profesor)
);

CREATE TABLE alumnos_examenes (
legajo_alumno INT NOT NULL,
id_examen INT NOT NULL,
nota INT NOT NULL,
fecha_aprobado DATE,
CONSTRAINT pk_alumnos_examenes PRIMARY KEY (legajo_alumno, id_examen),
CONSTRAINT fk_alumnos_examenes_alumnos FOREIGN KEY (legajo_alumno)
REFERENCES alumnos(legajo_alumno),
CONSTRAINT fk_alumnos_examenes_examenes FOREIGN KEY (id_examen)
REFERENCES examenes(id_examen)
);

CREATE TABLE carreras_materias (
id_carrera_materia INT IDENTITY(1,1),
id_carrera INT NOT NULL,
id_materia INT NOT NULL,
CONSTRAINT pk_carreras_materias PRIMARY KEY (id_carrera_materia),
CONSTRAINT fk_carreras_materias_carreras FOREIGN KEY (id_carrera)
REFERENCES carreras(id_carrera),
CONSTRAINT fk_carreras_materias_materias FOREIGN KEY (id_materia)
REFERENCES materias(id_materia)
);

CREATE TABLE alumnos_carreras_materias (
legajo_alumno INT NOT NULL,
id_carrera_materia INT NOT NULL,
id_estado_alumno INT NOT NULL,
CONSTRAINT pk_alumnos_carreras_materias PRIMARY KEY (legajo_alumno, id_carrera_materia),
CONSTRAINT fk_alumnos_carreras_materias_alumnos FOREIGN KEY (legajo_alumno)
REFERENCES alumnos(legajo_alumno),
CONSTRAINT fk_alumnos_carreras_materias_carreras_materias FOREIGN KEY (id_carrera_materia)
REFERENCES carreras_materias(id_carrera_materia),
CONSTRAINT fk_alumnos_carreras_materias_estados_alumnos FOREIGN KEY (id_estado_alumno)
REFERENCES estados_alumnos(id_estado_alumno)
);

-- CARGA DE DATOS
-- Tabla tipos_doc
INSERT INTO tipos_doc(tipo)
VALUES 
	('DNI'),
	('Pasaporte'),
	('Libreta'),
	('Partida de Nacimiento'),
	('Otros');

-- Tabla provincias
INSERT INTO provincias (nom_provincia)
VALUES 
	('Buenos Aires'),
	('Capital Federal'),
	('Catamarca'),
	('Chaco'),
	('Chubut'),
	('Córdoba'),
	('Corrientes'),
	('Entre Rios'),
	('Formosa'),
	('Jujuy'),
	('La Pampa'),
	('La Rioja'),
	('Mendoza'),
	('Misiones'),
	('Neuquén'),
	('Río Negro'),
	('Salta'),
	('San Juan'),
	('San Luis'),
	('Santa Cruz'),
	('Santa Fe'),
	('Santiago del Estero'),
	('Tierra del Fuego'),
	('Tucumán');

-- Tabla localidades
INSERT INTO localidades (nom_localidad, id_provincia)
VALUES 
	('Avellaneda', 1),
	('Bahía Blanca', 1),
	('Berazategui', 1),
	('Bolívar', 1),
	('Bragado', 1),

	('Caballito', 2),
	('Flores y Parque Chacabuco', 2),
	('Villa Soldati', 2),
	('Villa Real', 2),
	('Monte Castro', 2),

	('Belén', 3),
	('Antofagasta de la Sierra', 3),
	('Corral Quemado', 3),
	('El Alto', 3),
	('El Rodeo', 3),

	('Belén', 3),
	('Antofagasta de la Sierra', 3),
	('Corral Quemado', 3),
	('El Alto', 3),
	('El Rodeo', 3),

	('Barranqueras', 4),
	('Charadai', 4),
	('Ciervo Petiso', 4),
	('Colonia Aborigen', 4),
	('El Espinillo', 4),

	('Alta Gracia', 6),
	('Arroyito', 6),
	('Bulnes', 6),
	('Colonia Caroya', 6),
	('Córdoba', 6),

	('La Paz', 13),
	('Las Heras', 13),
	('Mendoza', 13),
	('Rivadavia', 13),
	('Villa Tulumaya', 13),

	('Bella Vista', 24),
	('Concepción', 24),
	('Graneros', 24),
	('Las Talitas', 24),
	('Trancas', 24);

-- Tabla Barrios
INSERT INTO barrios (nom_barrio, id_localidad)
VALUES
	('Agronomía', 1),
	('Almagro', 1),
	('Balvanera', 1),
	('Barracas', 1),
	('Belgrano', 1),
	('Barrio Alberdi', 2),
	('Barrio Bajada San Roque', 2),
	('Barrio Bella Vista', 2),
	('Barrio Centro', 2),
	('Barrio Cupani', 2),
	('Barrio Cáceres', 3),
	('Barrio Ducasse', 3),
	('Barrio Güemes', 3),
	('Barrio Nueva Córdoba', 3),
	('Barrio Observatorio', 3),
	('Barrio Parque Sarmiento', 4),
	('Barrio Paso de los Andes', 4),
	('Barrio Providencia', 4),
	('Barrio Alta Córdoba', 4),
	('Barrio Ayacucho', 4),
	('Barrio Cofico', 6),
	('Barrio General Bustos', 6),
	('Barrio Residencial América', 6),
	('Barrio Ampliación Panamericano', 6),
	('Barrio Ampliación Residencial América', 6),
	('Barrio Centro América', 13),
	('Barrio Hipólito Yrigoyen', 13),
	('Barrio Juan B. Justo', 13),
	('Barrio Los Gigantes', 13),
	('Barrio Los Álamos', 13),
	('Barrio Marcelo T. de Alvear', 24),
	('Barrio Villa Azalais Oeste', 24),
	('Barrio Parque Jorge Newbery', 24),
	('Barrio Villa Retiro', 24),
	('Barrio Villa Esquiú', 24),
	('Barrio Cerro de las Rosas', 24);

-- Tabla domicilios
INSERT INTO domicilios (calle, nro, piso, departamento, id_barrio)
VALUES
	('Consejal Cabiche', 1431, NULL, NULL, 20),
	('Mancha y Velazco', 810, NULL, NULL, 20),
	('Obispo Carranza', 710, NULL, NULL, 20),
	('Obispo Aresti', 1560, NULL, NULL, 20),
	('Francisco Recalde', 245, NULL, NULL, 20),
	('Alvarez de las Casas', 2010, NULL, NULL, 20),
	('Francisco de Toledo', 774, NULL, NULL, 20),
	('Medellin', 948, NULL, NULL, 23),
	('Guayaquil', 2100, NULL, NULL, 23),
	('Puerto de Palos', 900, NULL, NULL, 23),
	('Paysandu', 1051, NULL, NULL, 23),
	('Managua', 874, NULL, NULL, 23),
	('Av Nuevo Mundo', 1035, NULL, NULL, 23),
	('Tarija', 890, NULL, NULL, 23),
	('Juan Antonio Lavalleja', 1351, 3, 'D', 19),
	('Juan Antonio Lavalleja', 1351, 4, 'D', 19),
	('Juan Antonio Lavalleja', 1351, 3, 'C', 19),
	('Lope de Vega', 857, NULL, NULL, 19),
	('Mariano Fragueiro', 1750, NULL, NULL, 19),
	('Jose de Urquiza', 1200, NULL, NULL, 19),
	('Av General Paz', 700, 12, 'C', 9),
	('27 de Abril', 850, 8, 'A', 9),
	('Av Colon', 200, 1, 'D', 9),
	('Buenos Aires', 455, 4, 'G', 9),
	('Caseros', 310, NULL, NULL, 9),
	('Av Velez Sarfield', 800, 2, 'A', 9),
	('Entre Rios', 900, 5, 'C', 9),
	('Corrientes', 1250, 3, 'F', 9),
	('25 de Mayo', 315, NULL, NULL, 9),
	('Calle del Riego', 45, NULL, NULL, 34),
	('Amalia Celia Figueredo de Pietra', 35, NULL, NULL, 34),
	('Av Rancagua', 7000, NULL, NULL, 34),
	('Diaz de la Peña', 764, NULL, NULL, 36),
	('Gregorio Velez', 780, NULL, NULL, 36),
	('Av Rafael Nuñez', 1670, NULL, NULL, 36),
	('Emilio Pettoruti', 800, NULL, NULL, 36),
	('Roque Ferreyra', 1500, NULL, NULL, 36),
	('Virrey del Pino', 3500, NULL, NULL, 36);

-- Tabla sexos
INSERT INTO sexos (sexo)
VALUES 
	('Masculino'),
	('Femenino'),
	('No Binario')

-- Tabla estados_laborales
INSERT INTO estados_laborales(estado_laboral)
VALUES 
	('Desempleado'),
	('Empleado Medio Tiempo'),
	('Empleado Tiempo Completo'),
	('Empleado Irregular o en Negro')

-- Tabla situaciones_habitacionales
INSERT INTO situaciones_habitacionales (situacion_habitacional)
VALUES
	('Excelente'),
	('Muy buena'),
	('Buena'),
	('Regular'),
	('Satifactoria'),
	('No Satifactoria')

-- Tabla estados_civiles
INSERT INTO estados_civiles (estado_civil)
VALUES 
	('Soltero(a)'),
	('Casado(a)'),
	('Conviviente'),
	('Anulado(a)'),
	('Separado de unión legal'),
	('Separado(a) de unión de hecho'),
	('Viudo(a)')

-- Tabla personas
SET DATEFORMAT dmy
INSERT INTO personas(nom_persona, ape_persona, id_tipo_doc, nro_doc, id_est_lab, id_sit_hab,fecha_ingreso, fecha_nac, telefono, id_sexo, email, id_domicilio, id_estado_civil)
VALUES
	('Jerome','Cochran',4,36270877,NULL,5,'02/03/2011','08/03/1970','923-4466',3,NULL,1,6),
	('Ivor','Morrison',2,42531196,2,NULL,'30/01/1996','18/06/1984','571-6048',3,'lectus.a@disparturient.org',2,3),
	('Richard','Zimmerman',2,36553374,4,3,'19/05/1995','28/12/1979','1-275-489-0214',1,'ipsum.nunc@incondimentumdonec.net',3,4),
	('Celeste','Parsons',2,29455342,2,6,'28/12/1982','13/06/1988','1-406-734-8323',2,'pharetra.sed@consectetueradipiscing.net',4,5),
	('Heather','Castro',1,39438779,3,4,'26/12/2005','20/08/1976',NULL,1,NULL,5,4),
	('Holmes','Whitehead',1,34535548,1,1,'22/05/1974','05/06/1996',NULL,2,NULL,6,2),
	('Kylan','Cohen',3,27857053,4,1,'10/06/2022','27/06/2000','1-173-961-5892',2,NULL,7,2),
	('Mercedes','Rivera',3,48146902,3,2,'04/12/1991','15/07/2004',NULL,2,'nisi@namconsequat.net',8,5),
	('Dillon','Noel',2,35067799,3,5,'17/07/2002','15/11/1996','1-806-830-7304',2,'consectetuer@ipsumdonec.edu',9,6),
	('Chaney','Hopkins',2,41129715,NULL,NULL,'14/01/2009','23/12/1985','1-120-891-1752',1,'ipsum.suspendisse@pharetrafeliseget.ca',10,5),
	('Alec','Fox',2,31564091,4,5,'01/03/2021','12/08/1998','769-8268',2,'pharetra@purusmaecenaslibero.net',11,4),
	('Quemby','Spencer',5,47477825,3,1,'18/08/1991','30/11/1991','742-3239',3,'non@necquam.com',12,4),
	('Xanthus','Vargas',3,28152919,NULL,1,'25/03/1986','24/08/1970','1-410-647-5140',3,'massa.rutrum@etiam.co.uk',13,6),
	('Shafira','Simon',2,42296965,3,2,'01/12/1976','26/04/1986','228-7921',3,NULL,14,4),
	('Fletcher','Fowler',4,40292108,NULL,5,'05/07/1980','19/01/1988','544-2538',2,NULL,15,3),
	('Troy','Blair',4,37793766,3,2,'10/11/1975','12/09/1982','786-0328',1,'faucibus@lacusquisqueimperdiet.co.uk',16,3),
	('Melinda','Jarvis',5,28672873,NULL,4,'07/03/1987','14/06/1986','971-9888',2,'massa@blanditcongue.edu',17,3),
	('Buckminster','Huber',4,30784860,3,NULL,'03/09/2006','09/10/2002','1-353-707-2968',2,'rhoncus.id.mollis@mauris.edu',18,6),
	('Callie','Wolf',5,49186707,3,4,'21/01/2003','30/11/1998','1-162-725-4565',2,'purus.maecenas@nonummy.org',19,3),
	('Ruth','Rice',5,21138969,3,5,'16/05/1975','25/09/1991',NULL,2,'mollis.lectus@egestasfuscealiquet.edu',20,5),
	('Channing','Moody',2,38837859,3,3,'22/02/1998','15/11/1981','466-5424',3,'non.egestas.a@elitpharetra.edu',21,2),
	('Mason','Mcclain',5,32239226,2,2,'21/02/1999','19/06/1987','1-836-339-7482',3,'tellus.imperdiet@aliquet.com',22,4),
	('Kermit','Norris',1,24894718,2,4,'10/01/1974','18/07/1994','375-8268',3,NULL,23,4),
	('Ferris','Knapp',5,49906843,2,3,'27/04/1982','31/05/2004','124-8923',1,NULL,24,3),
	('Libby','Gomez',3,26117953,3,4,'05/03/2010','07/03/1990','482-1342',2,'sed.molestie@utmi.co.uk',25,2),
	('Maxwell','Cole',3,33313838,NULL,NULL,'15/09/1981','03/02/1996','542-2225',3,'donec@nonduinec.ca',26,3),
	('Thaddeus','Vargas',1,47961820,1,4,'11/12/1998','29/04/2001','187-6715',3,NULL,27,5),
	('Imani','Barnes',4,27099922,1,3,'28/11/2009','20/08/2002','1-387-437-5822',2,'condimentum.donec.at@atlibero.com',28,5),
	('Gareth','Randolph',5,38208958,2,3,'29/07/2018','03/01/1976','1-738-543-8725',1,'nunc@tempusrisusdonec.org',29,7),
	('Elaine','Medina',3,28601076,4,3,'03/03/1980','09/07/1987','736-3435',2,'donec.felis@lectus.edu',30,3),
	('Giacomo','Vasquez',3,34936243,2,5,'07/04/1991','27/04/1973','1-863-457-4338',2,'libero@dictumphasellusin.co.uk',31,5),
	('Brenden','Bruce',1,37661106,3,4,'21/11/1979','19/06/1991','377-1293',2,'ut.semper@estvitaesodales.ca',32,1),
	('Yetta','Garcia',3,29906180,1,NULL,'18/02/1977','03/06/1997','676-6754',2,NULL,33,7),
	('Jason','Mullins',1,22845952,NULL,3,'27/05/1976','03/11/1982','631-4463',1,NULL,34,2),
	('Marsden','Talley',4,31189692,NULL,4,'21/07/2008','30/06/1973',NULL,2,'a.auctor.non@blandit.net',35,5),
	('Nicole','Wagner',1,49349516,1,2,'23/10/2002','28/05/1971',NULL,3,'rutrum.justo.praesent@auctormauris.edu',36,6),
	('Sigourney','Gill',3,39287637,4,5,'06/12/1978','01/03/1997','961-8494',2,NULL,37,4),
	('Sheila','Shaffer',2,28631174,3,NULL,'26/09/2010','26/04/1992','1-863-277-5781',3,NULL,38,4)

-- Tabla alumnos
INSERT INTO alumnos (legajo_alumno, id_persona)
VALUES
	(111,9),
	(222,10),
	(333,11),
	(444,12),
	(555,13),
	(666,14),
	(777,15),
	(888,16),
	(999,17),
	(112,18),
	(292,19),
	(332,20),
	(442,21),
	(552,22),
	(662,23),
	(772,24),
	(882,25),
	(992,26),
	(113,27),
	(223,28),
	(3321,29),
	(443,30),
	(553,31),
	(663,32),
	(773,33),
	(883,34),
	(993,35),
	(114,36),
	(224,37),
	(334,38)

-- Tabla profesores
INSERT INTO profesores(legajo_profesor, id_persona)
VALUES
	(1000,1),
	(2000,2),
	(3000,3),
	(4000,4),
	(5000,5),
	(6000,6),
	(7000,7),
	(8000,8)

-- Tabla carreras
INSERT INTO carreras (nom_carrera)
VALUES
	('Programacion'),
	('Industrias Alimentarias'),
	('Mecatronica'),
	('Mantenimiento Industrial'),
	('Moldes Matrices y Dispositivos')

-- Tabla materias
INSERT INTO materias (nom_materia)
VALUES
	('Programacion I'),
	('Sistemas de Procesamiento de Datos'),
	('Matematica'),
	('Ingles I'),
	('Laboratorio de Computacion I'),
	('Programación II (Integradora)'),
	('Arquitectura y Sistemas Operativos'),
	('Estadística'),
	('Inglés II'),
	('Laboratorio de Computación II'),
	('Metodología de la Investigación'),
	('Programación III (Integradora)'),
	('Organización Contable de la Empresa'),
	('Organización Empresarial'),
	('Elementos de Investigación Operativa'),
	('Laboratorio de Computación III'),
	('Metodología de Sistemas I'),
	('Diseño y Administración de Bases de Datos (Integradora)'),
	('Legislación'),
	('Laboratorio de Computación IV'),
	('Práctica Profesional'),
	('Industrias Alimentarias I (anual)'),
	('Biología General'),
	('Química General'),
	('Física'),
	('Química Analítica'),
	('Química Inorgánica'),
	('Industrias Alimentarias II'),
	('Legislación Sanitaria'),
	('Microbiología de los Alimentos'),
	('Química Orgánica'),
	('Economía'),
	('Bromatología'),
	('Mecatronica I'),
	('Herramientas Informáticas'),
	('Sistemas CAD'),
	('Materiales'),
	('Electrotecnia I'),
	('Sistemas Digitales'),
	('Mecatronica II'),
	('Mecánica I'),
	('Mantenimiento Industrial'),
	('Electronica'),
	('Electrotecnia II'),
	('Mecánica II'),
	('Tecnología de la Fabricación'),
	('Gestión de la Calidad y Metrología'),
	('Pasantía en Entes Oficiales o Empresas'),
	('Seminarios'),
	('Mantenimiento Industrial I'),
	('Relaciones Industriales'),
	('Informática I'),
	('Electrotecnia'),
	('Sistema de Representación'),
	('Conocimientos de los materiales'),
	('Neumática e Hidráulica'),
	('Mantenimiento Industrial II'),
	('Informática II'),
	('Elementos de Automatización'),
	('Ingles'),
	('Elementos de Máquinas'),
	('Tecnología de Frío y Calor'),
	('Instalaciones y Máquinas Eléctricas'),
	('Seguridad Higiene y Protección Ambiental'),
	('Costos y Control de Gestión'),
	('Aseguramiento de la Calidad'),
	('Tecnología en Medios de Producción I'),
	('Dispositivos y Utilajes'),
	('Conocimiento de Materiales'),
	('Tecnología en Medios de Producción II'),
	('Mantenimiento'),
	('Inyección y Fundición'),
	('Mecanizado'),
	('Tecnología del Estampado'),
	('Automación Industrial'),
	('Practica Supervisada')

-- Tabla carreras_materias
INSERT INTO carreras_materias (id_carrera, id_materia)
VALUES
	(1,6),
	(1,2),
	(1,3),
	(1,4),
	(1,5),
	(1,6),
	(1,7),
	(1,8),
	(1,9),
	(1,10),
	(1,11),
	(1,12),
	(1,13),
	(1,14),
	(1,15),
	(1,16),
	(1,17),
	(1,18),
	(1,19),
	(1,20),
	(1,21),
	(2,22),
	(2,23),
	(2,3),
	(2,24),
	(2,25),
	(2,26),
	(2,27),
	(2,28),
	(2,29),
	(2,30),
	(2,31),
	(2,32),
	(2,8),
	(2,33),
	(2,76),
	(3,34),
	(3,25),
	(3,3),
	(3,60),
	(3,35),
	(3,36),
	(3,37),
	(3,38),
	(3,39),
	(3,40),
	(3,41),
	(3,42),
	(3,43),
	(3,44),
	(3,45),
	(3,46),
	(3,75),
	(3,47),
	(3,48),
	(3,49),
	(4,50),
	(4,53),
	(4,3),
	(4,24),
	(4,51),
	(4,52),
	(4,50),
	(4,53),
	(4,45),
	(4,54),
	(4,69),
	(4,56),
	(4,57),
	(4,61),
	(4,62),
	(4,63),
	(4,58),
	(4,59),
	(4,60),
	(4,57),
	(4,61),
	(4,62),
	(4,63),
	(4,64),
	(4,65),
	(4,66),
	(4,76),
	(4,48),
	(5,67),
	(5,68),
	(5,3),
	(5,25),
	(5,51),
	(5,52),
	(5,41),
	(5,54),
	(5,69),
	(5,60),
	(5,70),
	(5,58),
	(5,71),
	(5,45),
	(5,47),
	(5,72),
	(5,73),
	(5,74),
	(5,75),
	(5,64),
	(5,76)

--Tabla materias_profesores
INSERT INTO materias_profesores (id_materia, legajo_profesor)
VALUES
	(1,3000),
	(2,5000),
	(3,1000),
	(4,7000),
	(5,1000),
	(6,2000),
	(7,4000),
	(8,2000),
	(9,2000),
	(10,3000),

	(11,1000),
	(12,5000),
	(13,6000),
	(14,6000),
	(15,8000),
	(16,5000),
	(17,8000),
	(18,2000),
	(19,1000),
	(20,1000),

	(21,4000),
	(22,5000),
	(23,5000),
	(24,1000),
	(25,7000),
	(26,3000),
	(27,2000),
	(28,1000),
	(29,8000),
	(30,2000),

	(31,4000),
	(32,7000),
	(33,6000),
	(34,4000),
	(35,1000),
	(36,8000),
	(37,8000),
	(38,8000),
	(39,1000),
	(40,3000),

	(41,1000),
	(42,6000),
	(43,4000),
	(44,2000),
	(45,7000),
	(46,7000),
	(47,8000),
	(48,3000),
	(49,6000),
	(50,8000),

	(51,2000),
	(52,2000),
	(53,3000),
	(54,7000),
	(55,6000),
	(56,3000),
	(57,3000),
	(58,2000),
	(59,1000),
	(60,7000),

	(61,3000),
	(62,2000),
	(63,5000),
	(64,5000),
	(65,3000),
	(66,6000),
	(67,1000),
	(68,1000),
	(69,2000),
	(70,7000),

	(71,1000),
	(72,2000),
	(73,2000),
	(74,3000),
	(75,8000),
	(76,4000)

-- Tabla tipos_examenes
INSERT INTO tipos_examenes(tipo_examen)
VALUES 
	('Parcial 1'),
	('Parcial 2'),
	('Examen Final')

select * from tipos_examenes

-- Tabla estados_alumnos
INSERT INTO estados_alumnos(estado_alumno)
VALUES 
	('Regular'),
	('Libre'),
	('Aprobado')

-- Tabla alumnos_carreras_materias


INSERT INTO alumnos_carreras_materias(legajo_alumno, id_carrera_materia, id_estado_alumno)
VALUES 
	(111, 2, 1),
	(111, 3, 2),
	(111, 4, 2),
	(111, 5, 1),

	(112, 1, 2),
	(112, 2, 1),
	(112, 3, 2),
	(112, 4, 1),

	(113, 1, 1),
	(113, 2, 1),
	(113, 3, 2),
	(113, 4, 2),
	(113, 5, 1),

	(114, 25, 1),
	(114, 24, 1),
	(114, 23, 2),
	(114, 22, 2),

	(222, 5, 3),
	(222, 3, 3),

	(222, 9, 1),
	(222, 8, 1),
	(222, 7, 1),
	(222, 6, 2),
	(222, 10,1),
	(222, 11, 2),

	(223, 6, 2),
	(223, 7, 2),
	(223, 8, 1),
	(223, 9, 2),
	(223, 10,1),
	(223, 11, 2),

	(224, 37, 1),
	(224, 38, 1),
	(224, 39, 2),
	(224, 40, 2),
	(224, 41, 1),

	(292, 6, 2),
	(292, 7, 1),
	(292, 8, 2),
	(292, 9, 2),
	(292, 10, 1),

	(332, 100, 1),
	(332, 101, 1),
	(332, 102, 1),
	(332, 103, 2),
	(332, 104, 1),

	(333, 12, 2),
	(333, 13, 1),
	(333, 14, 1),
	(333, 15, 2),
	(333, 16, 1),

	(334, 12, 1),
	(334, 13, 1),
	(334, 14, 2),
	(334, 15, 2),
	(334, 16, 2),

	(442, 17, 1),
	(442, 18, 1),
	(442, 19, 1),
	(442, 20, 1),
	(442, 21, 1),

	(443, 17, 2),
	(443, 18, 1),
	(443, 19, 2),
	(443, 20, 1),
	(443, 21, 1),

	(444, 52, 1),
	(444, 53, 1),
	(444, 54, 1),
	(444, 55, 1),
	(444, 56, 2),

	(552, 85, 2),
	(552, 86, 2),
	(552, 87, 1),
	(552, 88, 1),
	(552, 89, 2),

	(553, 12, 1),
	(553, 13, 2),
	(553, 14, 2),
	(553, 15, 2),
	(553, 16, 2),

	(555, 12, 1),
	(555, 13, 1),
	(555, 14, 1),
	(555, 15, 2),
	(555, 16, 2),

	(662, 17, 1),
	(662, 18, 1),
	(662, 19, 1),
	(662, 20, 2),
	(662, 21, 2),

	(663, 2, 1),
	(663, 3, 1),
	(663, 4, 2),
	(663, 5, 2),
	(663, 6, 2),

	(666, 6, 2),
	(666, 7, 1),
	(666, 8, 1),
	(666, 9, 1),
	(666, 19, 1),

	(772, 17, 1),
	(772, 18, 1),
	(772, 19, 2),
	(772, 20, 2),
	(772, 21, 1),

	(773, 17, 2),
	(773, 18, 1),
	(773, 19, 1),
	(773, 20, 1),
	(773, 21, 2),


	(777, 2, 2),
	(777, 3, 2),
	(777, 4, 1),
	(777, 5, 1),

	(882, 32, 1),
	(882, 33, 1),
	(882, 34, 1),
	(882, 35, 1),

	(883, 57, 1),
	(883, 58, 1),
	(883, 59, 2),
	(883, 60, 1),

	(888, 96, 1),
	(888, 95, 2),
	(888, 97, 2),
	(888, 98, 1),

	(992, 85, 2),
	(992, 86, 2),
	(992, 87, 1),
	(992, 88, 1),
	(992, 89, 2),

	(993, 70, 1),
	(993, 71, 1),
	(993, 72, 1),
	(993, 73, 1),
	(993, 74, 2),

	(999, 22, 2),
	(999, 23, 1),
	(999, 24, 2),
	(999, 25, 1),
	(999, 26, 2),

	(3321, 11, 2),
	(3321, 12, 1),
	(3321, 13, 2),
	(3321, 14, 1),
	(3321, 15, 1)

-- Tabla examenes
SET DATEFORMAT dmy
INSERT INTO examenes(id_materia, id_tipo_examen, legajo_profesor, fecha)
VALUES 
	(1, 3, 3000, '27/07/2021'),
	(1, 3, 3000, '07/07/2021'),
	(1, 3, 3000, '11/12/2020'),
	(1, 3, 3000, '22/12/2020'),
	(1, 3, 3000, '13/07/2020'),
	(1, 3, 3000, '02/07/2020'),
	(1, 3, 3000, '10/02/2020'),
	(1, 3, 3000, '24/02/2020'),

	(1, 3, 3000, '15/12/2019'),
	(1, 3, 3000, '20/12/2019'),
	(1, 3, 3000, '11/07/2019'),
	(1, 3, 3000, '05/07/2019'),
	(1, 3, 3000, '17/02/2019'),
	(1, 3, 3000, '27/02/2019'),

	(1, 3, 3000, '5/12/2018'),
	(1, 3, 3000, '18/12/2018'),
	(1, 3, 3000, '16/07/2018'),
	(1, 3, 3000, '05/07/2018'),
	(1, 3, 3000, '05/02/2018'),
	(1, 3, 3000, '27/02/2018'),

	--

	(2, 3, 5000, '28/07/2021'),
	(2, 3, 5000, '12/07/2021'),

	(2, 3, 5000, '02/12/2020'),
	(2, 3, 5000, '19/12/2020'),

	(2, 3, 5000, '17/07/2019'),
	(2, 3, 5000, '28/07/2019'),
	(2, 3, 5000, '02/02/2019'),
	(2, 3, 5000, '27/02/2019'),

	(2, 3, 5000, '03/12/2018'),
	(2, 3, 5000, '17/12/2018'),
	(2, 3, 5000, '07/07/2018'),
	(2, 3, 5000, '22/07/2018'),
	(2, 3, 5000, '01/02/2018'),
	(2, 3, 5000, '27/02/2018'),

	(2, 3, 5000, '04/12/2017'),
	(2, 3, 5000, '17/12/2017'),
	(2, 3, 5000, '07/07/2017'),
	(2, 3, 5000, '19/07/2017'),
	(2, 3, 5000, '05/02/2017'),
	(2, 3, 5000, '20/02/2017'),

	--
	(3, 3, 1000, '08/07/2021'),
	(3, 3, 1000, '21/07/2021'),


	(3, 3, 1000, '08/02/2020'),
	(3, 3, 1000, '20/02/2020'),
	(3, 3, 1000, '10/07/2020'),
	(3, 3, 1000, '21/07/2020'),
	(3, 3, 1000, '08/12/2020'),
	(3, 3, 1000, '19/12/2020'),


	(3, 3, 1000, '03/02/2019'),
	(3, 3, 1000, '28/02/2019'),
	(3, 3, 1000, '01/07/2019'),
	(3, 3, 1000, '30/07/2019'),
	(3, 3, 1000, '04/12/2019'),
	(3, 3, 1000, '18/12/2019'),


	(3, 3, 1000, '03/02/2018'),
	(3, 3, 1000, '28/02/2018'),
	(3, 3, 1000, '01/07/2018'),
	(3, 3, 1000, '30/07/2018'),
	(3, 3, 1000, '04/12/2018'),
	(3, 3, 1000, '18/12/2018'),

--
	(4,3,7000,'10/12/20'),
	(4,3,7000,'18/12/20'),
	(5,3,1000,'10/12/20'),
	(5,3,1000,'02/12/20'),
	(6,3,2000,'05/12/20'),
	(6,3,2000,'10/12/20'),
	(7,3,4000,'12/12/20'),

	(7,3,4000,'17/12/20'),
	(8,3,2000,'11/12/20'),
	(8,3,2000,'05/12/20'),
	(9,3,2000,'09/12/20'),
	(9,3,2000,'13/12/20'),
	(10,3,3000,'03/12/20'),
	(10,3,3000,'17/12/20'),
  
	(11,3,1000,'08/12/20'),
	(11,3,1000,'02/12/20'),
	(12,3,5000,'02/12/20'),
  
	(12,3,5000,'13/12/20'),
	(13,3,6000,'22/12/20'),
  
	(13,3,6000,'06/12/20'),

	(14,3,6000,'21/12/20'),
 
	(14,3,6000,'04/12/20'),
	(15,3,8000,'05/12/20'),
	(15,3,8000,'19/12/20'),

	(16,3,5000,'17/12/20'),
  
	(16,3,5000,'04/12/20'),
 
	(17,3,8000,'21/12/20'),
	(17,3,8000,'06/12/20'),
  
	(18,3,2000,'10/12/20'),
	(18,3,2000,'14/12/20'),
	(19,3,1000,'22/12/20'),
	(19,3,1000,'12/12/20'),
 
	(20,3,1000,'09/12/20'),
	(20,3,1000,'21/12/20'),

	(21,3,4000,'12/12/20'),
	(21,3,4000,'21/12/20'),
 
	--
	(4,3,7000,'10/07/20'),
	(4,3,7000,'18/07/20'),
	(5,3,1000,'10/07/20'),
	(5,3,1000,'02/07/20'),
	(6,3,2000,'05/07/20'),
	(6,3,2000,'10/07/20'),
	(7,3,4000,'12/07/20'),

	(7,3,4000,'17/07/20'),
	(8,3,2000,'11/07/20'),
	(8,3,2000,'05/07/20'),
	(9,3,2000,'09/07/20'),
	(9,3,2000,'13/07/20'),
	(10,3,3000,'03/07/20'),
	(10,3,3000,'17/07/20'),
  
	(11,3,1000,'08/07/20'),
	(11,3,1000,'02/07/20'),
	(12,3,5000,'02/07/20'),
  
	(12,3,5000,'13/07/20'),
	(13,3,6000,'22/07/20'),
  
	(13,3,6000,'06/07/20'),

	(14,3,6000,'21/07/20'),
 
	(14,3,6000,'04/07/20'),
	(15,3,8000,'05/07/20'),
	(15,3,8000,'19/07/20'),

	(16,3,5000,'17/07/20'),
  
	(16,3,5000,'04/07/20'),
 
	(17,3,8000,'21/07/20'),
	(17,3,8000,'06/07/20'),
  
	(18,3,2000,'10/07/20'),
	(18,3,2000,'14/07/20'),
	(19,3,1000,'22/07/20'),
	(19,3,1000,'12/07/20'),
 
	(20,3,1000,'09/07/20'),
	(20,3,1000,'21/07/20'),

	(21,3,4000,'12/07/20'),
	(21,3,4000,'21/07/20'),

	--
	(4,3,7000,'10/07/19'),
	(4,3,7000,'18/07/19'),
	(5,3,1000,'10/07/19'),
	(5,3,1000,'02/07/19'),
	(6,3,2000,'05/07/19'),
	(6,3,2000,'10/07/19'),
	(7,3,4000,'12/07/19'),

	(7,3,4000,'17/07/19'),
	(8,3,2000,'11/07/19'),
	(8,3,2000,'05/07/19'),
	(9,3,2000,'09/07/19'),
	(9,3,2000,'13/07/19'),
	(10,3,3000,'03/07/19'),
	(10,3,3000,'17/07/19'),
  
	(11,3,1000,'08/07/19'),
	(11,3,1000,'02/07/19'),
	(12,3,5000,'02/07/19'),
  
	(12,3,5000,'13/07/19'),
	(13,3,6000,'22/07/19'),
  
	(13,3,6000,'06/07/19'),

	(14,3,6000,'21/07/19'),
 
	(14,3,6000,'04/07/19'),
	(15,3,8000,'05/07/19'),
	(15,3,8000,'19/07/19'),

	(16,3,5000,'17/07/19'),
  
	(16,3,5000,'04/07/19'),
 
	(17,3,8000,'21/07/19'),
	(17,3,8000,'06/07/19'),
  
	(18,3,2000,'10/07/19'),
	(18,3,2000,'14/07/19'),
	(19,3,1000,'22/07/19'),
	(19,3,1000,'12/07/19'),
 
	(20,3,1000,'09/07/19'),
	(20,3,1000,'21/07/19'),

	(21,3,4000,'12/07/19'),
	(21,3,4000,'21/07/19')
  
-- Tabla alumnos_carreras_materias - parte 2
--19/10/2021
INSERT INTO alumnos_carreras_materias(legajo_alumno, id_carrera_materia, id_estado_alumno)
VALUES 
	(223, 2, 3),
	(223, 3, 3),
	(223, 4, 3),
	(223, 5, 3),

	(292, 2, 3),
	(292, 3, 3),
	(292, 4, 3),
	(292, 5, 3),

	(333, 2, 3),
	(333, 3, 3),
	(333, 4, 3),
	(333, 5, 3),

	(333, 6, 3),
	(333, 7, 3),
	(333, 8, 3),
	(333, 9, 3),

	(334, 2, 3),
	(334, 3, 3),
	(334, 4, 3),
	(334, 5, 3),

	(334, 6, 3),
	(334, 7, 3),
	(334, 8, 3),
	(334, 9, 3),

	(442, 2, 3),
	(442, 3, 3),
	(442, 4, 3),
	(442, 5, 3),

	(442, 6, 3),
	(442, 7, 3),
	(442, 8, 3),
	(442, 9, 3),

	(442, 10, 3),
	(442, 11, 3),
	(442, 12, 3),
	(442, 13, 3),
	(442, 14, 3),

	(443, 2, 3),
	(443, 3, 3),
	(443, 4, 3),
	(443, 5, 3),

	(443, 6, 3),
	(443, 7, 3),
	(443, 8, 3),
	(443, 9, 3),

	(443, 10, 3),
	(443, 11, 3),
	(443, 12, 3),
	(443, 13, 3),
	(443, 14, 3),

	(553, 2, 3),
	(553, 3, 3),
	(553, 4, 3),
	(553, 5, 3),

	(553, 6, 3),
	(553, 7, 3),
	(553, 8, 3),
	(553, 9, 3),

	(555, 2, 3),
	(555, 3, 3),
	(555, 4, 3),
	(555, 5, 3),

	(555, 6, 3),
	(555, 7, 3),
	(555, 8, 3),
	(555, 9, 3),

	(662, 2, 3),
	(662, 3, 3),
	(662, 4, 3),
	(662, 5, 3),

	(662, 6, 3),
	(662, 7, 3),
	(662, 8, 3),
	(662, 9, 3),

	(662, 10, 2),
	(662, 11, 3),
	(662, 12, 2),
	(662, 13, 3),

	(666, 2, 2),
	(666, 3, 3),
	(666, 4, 3),
	(666, 5, 3),

	(772, 2, 3),
	(772, 3, 3),
	(772, 4, 3),
	(772, 5, 3),

	(772, 6, 3),
	(772, 7, 3),
	(772, 8, 3),
	(772, 9, 3),

	(772, 10, 1),
	(772, 11, 2),
	(772, 12, 2),
	(772, 13, 2),
	(772, 14, 2),

	(773, 2, 3),
	(773, 3, 3),
	(773, 4, 3),
	(773, 5, 2),

	(773, 6, 3),
	(773, 7, 2),
	(773, 8, 3),
	(773, 9, 2),

	(773, 10, 1),
	(773, 11, 2),
	(773, 12, 2),
	(773, 13, 2),
	(773, 14, 2),

	(3321, 2, 3),
	(3321, 3, 3),
	(3321, 4, 3),
	(3321, 5, 3),

	(3321, 6, 3),
	(3321, 7, 2),
	(3321, 8, 3),
	(3321, 9, 2)

INSERT INTO alumnos_examenes(legajo_alumno, id_examen, nota, fecha_aprobado)
VALUES
	(222, 48, 8, '10/07/2020'),
	(222, 67, 7, '02/12/2020'),
	(223, 27, 7, '19/12/2020'),
	(223, 50, 8, '08/12/2020'),
	(223, 64, 9, '10/12/2020'),
	(223, 66, 6, '10/12/2020'),

	(292, 26, 9, '02/12/2020'),
	(292, 49, 9, '21/07/2020'),
	(292, 64, 7, '10/12/2020'),
	(292, 66, 7, '10/12/2020'),

	(333, 27, 6, '19/12/2020'),
	(333, 48, 8, '10/07/2020'),
	(333, 65, 8, '18/12/2020'),
	(333, 66, 6, '10/12/2020')

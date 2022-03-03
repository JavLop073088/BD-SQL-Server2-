select * from situaciones_habitacionales
SET DATEFORMAT DMY
select * from examenes
select * from barrios
select * from localidades
select * from provincias

/*Un SP que liste cantidad de materias aprobadas y promedio general de notas de examenes finales,
de aquellos alumnos (nombre apellido y legajo) que presentan situacion habitacional regular, Satisfactoria o No satisfactoria;
de la provincia de Córdoba, y cuyo promedio es mayor o igual a 6,
del año que se pase por parametro, en caso de parametro incorrecto devolver mensaje que especifique error.
*/
CREATE PROCEDURE Estado_SitHab_Anual
	@AÑO int null
AS
BEGIN
	IF EXISTS (SELECT message_id FROM sys.messages WHERE message_id = 58000)
		EXECUTE SP_DROPMESSAGE 58000
	
	EXECUTE SP_ADDMESSAGE @msgnum = 58000, 
							@severity = 16, 
							@msgtext = 'Debe Ingresar un Número Entero Referente a un AÑO Calendario'

	IF(@AÑO is null)
		RAISERROR(58000, 16, 1) 
	ELSE
		SELECT CONVERT(nvarchar(10),A.legajo_alumno)+' | '+P.nom_persona+', '+P.ape_persona AS 'ALUMNO',
				H.situacion_habitacional AS 'SIT. HAB.',
				COUNT(nota) AS 'Cant. Aprobadas',
				AVG(nota) AS 'Promedio Grl.'
			FROM alumnos A
			INNER JOIN personas P ON A.id_persona = P.id_persona
			INNER JOIN situaciones_habitacionales H ON P.id_sit_hab = H.id_sit_hab
			INNER JOIN domicilios D ON P.id_domicilio = D.id_domicilio
			INNER JOIN barrios B ON D.id_barrio = B.id_barrio
			INNER JOIN localidades L ON B.id_localidad = L.id_localidad
			INNER JOIN provincias PR ON L.id_provincia = PR.id_provincia
			INNER JOIN alumnos_examenes AE ON A.legajo_alumno = AE.legajo_alumno
			INNER JOIN examenes E ON AE.id_examen = E.id_examen
			INNER JOIN materias M ON E.id_materia = M.id_materia
			WHERE (H.id_sit_hab IN (4, 5 ,6)) 
			AND (nom_provincia = 'Buenos Aires')
			AND (nota >= 6)
			AND (YEAR(fecha) = @AÑO)
			GROUP BY CONVERT(nvarchar(10),A.legajo_alumno)+' | '+P.nom_persona+', '+P.ape_persona, H.situacion_habitacional
			HAVING AVG(nota) > 6
END

---Bloque de Ejecución-------------------------
EXECUTE Estado_SitHab_Anual 2020
EXECUTE Estado_SitHab_Anual 2019
EXECUTE Estado_SitHab_Anual NULL


/*Cree un SP donde se envíe la edad mínima por parámetro que muestre la cantidad total de Alumnos,
por edades de los alumnos. Ordenar por edad en forma ascendente. 
Mostrar error si la fecha ingresada es null.*/

CREATE PROCEDURE consulta1
@edadMin INT NULL
AS
	IF(@edadMin IS NULL)
		RAISERROR(57000, 16, 1)
	ELSE
		SELECT
			DATEDIFF(year, P.fecha_nac, GETDATE()) AS 'Edad',
			EA.estado_alumno AS 'Estado Alumno',
			COUNT(DISTINCT ACM.legajo_alumno) AS 'Cantidad Total de Alumnos'
		FROM alumnos_carreras_materias ACM
		INNER JOIN estados_alumnos EA ON ACM.id_estado_alumno = EA.id_estado_alumno
		INNER JOIN alumnos A ON ACM.legajo_alumno = A.legajo_alumno
		INNER JOIN personas P ON A.id_persona = P.id_persona
		GROUP BY DATEDIFF(year, P.fecha_nac, GETDATE()), EA.estado_alumno
		HAVING DATEDIFF(year, P.fecha_nac, GETDATE()) > @edadMin
		ORDER BY 1
EXECUTE consulta1 @edadMin=null
SET DATEFORMAT dmy
EXECUTE consulta1 @edadMin=20
EXECUTE sp_addmessage @msgnum=57000, @severity=16, @msgtext='La edad minima no puede ir vacia'


--Cree un VISTA que muestre los alumnos que no hayan cursado materias en los últimos 2 años.

CREATE VIEW consulta2
AS
	SELECT DISTINCT
		A.legajo_alumno AS 'Nro Legajo',
		P.ape_persona + ' ' + P.nom_persona AS 'Alumno',
		D.calle + ' N° ' + TRIM(STR(D.nro)) AS 'Direccion',
		B.nom_barrio AS 'Barrio',
		P.email AS 'E-Mail',
		TD.tipo AS 'Tipo Documento',
		P.nro_doc AS 'Nro. Documento',
		P.fecha_ingreso AS 'Fecha Ingreso'
	FROM alumnos_carreras_materias ACM
	INNER JOIN alumnos A ON ACM.legajo_alumno = A.legajo_alumno
	INNER JOIN personas P ON A.id_persona = P.id_persona
	INNER JOIN domicilios D ON P.id_domicilio = D.id_domicilio
	INNER JOIN barrios B ON D.id_barrio = B.id_barrio
	INNER JOIN tipos_doc TD ON P.id_tipo_doc = TD.id_tipo_doc
	WHERE NOT EXISTS (SELECT * 
					  FROM alumnos_carreras_materias ACMS 
					  WHERE ACMS.legajo_alumno = ACM.legajo_alumno 
				      AND YEAR(ACM.fecha_inscripcion) BETWEEN YEAR(DATEADD(year, -2, GETDATE())) AND YEAR(GETDATE())) 

---Bloque de Ejecución
SELECT * FROM consulta2


/*Cree una Funcion que muestre la cantidad de alumnos que no han rendido 
ninguna materia en los 5 ultimos años.*/
CREATE FUNCTION consulta3 ()
RETURNS TABLE
AS
	RETURN (
		SELECT
			COUNT(A.legajo_alumno) AS 'Cantidad de Alumnos que no rindieron ninguna materia'
		FROM alumnos A
		WHERE A.legajo_alumno NOT IN (SELECT legajo_alumno 
									  FROM alumnos_examenes 
									  WHERE YEAR(fecha_aprobado) BETWEEN YEAR(DATEADD(year, -5, GETDATE())) AND YEAR(GETDATE())) 
	)
---Bloque de Ejecución
SELECT * FROM dbo.consulta3()


/*Cree un SP que busque un alumno cuyo nombre empiece con un valor enviado por parámetro
y almacenar su nombre en un parámetro de salida. En caso de que haya varios alumnos con 
el mismo nombre mostrar la cantidad de alumnos. En el caso de no encontrar coincidencia 
ocurrira un excepción que deberá ser manejada con try catch.*/
CREATE PROCEDURE consulta4
@valor VARCHAR(50),
@valor_retorno VARCHAR(50) OUTPUT
AS
	BEGIN
		CREATE TABLE #auxiliarAlumnos
		(descripcion VARCHAR(50))

		INSERT INTO #auxiliarAlumnos
			SELECT P.nom_persona
			FROM alumnos A
			INNER JOIN personas P ON A.id_persona = P.id_persona
			WHERE P.nom_persona LIKE @valor+'%'

		DECLARE @cantidad INT
		SELECT @cantidad = COUNT(*) FROM #auxiliarAlumnos
		BEGIN TRY
			IF(@cantidad = 1)
				SELECT @valor_retorno = descripcion FROM #auxiliarAlumnos 
			ELSE IF (@cantidad > 1)
				SELECT @valor_retorno = @cantidad
			ELSE
				RAISERROR(57010, 16, 1)
		END TRY
		BEGIN CATCH
			PRINT error_message()
		END CATCH
	END

---Bloque de Ejecución
EXECUTE sp_addmessage @msgnum=57010, @severity=16, @msgtext='No hay alumnos con ese nombre'
DECLARE @v_salida VARCHAR(50)
EXEC consulta4 'h', @v_salida OUTPUT
SELECT @v_salida AS 'Resultado'


/*Se quiere un listado de los alumnos que hayan desaprobado el final de Programación I
en julio de 2021, pero que hayan tenido un promedio de 7 o más en los Parciales de la cursada.*/

SELECT ae2.legajo_alumno Legajo, p.ape_persona+' '+p.nom_persona Alumno, ae2.nota 'Nota en el Final'
	FROM alumnos_examenes ae2 
	join examenes e2 on e2.id_examen = ae2.id_examen
	join alumnos a on a.legajo_alumno = ae2.legajo_alumno
	join personas p on p.id_persona = a.id_persona
	join materias m on m.id_materia = e2.id_materia
	join tipos_examenes te on te.id_tipo_examen = e2.id_tipo_examen        
	WHERE m.nom_materia = 'Programacion I'  
	  and te.tipo_examen = 'Examen Final'  
	  and ae2.nota <6  
	  and year(e2.fecha) = 2021 and MONTH(e2.fecha) = 7 
	  and EXISTS  (select legajo_alumno
						FROM alumnos_examenes ae JOIN examenes e on e.id_examen = ae.id_examen 
						WHERE e.id_materia = 1   --materia Programacion I 
						and e.id_tipo_examen in (1,2)		--que sea Parcial 1 o Parcial 2
						and legajo_alumno = ae2.legajo_alumno
						GROUP BY legajo_alumno
						HAVING AVG(ae.nota) >= 7
					)


/*Listado de cantidad de exámenes de tipo final, en los que participaron las personas
con estado laboral de empleo de medio tiempo, diferenciando profesores de alumnos en 
una columna llamada "TIPO".*/
select per.nom_persona+' '+per.ape_persona as 'Persona',
		estado_laboral as 'Estado Lab.', 
		pro.legajo_profesor as 'Legajo', 
		count(ex.id_examen) as 'Cant. Exámenes','Profesor' 'Tipo'
	from profesores pro
	join personas per on pro.id_persona = per.id_persona
	join estados_laborales est on per.id_est_lab = est.id_est_lab
	join examenes ex on pro.legajo_profesor = ex.legajo_profesor
	join tipos_examenes te on ex.id_tipo_examen = te.id_tipo_examen
	where estado_laboral = 'Empleado Medio Tiempo'
	and te.id_tipo_examen = 3
	group by per.nom_persona+' '+per.ape_persona,estado_laboral,pro.legajo_profesor
UNION
select per.nom_persona+' '+per.ape_persona as 'Persona',
		estado_laboral as 'Estado Lab.',
		a.legajo_alumno as 'Legajo', 
		count(ex.id_examen)'Cant. Exámenes', 'Alumno' 
	from alumnos a
	join personas per on a.id_persona = per.id_persona
	join estados_laborales est on per.id_est_lab = est.id_est_lab
	join alumnos_examenes alex on a.legajo_alumno = alex.legajo_alumno
	join examenes ex on alex.id_examen = ex.id_examen
	join tipos_examenes te on ex.id_tipo_examen = te.id_tipo_examen
	where estado_laboral = 'Empleado Medio Tiempo'
	and te.id_tipo_examen = 3
	group by per.nom_persona+' '+per.ape_persona,estado_laboral,a.legajo_alumno


/*Crear un procedimiento que muestre los alumnos que se inscribierona una carrera 
determinada en el año actual.*/
CREATE PROCEDURE alumnos_año
@carrera varchar(25)
AS   
  SELECT P.nom_persona +' - ' +P.ape_persona 'NOMBRE', A.legajo_alumno 'LEGAJO'
  FROM personas P
  JOIN
  alumnos A 
  ON P.id_persona = A.id_persona
  JOIN
  alumnos_carreras_materias ACM 
  ON ACM.legajo_alumno = A.legajo_alumno
  JOIN carreras_materias CM
  ON CM.id_carrera_materia = ACM.id_carrera_materia
  JOIN carreras C
  ON C.id_carrera = CM.id_carrera
  WHERE  @carrera = C.nom_carrera and
      year(fecha_inscripcion)= GETDATE()

EXECUTE alumnos_año 'Programacion'

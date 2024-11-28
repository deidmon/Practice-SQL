--Consult marks
SELECT *
FROM Empleado E 
INNER JOIN Marca M ON E.EmpleadoID = M.EmpleadoID
INNER JOIN TipoMarca T ON M.Tipo = T.Tipo

--Calculating hours worked
SELECT EmpleadoID, CONVERT(DATE, Fecha),
       MAX(CASE WHEN Tipo = 'EI' THEN Fecha END),
       MAX(CASE WHEN Tipo = 'EF' THEN Fecha END),
       MAX(CASE WHEN Tipo = 'SI' THEN Fecha END),
       MAX(CASE WHEN Tipo = 'SF' THEN Fecha END)
INTO #Marcas
FROM Marca 
GROUP BY EmpleadoID, CONVERT(DATE, Fecha)

SELECT EmpleadoID, Fecha, ISNULL(DATEDIFF(HOUR, EI, EF),0) + ISNULL(DATEDIFF(HOUR, SI, SF),0) AS Horas
INTO #HorasTrabajadas
FROM #Marcas

SELECT E.EmpleadoID, E.Nombre, E.Apellido, E.SueldoHora,
       H.Fecha, H.Horas, (E.SueldoHora * H.Horas) AS TotalPagar
FROM #HorasTrabajadas H 
INNER JOIN Empleado E ON H.EmpleadoID = E.EmpleadoID

DROP TABLE #HorasTrabajadas
DROP TABLE #Marcas
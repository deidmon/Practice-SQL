--Consult marks
SELECT *
FROM Empleado E 
INNER JOIN Marca M ON E.EmpleadoID = M.EmpleadoID
INNER JOIN TipoMarca T ON M.Tipo = T.Tipo

--Calculating hours worked
DECLARE @FechaInicial DATE = '2024-11-25'
DECLARE @FechaFinal DATE = GETDATE()


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

SELECT E.EmpleadoID, E.Nombre, E.Apellido, E.SueldoHora AS SueldoHora,
       SUM(H.Horas) AS Horas, (Horas * TotalPagar) AS TotalPagar
INTO #HorasTotal
FROM #HorasTrabajadas H 
INNER JOIN Empleado E ON H.EmpleadoID = E.EmpleadoID
WHERE H.Fecha BETWEEN @FechaInicial AND @FechaFinal
GROUP BY E.EmpleadoID, E.Nombre, E.Apellido

SELECT *
FROM #HorasTotal

ALTER TABLE #HorasTotal
ADD TotalPagar MONEY

UPDATE #HorasTotal SET TotalPagar = CASE WHEN Horas <=40 THEN Horas - 0.5 ELSE Horas END * SueldoHora

DROP TABLE #HorasTotal
DROP TABLE #HorasTrabajadas
DROP TABLE #Marcas
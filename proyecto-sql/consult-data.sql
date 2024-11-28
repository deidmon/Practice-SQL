--Consult marks
SELECT *
FROM Empleado E 
INNER JOIN Marca M ON E.EmpleadoID = M.EmpleadoID
INNER JOIN TipoMarca T ON M.Tipo = T.Tipo

--Calculating hours worked
CREATE PROCEDURE spObtenerHorasTrabajadas
    @FechaInicial DATE,
    @FechaFinal DATE
AS
BEGIN
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

    ALTER TABLE #HorasTotal
    ADD TotalPagar MONEY

    UPDATE #HorasTotal SET TotalPagar = CASE WHEN Horas <=40 THEN Horas - 0.5 ELSE Horas END * SueldoHora

    SELECT *
    FROM #HorasTotal

    DROP TABLE #HorasTotal
    DROP TABLE #HorasTrabajadas
    DROP TABLE #Marcas
END


EXEC spObtenerHorasTrabajadas '2024-11-10', '2024-11-28'

--modify marks
CREATE PROC spActualizarHoras
    @EmpleadoID INT,
    @Fecha DATE,
    @TipoMarca VARCHAR(2)
AS
BEGIN
    UPDATE Marca SET Fecha = @Fecha 
    WHERE EmpleadoID = @EmpleadoID AND CONVERT(DATE, Fecha) = @Fecha AND TipoMarca = @TipoMarca
END   


EXEC spActualizarHoras 1, '2024-11-24', 'EF', '2024-11-25 14:05:00'
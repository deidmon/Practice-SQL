---Insert data into table PuestoEmpleado
INSERT INTO PuestoEmpleado 
VALUES ('Programador'),
       ('Diseñador'),
       ('Scrum Master')

---Insert data into table Empleado
CREATE PROCEDURE spInsertarEmpleado
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @Direccion VARCHAR(500),
    @PuestoID INT,
    @FechaNacimiento DATE,
    @SueldoHora MONEY
AS
BEGIN
    INSERT INTO Empleado (Nombre, Apellido, Direccion, PuestoID, FechaNacimiento, SueldoHora)
    VALUES (@Nombre, @Apellido, @Direccion, @PuestoID, @FechaNacimiento, @SueldoHora)
END


EXEC spInsertarEmpleado 'Tom', 'Díaz', 'Barrio Nuevo', 1, '2000-08-10', 5.2

---Insert data into table TipoMarca
INSERT INTO TipoMarca 
VALUES ('EI','Entrada Inicial'),
       ('SI','Salida Inicial'),
       ('EF','Entrada Final'),
       ('SF','Salida Final')

---Insert data into table Marca
CREATE PROCEDURE spInsertarMarca
    @EmpleadoID INT,
AS
BEGIN
    DECLARE @Marcas INT =
    (
        SELECT COUNT(*)
        FROM Marca 
        WHERE EmpleadoID = @EmpleadoID
        AND CONVERT(DATE, Fecha) = CONVERT(DATE,  GETDATE())
    )
    IF(@Marcas < 4)
    BEGIN
        IF(@Marcas = 0)
        BEGIN
            INSERT INTO Marca (Fecha, EmpleadoID, Tipo)
            VALUES (GETDATE(), @EmpleadoID, 'EI')
        END
        IF(@Marcas = 1)
        BEGIN
            INSERT INTO Marca (Fecha, EmpleadoID, Tipo)
            VALUES (GETDATE(), @EmpleadoID, 'EF')
        END
        IF(@Marcas = 2)
        BEGIN
            INSERT INTO Marca (Fecha, EmpleadoID, Tipo)
            VALUES (GETDATE(), @EmpleadoID, 'SI')
        END
        IF(@Marcas = 3)
        BEGIN
            INSERT INTO Marca (Fecha, EmpleadoID, Tipo)
            VALUES (GETDATE(), @EmpleadoID, 'SF')
        END
    END
    ELSE
    BEGIN
        PRINT('Este usuario ya marcó las 4 veces')
    END
END

EXEC spInsertarMarca 1
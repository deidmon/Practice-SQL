
CREATE TABLE PuestoEmpleado (
    PuestoID INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100)
)

CREATE TABLE Empleado (
    EmpleadoID INT IDENTITY(1,1) PRIMARY KEY, 
    Nombre VARCHAR(100),
    Apellido VARCHAR(100),
    Direccion VARCHAR(500),
    PuestoID INT,
    FechaNacimiento DATE,
    SueldoHora MONEY,
    FOREIGN KEY (PuestoID) REFERENCES PuestoEmpleado(PuestoID)
)

CREATE TABLE TipoMarca (
    Tipo VARCHAR(2) PRIMARY KEY,
    Descripcion VARCHAR(100),
)

CREATE TABLE Marca (
    MarcaID INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATETIME,
    EmpleadoID INT,
    Tipo VARCHAR(2),
    FOREIGN KEY (EmpleadoID) REFERENCES Empleado(EmpleadoID),
    FOREIGN KEY (Tipo) REFERENCES TipoMarca(Tipo)
)

CREATE TABLE LogFechasModifico(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATETIME,
    Usuario VARCHAR(100),
    EmpleadoID INT,
    FechaAnterior DATETIME
)
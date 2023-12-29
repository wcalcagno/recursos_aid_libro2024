-- Forma base de Consulta en SQL
SELECT
    Campo1, Campo2, Campo3 , Campo4

FROM 
    Tabla1

WHERE
    Campo1 = 'Valor1' AND Campo2 >= 0

-- Forma con Agregaciones
SELECT
    Campo1 , sum (Campo2)

FROM
    Tabla1 

WHERE Campo1 = 'Valor1'
GROUP BY Campo1


-- Script para crear vista

CREATE VIEW dbo.vw_stock_citricos 
AS 
SELECT
    Fruta , 
    SUM (Cant_Kgs) as Kilos
FROM 
    dbo.stock_fruta
WHERE
    Fruta IN ('Naranja', 'Limón') AND 
    Fecha BETWEEN '2019-01-01' AND CURRENT_DATE
GROUP BY
    Fruta
ORDER BY Kilos ASC  


--  Consulta Anidada Doble con Subquery
SELECT
    Fecha,
    SUM(Cant_Kgs) as Total_Kgs
FROM
    tabla_frutas
WHERE
    Fecha IN (
        SELECT
            Fecha
        FROM
            tabla_frutas
        WHERE
            SUM(Cant_Kgs) > (
                SELECT
                    AVG(Cant_Kgs)
                FROM
                    tabla_frutas
            )
        GROUP BY
            Fecha
    )
GROUP BY
    Fecha
ORDER BY
    Total_Kgs DESC;


-- consulta  con CTE     

WITH PromedioKgs AS (
    SELECT
        AVG(Cant_Kgs) AS Promedio
    FROM
        tabla_frutas
),
TotalPorFecha AS (
    SELECT
        Fecha,
        SUM(Cant_Kgs) AS Total_Kgs
    FROM
        tabla_frutas
    GROUP BY
        Fecha
)
SELECT
    t.Fecha,
    t.Total_Kgs
FROM
    TotalPorFecha t
    JOIN PromedioKgs p ON t.Total_Kgs > p.Promedio
ORDER BY
    t.Total_Kgs DESC;

-- consulta Update
    UPDATE
    Clientes
SET
    Direccion = '123 Calle Nueva, Ciudad, País'
WHERE
    ID_Cliente = 12345;


-- creacion de SP para Update
CREATE PROCEDURE sp_update_cliente @ID_Cliente INT,
@NuevaDireccion VARCHAR(255) AS BEGIN
UPDATE
    Clientes
SET
    Direccion = @NuevaDireccion
WHERE
    ID_Cliente = @ID_Cliente;

END;

-- ejecucion de SP
EXEC sp_update_cliente 12345,
'123 Calle Nueva, Ciudad, País';

-- creacion de SP para UPSERT
CREATE PROCEDURE sp_upsert_cliente @ID_Cliente INT,
@Nombre VARCHAR(255),
@Direccion VARCHAR(255) AS BEGIN MERGE INTO dbo.clientes AS target USING (
    VALUES
        (@ID_Cliente, @Nombre, @Direccion)
) AS source (id_cliente, nombre, direccion) ON target.id_cliente = source.id_cliente
WHEN MATCHED THEN
UPDATE
SET
    nombre = source.nombre,
    direccion = source.direccion
    WHEN NOT MATCHED THEN
INSERT
    (id_cliente, nombre, direccion)
VALUES
    (
        source.id_cliente,
        source.nombre,
        source.direccion
    );

END;

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
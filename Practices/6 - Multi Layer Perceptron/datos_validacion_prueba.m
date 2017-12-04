function [validacion, prueba] = datos_validacion_prueba (valores, p, target)
    total_datos = size (valores);
    total_datos = total_datos (1, 2);
    %Numero de datos para el conjunto de validacion
    datos_val = ceil (total_datos / 2);
    datos_prueba = (total_datos - datos_val);
    %Numero de datos para el conjunto de prueba
    validacion = zeros (datos_val, 2);
    prueba = zeros (datos_prueba, 2);
    
    %Se comienzan a asignar los valores al conjunto de validacion
    for i = 1:datos_val
        %Valores de validacion en columna 1
        validacion (i, 1) = p (valores (1, i), 1);
        %Valores de target en la columna 2
        validacion (i, 2) = target (valores (1, i), 1);
    end
    
    %Omitimos los datos ya ingresados para evitar repeticiones
    valores = valores (i + 1:total_datos);
    
    %Se comienzan a asignar los valores al conjunto de prueba
    for i = 1:datos_prueba
        %Valores de prueba en columna 1
        prueba (i, 1) = p (valores (1, i), 1);
        %Valores de target en la columna 2
        prueba (i, 2) = target (valores (1, i), 1);
    end
end
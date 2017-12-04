function [entrenamiento, nuevos_val] = datos_entrenamiento (opcion, valores, p, target)
    if opcion == 1
        aux = 0.8;
    else
        aux = 0.7;
    end
    total_datos = size (valores);
    total_datos = total_datos (1, 2);
    %Numero de datos para el conjunto de entrenamiento
    datos_ent = ceil (total_datos * aux);
    entrenamiento = zeros (datos_ent, 2);
    
    %Se comienzan a asignar los valores al conjunto de entrenamiento
    for i = 1:datos_ent
        %Valores de entrenamiento en columna 1
        entrenamiento (i, 1) = p (valores (1, i), 1);
        %Valores de target en la columna 2
        entrenamiento (i, 2) = target (valores (1, i), 1);
    end
    %Omitimos los datos ya ingresados para evitar repeticiones
    nuevos_val = valores (i + 1:total_datos);
end

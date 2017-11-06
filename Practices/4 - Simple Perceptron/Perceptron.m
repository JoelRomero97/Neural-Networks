%Comenzamos limpiando la pantalla y todas las variables
clearvars
clc

%Para guardar valores finales de pesos y bias
nombre_arch = strcat ('resultado_', datestr(now,'HH-MM-SS'), '_', datestr (now, 'mm-dd-yyyy'), '.txt');

nombre_archivo = input ('Ingrese el nombre del archivo que contiene el conjunto de entrenamiento: ', 's');

opcion = input ('\nIndique como quiere resolver el problema\n\n1. Método Gráfico\n2. Regla de Aprendizaje\n\n');
clc
if opcion == 1
    %AQUI VA EL METODO GRÁFICO
elseif opcion == 2
    %Pedimos la dimensión de los target al usuario
    dim_target = input ('\nIngresa la dimensión de los target: ');
    if dim_target > 1
        num_prototipos = input ('\nIngresa el numero de vectores prototipo: ');
        R = input ('\nIngresa la dimensión de los vectores prototipo: ');
        arch = fopen (nombre_archivo, 'r');
        prototipos = zeros (num_prototipos, R);
        targets = zeros (num_prototipos, dim_target);
        for i = 1:num_prototipos
            fscanf (arch, '{[');
            prototipos (i, :) = fscanf (arch, '%f');
            fscanf (arch, '],[');
            targets (i, :) = fscanf (arch, '%f');
            fscanf (arch, ']}\n');
        end
        fclose (arch);
        
        %Imprimimos los valores de los prototipos y targets
        prototipos
        targets
        
        clases = input ('\nIndica el número de clases: ');
        
        %Calculamos el número de neuronas a utilizar
        S = ceil (log2 (clases));
    else
        %Abrimos el archivo y lo guardamos directamente en una matriz
        conjunto_entrenamiento = dlmread (nombre_archivo);
        aux = size (conjunto_entrenamiento);
        
        %La dimensión del vector de entrada (R) es el número de columnas
        %pero restando la columna que contiene a los target
        R = aux (1, 2) - 1;
        num_prototipos = aux (1, 1);
        clases = input ('\nIndica el número de clases: ');
        
        %Calculamos el número de neuronas a utilizar
        S = ceil (log2 (clases));
        
        %Obtenemos los target y vectores prototipo en matrices distintas
        prototipos = conjunto_entrenamiento (:, 1: R);
        targets = conjunto_entrenamiento (:, R + 1);
    end
    %Pedimos los valores necesarios para los criterios de finalización
    it_max = input ('\nIngresa el numero máximo de iteraciones: ');
    e_it = input ('\nIngresa el valor al que deseas llegar la señal del error: ');

    %Limpiamos la pantalla
    clc
    
    %Se asignan valores aleatorios entre 0 y 1 a los pesos y bias
    W = rand (S, R);
    bias = rand (S, 1);
    
    %Para escribir el error
    nuevo = fopen ('Errores.txt', 'w');
    
    %Ciclo que controla las iteraciones
    for i = 1:it_max
        Eit = 0;
        k = 0;
        for j = 1:num_prototipos
            
            %p es igual a la fila j de los prototipos transpuesta
            p = prototipos (j, :)';
            
            %Calculamos la salida de la red para el prototipo j
            a = hardlim ((W * p) + bias);
            
            %Calculamos la señal del error para el prototipo j
            signal_error = targets (j, :) - a;
            
            aux = size (signal_error);
            
            signal_error = (sum(signal_error) / aux (1, 2));
            
            %Si el error es 0, la matriz de pesos y bias quedan igual
            if signal_error ~= 0
                %Calculamos la nueva matriz de pesos para el siguiente
                %vector prototipo
                W = W + (signal_error * p');
                
                %Calculamos el nuevo bias para el siguiente vector
                %prototipo
                bias = bias + signal_error;
                
                %Sumamos el error obtenido
                Eit = Eit + ((1 / num_prototipos) * signal_error);
            end
            k = k + 1;
        end
        fprintf (nuevo, '%f\n', Eit);
        %Verificamos si se cumplió alguno de los criterios de
        %finalización, si no, se realiza otra iteración
        if Eit < e_it && Eit > 0
            fprintf ('\n\nSe obtuvo un aprendizaje exitoso en la iteración %d\n\n', i);
            fprintf ('\n\nCriterio de finalización activado: Eit < %f\n\n', e_it);
            i = -1;
            break;
        elseif Eit == 0
            fprintf ('\n\nSe obtuvo un aprendizaje exitoso en la iteración %d\n\n', i);
            fprintf ('\n\nCriterio de finalización activado: Todos los datos bien clasificados\n\n');
            i = -1;
            break;
        end
    end
    if i >= it_max
        fprintf ('\n\nNo se obtuvo un aprendizaje exitoso de la red :(\n\n');
    else
        pesos_finales = fopen (nombre_arch, 'w');
        fprintf (pesos_finales, 'Matriz de pesos\n\n');
        for i = 1:S
            for j = 1:R
                fprintf (pesos_finales, '%.4f\t', W (i, j));
            end
            fprintf (pesos_finales, '\n');
        end
        fprintf (pesos_finales, '\n\nBias\n\n');
        for i = 1:S
            fprintf (pesos_finales, '%.4f\n', bias (i, 1));
        end
        fclose (pesos_finales);
    end
else
    fprintf ('\n\nOPCION INVALIDA\n\n');
end

clearvars
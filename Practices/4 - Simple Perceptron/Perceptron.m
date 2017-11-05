%Comenzamos limpiando la pantalla y todas las variables
clearvars
clc

nombre_archivo = input ('Ingrese el nombre del archivo que contiene el conjunto de entrenamiento: ', 's');

opcion = input ('\nIndique como quiere resolver el problema\n\n1. M�todo Gr�fico\n2. Regla de Aprendizaje\n\n');
clc
if opcion == 1
    %AQUI VA EL METODO GR�FICO
elseif opcion == 2
    %Pedimos la dimensi�n de los target al usuario
    dim_target = input ('\nIngresa la dimensi�n de los target: ');
    if dim_target > 1
        %AQUI VA LO DE IVAN
    else
        %Abrimos el archivo y lo guardamos directamente en una matriz
        conjunto_entrenamiento = dlmread (nombre_archivo);
        aux = size (conjunto_entrenamiento);
        
        %La dimensi�n del vector de entrada (R) es el n�mero de columnas
        %pero restando la columna que contiene a los target
        R = aux (1, 2) - 1;
        num_prototipos = aux (1, 1);
        clases = input ('\nIndica el n�mero de clases: ');
        
        %Calculamos el n�mero de neuronas a utilizar
        S = ceil (log2 (clases));
        
        %Obtenemos los target y vectores prototipo en matrices distintas
        prototipos = conjunto_entrenamiento (:, 1: R);
        targets = conjunto_entrenamiento (:, R + 1);
        
        %Pedimos los valores necesarios para los criterios de finalizaci�n
        it_max = input ('\nIngresa el numero m�ximo de iteraciones: ');
        e_it = input ('\nIngresa el valor al que deseas llegar la se�al del error: ');

        %Limpiamos la pantalla
        clc
        
        %Se asignan valores aleatorios entre 0 y 1 a los pesos y bias
        W = rand(S, R);
        bias = rand (S, 1);
        
        %Para escribir el error
        nombre_arch = strcat ('resultado_', datestr(now,'HH-MM-SS'), '_', datestr (now, 'mm-dd-yyyy'), '.txt');
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
                
                %Calculamos la se�al del error para el prototipo j
                signal_error = targets (j, :) - a;
                
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
            %Verificamos si se cumpli� alguno de los criterios de
            %finalizaci�n, si no, se realiza otra iteraci�n
            if Eit < e_it && Eit > 0
                fprintf ('\n\nSe obtuvo un aprendizaje exitoso en la iteraci�n %d\n\n', i);
                fprintf ('\n\nCriterio de finalizaci�n activado: Eit < %f\n\n', e_it);
                %AQUI FALTA ESCRIBIR LOS VALORES DE PESOS Y BIAS EN EL
                %ARCHIVO DE TEXTO
                i = -1;
                break;
            elseif Eit == 0
                fprintf ('\n\nSe obtuvo un aprendizaje exitoso en la iteraci�n %d\n\n', i);
                fprintf ('\n\nCriterio de finalizaci�n activado: Todos los datos bien clasificados\n\n');
                %AQUI FALTA ESCRIBIR LOS VALORES DE PESOS Y BIAS EN EL
                %ARCHIVO DE TEXTO
                i = -1;
                break;
            end
        end
        if i >= it_max
            fprintf ('\n\nNo se obtuvo un aprendizaje exitoso de la red :(\n\n');
        end
    end
else
    fprintf ('\n\nOPCION INVALIDA\n\n');
end

clearvars
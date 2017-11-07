%Comenzamos limpiando la pantalla y todas las variables
clearvars
clc

%Pedimos los valores para los criterios de finalizaci�n
fprintf ('\t\t\t\t\t\t\tRed Adaline\n');
it_max = input ('\nIngresa el valor de iteraciones m�ximas: ');
e_it = input ('\nIngresa el valor al que deseas llegar la se�al del error: ');
alpha = input ('\nIngresa el valor del factor de aprendizaje (alfa): ');

%Preguntamos si quiere usar la red con o sin bias
clc
opcion = input ('\n�C�mo desea usar la Red Adaline?\n\n1. Con Bias\n2. Sin Bias\n\n');

if opcion == 1
    %C�digo para perceptron simple
elseif opcion == 2
    numero_bits = input ('\nIngresa el tama�o del decodificador: ');
    numero_datos = power (2, numero_bits);
    
    %Generamos el conjunto de entrenamiento
    entrenamiento = genera_conjunto (numero_bits, numero_datos);
    
    %Abrimos archivos para escribir datos de los pesos
    pesos = fopen ('Pesos.txt', 'w');
    
    %Creamos un figure para hacer las gr�ficas
    Graph = figure('Name','Red Adaline','NumberTitle','off');
    rango = 1:numero_bits;
    
    %Asignamos valores aleatorios a los pesos
    W = rand (1, numero_bits);
    
    for j = 1:numero_bits
        %Escribimos los pesos en un archivo
        fprintf (pesos, '%.4f\n', W (1, j));
    end
    
    Error_iteracion = zeros (1, it_max);
    flag = 1;
    
    %Regla de aprendizaje
    for k = 1:it_max
        
        %El error se hace 0 en cada iteraci�n nueva
        error = 0;
        
        for i = 1:numero_datos

            %Obtenemos cada uno de los datos
            p = (entrenamiento (i, 1:numero_bits))';
            a = purelin (W * p);
            error = ((entrenamiento (i, (numero_bits + 1))) - a);

            %Actualizamos el valor de los pesos
            W = (W + (2 * alpha * error * p'));
            
            for j = 1:numero_bits
                %Escribimos los pesos en un archivo
                fprintf (pesos, '%.4f\n', W (1, j));
            end
            
            if error ~= 0
                %Agregamos el valor del error al error de iteraci�n
                Error_iteracion (1, k) = Error_iteracion (1, k) + error;
                flag = 0;
            end
        end
        Error_iteracion (1, k) = (Error_iteracion (1, k) / numero_datos);
        
        %Verificamos si se cumpli� alguno de los criterios de finalizaci�n
        if flag == 1
            fprintf ('\nTodos los datos fueron bien clasificados en la iteraci�n %d.\n\n', k);
            break;
        elseif Error_iteracion (1, k) < e_it && Error_iteracion (1, k) > 0
            fprintf ('\nSe alcanz� la se�al del error en la iteraci�n %d\n\n.', k);
            break;
        end
    end
    
    %Cerramos el archivo
    fclose (pesos);
    
    if k >= it_max
        fprintf ('No hubo un aprendizaje exitoso :(\n\n');
        
        %Graficamos el error de iteraci�n
        subplot (1, 2, 2), plot (1:it_max, Error_iteracion, 'o-');
        grid, ylabel('Error (i)'), xlabel('i');
        title ('\fontsize{20} \color[rgb]{0 .5 .5}Evoluci�n del error de iteraci�n');
    else
        nombre_arch = strcat ('resultado_', datestr(now,'HH-MM-SS'), '_', datestr (now, 'mm-dd-yyyy'), '.txt');
        dlmwrite (nombre_arch, W, 'delimiter', '\t');
        %Graficamos el error de iteraci�n
        subplot (1, 2, 2), plot (1:k, Error_iteracion (1, 1:k), 'o-');
        grid, ylabel('Error (i)'), xlabel('i');
        title ('\fontsize{20} \color[rgb]{0 .5 .5}Evoluci�n del error de iteraci�n');
    end
    pesos = fopen ('Pesos.txt', 'r');
    frewind (pesos);

    while ~feof (pesos)
        W = fscanf (pesos, '%f\n', [1 numero_bits]);

        %Graficamos los pesos
        hold on;
        subplot (1, 2, 1), plot (rango, W, 'o-');
        grid, ylabel('W (i)'), xlabel('i');
        title ('\fontsize{20} \color[rgb]{0 .5 .5}Evoluci�n de los pesos');
    end
else
    fprintf ('\nOpci�n inv�lida.\n\n');
end

%Limpiamos todas las variables utilizadas
clearvars
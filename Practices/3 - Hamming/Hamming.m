%Limpiamos la pantalla y borramos todas las variables creadas anteriormente
clc;
clear;

%Recibimos el nombre del archivo como un String (por eso la 's')
archivo = input ('Introduce el nombre del archivo que contiene a W: ', 's');

%Abrimos el archivo que contiene la matriz a usar en modo lectura
W = dlmread (archivo);
aux = size (W);
num_filas = aux (1, 1);
num_col = aux (1, 2);

%Creamos una matriz para el bias
bias = zeros (num_filas,1);
bias = bias + num_col;

%Recibimos el nombre del archivo como un String (por eso la 's')
archivo = input ('\nIntroduce el nombre del archivo que contiene el vector de entrada: ', 's');

%Abrimos el archivo que contiene la matriz a usar en modo lectura
archivo_matriz = fopen (archivo, 'r');

%Guardamos el vector de entrada p en una matriz
p = fscanf (archivo_matriz, '%f');

%COMIENZA LA CAPA FEEDFORWARD (1 vez)
a = purelin((W * p) + bias);

clc

%Calculamos un valor para epsilon aleatorio
epsilon = (rand() * (1/(num_filas - 1)) * -1);
fprintf ('\n\nValor de epsilon: %d\n\n', epsilon);

%Calculamos la matriz de pesos a usar en la capa Recurrente
W = zeros (num_filas);
W = W + epsilon;
for i = 1:num_filas
    for j = 1:num_filas
        if i == j
            W (i, j) = 1;
        end
    end
end

%COMIENZA LA CAPA RECURRENTE (n veces)
flag = ones (num_filas, 1);iteracion = 1;

%ESCRIBIR LA MATRIZ EN UN ARCHIVO DE TEXTO LLAMADO SalidaHamming
nuevo = fopen ('SalidaHamming.txt', 'w');

for i = 1:num_filas
      fprintf (nuevo, '%f\n', a(i, 1));
end
cont = 0;
while cont ~= 1
    cont = 0;
    p = a;
    a = poslin (W * p);
    if iteracion == 1
        aux = a;
    else
        %Agregamos un vector columna a la matriz aux
        aux = [aux, a];
        
        %Restamos los 2 vectores columna y lo guardamos en la bandera
        flag = aux (:,iteracion) - aux (:, iteracion - 1);
        if flag == zeros (num_filas, 1)
            for i = 1:num_filas
                clase = a (i, 1);
                if clase ~= 0
                    cont = cont + 1;
                end
            end
        end
    end
    %Escribimos los datos en un archivo
    for i = 1:num_filas
          fprintf (nuevo, '%f\n', a(i, 1));
    end
    iteracion = iteracion + 1;
end

for i = 1:num_filas
    clase = a (i, 1);
    if clase ~= 0
        break;
    end
end

fprintf ('\nLa RNA convergió en la iteración %d a la clase numero %d\n\n', iteracion - 1, i);

%GRAFICAMOS LOS VALORES DE SALIDA DE LA RED
nuevo = fopen ('SalidaHamming.txt', 'r');
Graph = figure('Name','Red Hamming','NumberTitle','off');

while ~feof (nuevo)
    [r, cont] = fscanf (nuevo, '%f\n', [num_filas iteracion]);
end

for i = 1:num_filas
    figure (Graph);
    hold on;
    plot (r (i,:), 'o-');
    grid, ylabel('Valor'), xlabel('Iteración');
end

%Cerramos los archivos
fclose (archivo_matriz);
fclose (nuevo);

%Borramos todas las variables creadas durante la ejecución del programa
clear;
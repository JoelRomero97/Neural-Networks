%Limpiamos la pantalla y borramos todas las variables creadas anteriormente
clc;
clear;

%Recibimos el nombre del archivo como un String (por eso la 's')
archivo = input ('Introduce el nombre del archivo que contiene a W: ', 's');

%Abrimos el archivo que contiene la matriz a usar en modo lectura
archivo_matriz = fopen (archivo, 'r');

%Recibimos el número de filas y columnas que tiene la matriz para lectura
num_filas = input ('Ingresa el número de patrones prototipo (filas) que tiene la matriz: ');
num_col = input ('Ingresa el número de rasgos de cada patron (columas) que tiene la matriz: ');

%Creamos una matriz para el bias
bias = zeros (num_filas,1);
bias = bias + num_col;

while ~feof (archivo_matriz)
    [W, cont] = fscanf (archivo_matriz, '%f', [num_col num_filas]);
end
W = W';

clc
%Recibimos el nombre del archivo como un String (por eso la 's')
archivo = input ('Introduce el nombre del archivo que contiene el vector de entrada: ', 's');

%Abrimos el archivo que contiene la matriz a usar en modo lectura
archivo_matriz = fopen (archivo, 'r');

%Guardamos el vector de entrada p en una matriz
p = fscanf (archivo_matriz, '%f');

%COMIENZA LA CAPA FEEDFORWARD (1 vez)
a = purelin((W * p) + bias);

%Calculamos un valor para epsilon aleatorio
%epsilon = (rand() * (1/(num_filas - 1)) * -1)
epsilon = (0.5 * -1);

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

while flag ~= zeros (num_filas, 1)
    p = a;
    a = poslin (W * p);
    if iteracion == 1
        aux = a;
    else
        %Agregamos un vector columna a la matriz aux
        aux = [aux, a];
        
        %Restamos los 2 vectores columna y lo guardamos en la bandera
        flag = aux (:,iteracion) - aux (:, iteracion - 1);
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
fprintf ('La RNA convergió en la iteración %d a la clase numero %d\n', iteracion - 1, i);

%Cerramos los archivos
fclose (archivo_matriz);
fclose (nuevo);

%Borramos todas las variables creadas durante la ejecución del programa
clear;
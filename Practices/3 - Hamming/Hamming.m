%Limpiamos la pantalla y borramos todas las variables creadas anteriormente
clc;
clear;

%Recibimos el nombre del archivo como un String (por eso la 's')
archivo = input ('Introduce el nombre del archivo: ', 's');

%Abrimos el archivo que contiene la matriz a usar en modo lectura
archivo_matriz = fopen (archivo, 'r');

%Recibimos el número de filas y columnas que tiene la matriz para lectura
num_filas = input ('Ingresa el número de patrones prototipo (filas) que tiene la matriz: ');
num_col = input ('Ingresa el número de rasgos de cada patron (columas) que tiene la matriz: ');

%Creamos una matriz para el bias
bias = zeros (num_filas,1);
bias = bias + num_col

while ~feof (archivo_matriz)
    [aux, cont] = fscanf (archivo_matriz, '%f', [num_col num_filas]);
end

aux = aux'
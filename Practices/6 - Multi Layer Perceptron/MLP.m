%Limpieza de pantalla
clc

%Pedir al usuario el archivo de entrada (input.txt)
archivo = input ('Ingresa el archivo de entrada: ', 's');
%p = importdata (archivo);

%Pedir al usuario el archivo de valores deseados (target.txt)
archivo = input ('Ingresa el archivo de los valores deseados: ', 's');
%target = importdata (archivo);

%Pedir al usuario el rango de la señal
rango = input ('Ingresa el rango de la señal a aproximar: ', 's');
rango = str2num (rango);

%Pedir al usuario la arquitectura del MLP (Máximo 3 capas ocultas)
arquitectura = input ('Ingresa la arquitectura separada por espacios: ', 's');
arquitectura = str2num (arquitectura);

%Pedir al usuario las funciones de activacion
fprintf ('Ingresa las funciones de activacion, donde:\n');
funciones_activacion = input ('1. Purelin    2. Logsig    3. Tansig\n', 's');
funciones_activacion = str2num (funciones_activacion);

%Pedir al usuario el valor del factor de aprendizaje (alpha)
alpha = input ('Ingresa el valor del factor de aprendizaje (alpha): ');

%________________________CONDICIONES DE FINALIZACION_______________________
clc
itmax = input ('Ingresa el numero máximo de iteraciones (itmax): ');
Eit = input ('Ingresa el valor mínimo del error por iteracion (Eit): ');
itval = input ('Ingresa cuantas iteraciones se realizará una de validación (itval): ');
numval = input ('Ingresa el valor máximo de incrementos consecutivos en el error de validación (numval): ');

%________________________DIVISION EN 3 SUBCONJUNTOS________________________
clc
fprintf ('Elija la distribución de los datos.\n\n');
opcion = input ('1. 80 - 10 - 10\n2. 70 - 15 - 15\n\n');
%numero_datos = size (p);
%numero_datos = numero_datos (1, 1);
%valores = randperm (numero_datos);
%[entrenamiento, valores] = datos_entrenamiento (opcion, valores, p, target);
%[validacion, prueba] = datos_validacion_prueba (valores, p, target);

%Tamaño del vector de entrada p
R = arquitectura (1, 1);
%Calculamos el numero de capas que tendra el MLP
num_capas = size (funciones_activacion);
num_capas = num_capas (1, 2);

%Asignamos espacio a las matrices de pesos y bias
W = cell (num_capas, 1);
b = cell (num_capas, 1);

%Asignar valores entre -1 y 1 a los pesos y bias
for i = 1:num_capas
    W {i} = -1 + 2 * rand (arquitectura (i + 1), arquitectura (i));
    b {i} = -1 + 2 * rand (arquitectura (i + 1), 1);
end

fprintf ('Matrices de pesos\n');
disp (W);
fprintf ('\nBias\n');
disp (b);

%Espacio en un rango definido por el usuario con 100 puntos
t = linspace (rango (1, 1), rango (1, 2), 100);
j = 1;
i = 1;

while i <= 8
    %
    
    %Graficamos la señal original y la obtenida con el MLP
    seno = (1 + sin ((i * pi * t) / 4));
    hold on;
    subplot (2, 2, j), plot (t, seno, 'b-');
    %subplot (2, 2, j), plot (t, aproximada, 'r-');
    hold off;
    
    %Actualizacion de contadores
    i = (i * 2);
    j = (j + 1);
end

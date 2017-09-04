%Limpiamos el command window para una mejor presentación
clc

%Guardamos en n el valor introducido por el usuario
n = input ('Introduce el numero de elementos de la serie Fibonacci: ');

%Declaramos 2 arreglos de ceros
aux1 = zeros (1, n); aux2 = zeros (1, n);

%Asignamos los valores iniciales al arreglo correspondientes a los primeros
%2 elementos de la serie de Fibonacci
aux1 (1) = 0; aux1 (2) = 1;
aux2 (1) = 1; aux2 (2) = 2;

%Imprimimos los primeros 2 elementos del arreglo
fprintf ('%d\n%d\n',aux1 (1), aux1(2))

%Comienza el algoritmo para mostrar n elementos de la serie fibonacci
for i = 3:(n)
    aux1 (i) = aux1 (i - 1) + aux1 (i - 2);
    aux2 (i) = i;
    fprintf ('%d\n',aux1 (i))
end

%Graficamos el vector aux1 que representa a la serie, cada punto marcado 
%con un circulo y unidos por una linea recta en color verde
plot (aux2, aux1, 'go-')
title ('Fibonacci');
xlabel ('n');
ylabel ('f(n)');

clear aux1; clear aux2; clear i;
%Comenzamos limpiando la pantalla y todas las variables
clearvars
clc

%Pedimos los valores dados por el usuario para realizar el aprendizaje de
%una RNA Adaline de un codificador de binario a decimal de 3 bits sin bias
it_max = input ('Ingresa el numero m�ximo de iteraciones: ');
e_it = input ('Ingresa el valor al que deseas llegar la se�al del error: ');
alpha = input ('Ingresa el valor de alfa: ');

%Asignamos valores aleatorios a la matriz de pesos W con la funci�n rand
%W = rand (1, 3);
W = [0.84 0.39 0.78];
errores = zeros (1,8);
k = zeros (1, 1);

%Comenzamos a realizar la propagaci�n hacia adelante de todos los datos
for i = 1:8
    %Convertimos a k a un n�mero binario de 3 bits
    p = dec2bin (k, 3);
    
    %Transponemos el vector, para que sea un vector columna
    p = p';
    
    %Conertimos los elementos a numero para realizar la multiplicaci�n
    p = str2num (p);
    
    %Realizamos la multiplicacion de las matrices
    a = purelin (W * p);
    
    %Obtenemos el error para este dato
    errores (i) = (k - a);
    
    %Actualizamos el valor de la matriz de pesos
    W = W + ((2 * alpha * errores (i)) * p');
    
    sprintf ('Para el dato %d, el valor de a es: %.4f\n', i, a)
    k = k + 1;
end









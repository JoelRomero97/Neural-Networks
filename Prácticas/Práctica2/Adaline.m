%Pedimos los valores dados por el usuario para realizar el aprendizaje de
%una RNA Adaline de un codificador de binario a decimal de 3 bits sin bias
iteracion_maxima = input ('Ingresa el numero m�ximo de iteraciones: ');
e_it = input ('Ingresa el valor al que deseas llegar la se�al del error: ');
alpha = input ('Ingresa el valor de alfa: ');

%Asignamos valores aleatorios a la matriz de pesos W con la funci�n rand
W = rand (1, 3);

%Comenzamos a realizar la propagaci�n hacia adelante de todos los datos

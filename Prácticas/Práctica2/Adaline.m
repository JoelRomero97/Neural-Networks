%Comenzamos limpiando la pantalla y todas las variables
clearvars
clc

%Pedimos los valores dados por el usuario para realizar el aprendizaje de
%una RNA Adaline de un codificador de binario a decimal de 3 bits sin bias
it_max = input ('Ingresa el numero máximo de iteraciones: ');
e_it = input ('Ingresa el valor al que deseas llegar la señal del error: ');
alpha = input ('Ingresa el valor de alfa: ');

%Asignamos valores aleatorios a la matriz de pesos W con la función rand
W = rand (1, 3);
%W = [0.84 0.39 0.78];
errores = zeros (1,8);
figure('Name','Red Adaline','NumberTitle','off');

for j = 1:it_max
    %k será un 0 cada iteración para convertir a binario
    k = zeros (1, 1);
    %Comenzamos a realizar la propagación hacia adelante de todos los datos
    for i = 1:8
        hold on;
        subplot (2,5,j),plot (W, 'r*-');
        grid, ylabel('W [i]'), xlabel('i');
        title (['\fontsize{16} \color[rgb]{0 .5 .5}Iteracion ' int2str(j)]);
        
        %Convertimos a k a un número binario de 3 bits
        p = dec2bin (k, 3);

        %Transponemos el vector, para que sea un vector columna
        p = p';

        %Conertimos los elementos a numero para realizar la multiplicación
        p = str2num (p);

        %Realizamos la multiplicacion de las matrices
        a = purelin (W * p);

        %Obtenemos el error para este dato
        errores (i) = (k - a);

        %Actualizamos el valor de la matriz de pesos
        W = W + ((2 * alpha * errores (i)) * p');

        k = k + 1;
    end
    %Verificamos las condiciones de paro para el aprendizaje sumando los
    %valores del vector de los errores individuales con sum y dividiendo
    %entre el numero de datos que en este caso es 8
    Error_Global = (1 / 8) * (sum (errores));
    
    %Si el error global es 0, el aprendizaje obtenido es el ideal
    if Error_Global == 0
        sprintf ('Se cumplió un aprendizaje ideal en la iteración %d', j)
        break;
    
    %Si el error global es menor al error introducido por el usuario, el 
    %aprendizaje obtenido es 2/3 de exitoso
    elseif Error_Global < e_it
        sprintf ('Se obtuvo un aprendizaje aceptable en la iteración %d', j)
        break;
    end
    
    %Reseteamos el valor del error global a 0
    Error_Global = 0;
end

clearvars
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
W1 = zeros (1, 9);
W2 = zeros (1, 9);
W3 = zeros (1, 9);
%W = [0.84 0.39 0.78];
fprintf ('\n\nLos valores iniciales de la matriz de pesos son: ')
disp (W);
errores = 0;
Pesos = figure('Name','Red Adaline - Matriz de Pesos','NumberTitle','off');
Error = figure('Name','Red Adaline - Señal del error','NumberTitle','off');
rango = 0:8;
W1 (1) = W (1);
W2 (1) = W (2);
W3 (1) = W (3);
Error_It = 0;
Error_Global = zeros (1, 9);
for j = 1:it_max
    %k será un 0 cada iteración para convertir a binario
    k = zeros (1, 1);
    fprintf ('\n\n\nIteración número %d\n', j)
    %Comenzamos a realizar la propagación hacia adelante de todos los datos
    for i = 1:8
        
        %Convertimos a k a un número binario de 3 bits
        p = dec2bin (k, 3);

        %Transponemos el vector, para que sea un vector columna
        p = p';

        %Conertimos los elementos a numero para realizar la multiplicación
        p = str2num (p);
        
        Error_Global (i) = Error_It;

        %Realizamos la multiplicacion de las matrices
        a = purelin (W * p);
        fprintf ('a = %.4f\n', a)

        %Obtenemos el error para este dato
        errores = (k - a);
        fprintf ('error = %.4f\n\n', errores)

        %Actualizamos el valor de la matriz de pesos
        W = W + ((2 * alpha * errores) * p');

        k = k + 1;
        
        %Actutalizamos los valores de los pesos
        W1 (i + 1) = W (1);
        W2 (i + 1) = W (2);
        W3 (i + 1) = W (3);
        
        %Actualizamos el valor del error
        Error_It = Error_It + ((1/8) * errores);
    end
    
    Error_Global (9) = Error_It;
    
    %Pintamos en el figure de la señal del error
    figure (Error);
    hold on;
    subplot (2, ceil(it_max / 2), j),plot (rango, Error_Global, 'o-');
    grid, ylabel('Error'), xlabel('Dato');
    title (['\fontsize{16} \color[rgb]{0 .5 .5}Iteracion ' int2str(j)]);
    
    %Pintamos en el figure de la matriz de pesos
    figure (Pesos);
    hold on;
    subplot (2, ceil(it_max / 2), j),plot (rango, W1, rango, W2, rango, W3, '*-');
    grid, ylabel('W'), xlabel('Dato');
    title (['\fontsize{16} \color[rgb]{0 .5 .5}Iteracion ' int2str(j)]);
    
    %Si el error global es 0, el aprendizaje obtenido es el ideal
    if Error_It == 0
        fprintf ('Se cumplió un aprendizaje ideal en la iteración %d\n', j)
        break;
    
    %Si el error global es menor al error introducido por el usuario, el 
    %aprendizaje obtenido es 2/3 de exitoso
    elseif Error_It < e_it
        fprintf ('Se obtuvo un aprendizaje aceptable en la iteración %d\n', j)
        break;
    end
    
    %Reseteamos el valor del error global a 0
    Error_It = 0;
end

clearvars
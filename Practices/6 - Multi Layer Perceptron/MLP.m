%Limpieza de pantalla y variables
clc
clear

%Pedir al usuario el archivo de entrada (input.txt)
archivo = input ('Ingresa el archivo de entrada: ', 's');
p = importdata (archivo);

%Pedir al usuario el archivo de valores deseados (target.txt)
archivo = input ('Ingresa el archivo de los valores deseados: ', 's');
target = importdata (archivo);

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
numero_datos = size (p);
numero_datos = numero_datos (1, 1);
valores = randperm (numero_datos);
[entrenamiento, valores] = datos_entrenamiento (opcion, valores, p, target);
[validacion, prueba] = datos_validacion_prueba (valores, p, target);

%Obtenemos el numero de elementos de cada subconjunto
numero_datos_entrenamiento = size (entrenamiento);
numero_datos_entrenamiento = numero_datos_entrenamiento (1, 1);
numero_datos_validacion = size (validacion);
numero_datos_validacion = numero_datos_validacion (1, 1);
numero_datos_prueba = size (prueba);
numero_datos_prueba = numero_datos_prueba (1, 1);

%Tamaño del vector de entrada p
R = arquitectura (1, 1);
%Calculamos el numero de capas que tendra el MLP
num_capas = size (funciones_activacion);
num_capas = num_capas (1, 2);

%Asignamos espacio a las matrices de pesos y bias
W = cell (num_capas, 1);
b = cell (num_capas, 1);

%________________________ARCHIVOS PARA GRAFICACIÓN_________________________
total_archivos_pesos = 0;
total_archivos_bias = 0;
for i = 1:num_capas
    for j = 1:(arquitectura (i+1))
        for l = 1:(arquitectura (i))
            total_archivos_pesos = (total_archivos_pesos + 1);
        end
    end
    total_archivos_bias = (total_archivos_bias + 1);
end

archivos_W = zeros (total_archivos_pesos, 1);
archivos_b = zeros (total_archivos_bias, 1);

%Abrir archivos de pesos
archivo_i = 1;
for i = 1:num_capas
    path = strcat (pwd, '/Capa ', num2str(i), '/Pesos/');
    if ~exist (path, 'dir')
        mkdir (path);
    end
    for j = 1:(arquitectura (i + 1))
        for k = 1:(arquitectura (i))
            archivo = strcat (path, '/Pesos', num2str (j), '_', num2str (k), '.txt');
            archivos_W (archivo_i) = fopen (archivo, 'w');
            archivo_i = (archivo_i + 1);
        end
    end
end

%Abrir archivos de bias
archivo_i = 1;
for i = 1:num_capas
    path = strcat (pwd, '/Capa ', num2str(i), '/Bias/');
    if ~exist (path, 'dir')
        mkdir (path);
    end
    for j = 1:(arquitectura (i + 1))
        archivo = strcat (path, '/Bias', num2str (j), '.txt');
        archivos_b (archivo_i) = fopen (archivo, 'w');
        archivo_i = (archivo_i + 1);
    end
end

%Asignar valores entre -1 y 1 a los pesos y bias
archivo_Wi = 1;
archivo_bi = 1;
for i = 1:num_capas
    W {i} = -1 + 2 * rand (arquitectura (i + 1), arquitectura (i));
    b {i} = -1 + 2 * rand (arquitectura (i + 1), 1);
    
    %Valores iniciales de pesos y bias en los archivos correspondientes
    for j = 1:(arquitectura (i + 1))
        for k = 1:(arquitectura (i))
            fprintf (archivos_W (archivo_Wi), '%.4f\r\n', W {i} (j, k));
            archivo_Wi = (archivo_Wi + 1);
        end
    end
    for j = 1:(arquitectura (i + 1))
        fprintf (archivos_b (archivo_bi), '%.4f\r\n', b {i} (j, 1));
        archivo_bi = (archivo_bi + 1);
    end
end

%Para guardar salidas, sensitividades y derivadas de cada capa
a = cell (num_capas + 1, 1);
S = cell (num_capas, 1);
F_m = cell (num_capas, 1);

%Se inicializan los errores de validacion
flag = 0;
error_validacion_anterior = 0;
error_final_aprendizaje = 0;
incrementos_consecutivos = 0;

%Se inicializan matrices para errores
grafica_error_aprendizaje = zeros (itmax, 1);
grafica_error_validacion = zeros (ceil (itmax / itval), 1);
total_iteraciones_validacion = 0;

%_________________________ALGORITMO DE APRENDIZAJE_________________________
for iteracion = 1:itmax
    %Se resetea el valor del archivo W y b
    archivo_bi = 1;
    archivo_Wi = 1;
    
    %Se resetea el valor del error de aprendizaje
    error_aprendizaje = 0;
    
    %Si es iteracion de validacion, debe ser multiplo de itval
    if mod (iteracion, itval) == 0
        total_iteraciones_validacion = (total_iteraciones_validacion + 1);
        error_validacion_actual = 0;
        %Propagacion de los datos
        for dato = 1:numero_datos_validacion
            
            %Dato a propagar hacia adelante
            a {1} = validacion (dato, 1);
            
            %Propagacion hacia adelante del dato
            for i = 1:num_capas
                a {i + 1} = funcion (W {i, 1}, a {i, 1}, b {i, 1}, funciones_activacion (1, i));
            end
            
            %Se calcula el error de validacion para el dato i
            error_dato = (validacion (dato, 2) - a {num_capas + 1, 1});
            %error_dato = abs (error_dato);
            %Se suma el error de validacion de cada dato
            error_validacion_actual = (error_validacion_actual + error_dato);
        end
        error_validacion_actual = (error_validacion_actual / numero_datos_validacion);
        
        grafica_error_validacion (iteracion) = error_validacion_actual;
        
        %Si ya hubo un incremento en el error de validacion
        if (error_validacion_actual > error_validacion_anterior)
            incrementos_consecutivos = incrementos_consecutivos + 1;
            if incrementos_consecutivos < numval
                %Actualizacion del error anterior
                error_validacion_anterior = error_validacion_actual;
                error_validacion_actual = 0;
            else
                fprintf ('No se obtuvo un aprendizaje correcto de la red\n');
                flag = 1;
                fprintf ('\nEarly Stopping en la iteración %d\n', iteracion);
                break;
            end
        else
            error_validacion_anterior = error_validacion_actual;
            incrementos_consecutivos = 0;
        end
    else
        for dato = 1:numero_datos_entrenamiento
            %Dato a propagar hacia adelante
            a {1} = entrenamiento (dato, 1);
            
            %Propagacion hacia adelante del dato
            for i = 1:num_capas
                a {i + 1} = funcion (W {i, 1}, a {i, 1}, b {i, 1}, funciones_activacion (1, i));
            end
            
            %Se calcula el error de validacion para el dato i
            error_dato = (entrenamiento (dato, 2) - a {num_capas + 1, 1});
            %error_dato = abs (error_dato);
            %Se suma el error de validacion de cada dato
            error_aprendizaje = (error_aprendizaje + error_dato);
            error_aprendizaje = (error_aprendizaje / numero_datos_entrenamiento);
            
            %Calculo de sensitividades
            F_m {num_capas} = matriz_F (funciones_activacion (1, num_capas), arquitectura (1, num_capas + 1), a {num_capas + 1, 1});
            S {num_capas} = (-2 * F_m {num_capas} * error_dato);
            
            %Algoritmo Back Propagation
            for i = (num_capas - 1):-1:1
                F_m {i} = matriz_F (funciones_activacion (1, i), arquitectura (1, i + 1), a {i + 1, 1});
                S {i} = F_m {i, 1} * (W {i+1, 1})' * S {i + 1, 1};
            end
            
            %Actualizacion de pesos y bias
            for i = num_capas:-1:1
                W {i, 1} = (W {i, 1} - (alpha * S {i, 1} * (a {i, 1})'));
                b {i, 1} = (b {i, 1} - (alpha * S {i, 1}));
            end
        end
        error_final_aprendizaje = error_aprendizaje;
        
        grafica_error_aprendizaje (iteracion) = error_aprendizaje;
    end
    
    %Imprimir valores de pesos y bias en archivo correspondiente
    archivo_Wi = 1;
    archivo_bi = 1;
    for k = num_capas:-1:1
        for j = 1:(arquitectura (k + 1))
            for l = 1:(arquitectura (k))
                fprintf (archivos_W (archivo_Wi), '%.4f\r\n', W {k}(j, l));
                archivo_Wi = (archivo_Wi + 1);
            end
        end
        for j = 1:(arquitectura (k + 1))
            fprintf (archivos_b (archivo_bi), '%.4f\r\n', b {k}(j, 1));
            archivo_bi = (archivo_bi + 1);
        end
    end
    
    %Condiciones de finalización por iteración
    if error_aprendizaje < Eit && error_aprendizaje > 0
        fprintf ('Se obtuvo un aprendizaje exitoso en la iteracion: %d\n', iteracion);
        break;
    end
end

if flag == 1
    archivo_Wi = 1;
    archivo_bi = 1;
    for k = num_capas:-1:1
        for j = 1:(arquitectura (k + 1))
            for l = 1:(arquitectura (k))
                fprintf (archivos_W (archivo_Wi), '%.4f\r\n', W {k}(j, l));
                archivo_Wi = (archivo_Wi + 1);
            end
        end
        for j = 1:(arquitectura (k + 1))
            fprintf (archivos_b (archivo_bi), '%.4f\r\n', b {k}(j, 1));
            archivo_bi = (archivo_bi + 1);
        end
    end
end

%______________________CERRAR ARCHIVOS DE PESOS Y BIAS_____________________
for i = 1:total_archivos_pesos
    fclose (archivos_W (i));
end

for i = 1:total_archivos_bias
    fclose (archivos_b (i));
end

%______________________PROPAGACION CONJUNTO DE PRUEBA______________________
error_prueba = 0;
salida = ones (numero_datos_prueba, 1);
for i = 1:numero_datos_prueba
    a {1} = prueba (i, 1);
    for k = 1:num_capas
        a {k + 1} = funcion (W {k, 1}, a {k, 1}, b {k, 1}, funciones_activacion (1, k));
    end
    aux = (prueba (i, 2) - a {num_capas + 1, 1});
    %aux = abs (aux);
    error_prueba = error_prueba + (aux / numero_datos_prueba);
    salida (i) = a {num_capas + 1, 1};
end

%Impresion final de valores de los errores
fprintf ('Error final de aprendizaje = %.4f\n', error_final_aprendizaje);
fprintf ('Error final de validacion = %.4f\n', error_validacion_anterior);
fprintf ('Error final de prueba = %.4f\n', error_prueba);

%________________________________GRAFICACIÓN_______________________________
%ERRORES DE APRENDIZAJE Y VALIDACIÓN
Prueba_Errores = figure ('Name', 'Errores de aprendizaje y validación');
figure (Prueba_Errores);
grid on;
rango = 1:1:iteracion;
rango_aux = itval:itval:(itval * total_iteraciones_validacion);
%Verde oscuro
contorno_validacion = [0 0.4980 0];
%Verde claro
relleno_validacion = [0 1 0];
scatter (rango_aux, grafica_error_validacion (itval:itval:total_iteraciones_validacion*itval,1), 'MarkerEdgeColor',contorno_validacion, 'MarkerFaceColor', relleno_validacion, 'LineWidth',1.5);
hold on;
%Azul oscuro
contorno_aprendizaje = [0.0784 0.1686 0.5490];
%Azul claro
relleno_aprendizaje = [0 0.7490 0.7490];
scatter (rango, grafica_error_aprendizaje (1:iteracion,1), 'MarkerEdgeColor',contorno_aprendizaje, 'MarkerFaceColor', relleno_aprendizaje, 'LineWidth',1.5);
title ('Errores de aprendizaje y validacion');
xlabel ('Iteracion');
ylabel ('Valor del error');
legend ('Error validacion', 'Error aprendizaje');

%CONJUNTO DE PRUEBA CON TARGET
Prueba_Graph = figure ('Name', 'Conjunto de prueba');
figure (Prueba_Graph);
grid on;
rango = prueba (:, 1);
%Verde oscuro
contorno_salida = [0 0.4980 0];
%Verde claro
relleno_salida = [0 1 0];
scatter (rango, salida, 'MarkerEdgeColor',contorno_salida, 'MarkerFaceColor', relleno_salida, 'LineWidth',1.5);
hold on;
%Azul oscuro
contorno_target = [0.0784 0.1686 0.5490];
%Azul claro
relleno_target = [0 0.7490 0.7490];
scatter (rango, prueba (:, 2), 'MarkerEdgeColor',contorno_target, 'MarkerFaceColor', relleno_target, 'LineWidth',1.5);
title ('Conjunto de prueba');
xlabel ('p');
ylabel ('f (p)');
legend ('Salida del MLP', 'Target');

%PESOS
Pesos_Graph = figure ('Name', 'Evolución de los pesos');
grid on;
for i = 1:num_capas
    figure (Pesos_Graph);
    path = strcat (pwd, '/Capa ', num2str(i), '/Pesos/');
    for j = 1:(arquitectura (i + 1))
        for k = 1:(arquitectura (i))
            archivo = strcat (path, '/Pesos', num2str (j), '_', num2str (k), '.txt');
            simb = strcat('W(',num2str(j),',',num2str(k),')');
            evolucion_pesos = importdata(archivo);
            plot(evolucion_pesos','DisplayName',simb);
            hold on;
        end
    end
    titulo = strcat('Pesos - capa',{' '},num2str(i));
    title(titulo);
    ylabel('W');
    xlabel('Iteracion');
    hold off
end

%BIAS
rango = 0:1:iteracion;
Bias_Graph = figure ('Name', 'Evolución de los bias');
grid on
for i = 1:num_capas
    figure (Bias_Graph);
    path = strcat (pwd, '/Capa ', num2str(i), '/Bias/');
    for j = 1:(arquitectura (i+1))
        archivo_bias = strcat (path, '/Bias', num2str (j), '.txt');
        simb = strcat('b(',num2str(j),')');
        evolucion_bias = importdata (archivo_bias); % Identificador para la grafica
        plot(rango, evolucion_bias','DisplayName', simb);
        hold on
    end
    titulo = strcat('Bias - capa',{' '},num2str(i));
    title(titulo);
    ylabel('b');
    xlabel('Iteracion');
    hold off
end

%ENTRENAMIENTO
figure
rango = entrenamiento(:,1);
%Verde oscuro
contorno_salida = [0 0.4980 0];
%Verde claro
relleno_salida = [0 1 0];
plot(salida,'MarkerEdgeColor',contorno_salida, 'MarkerFaceColor', relleno_salida, 'LineWidth',1.5);
grid on
hold on
%Azul oscuro
contorno_target = [0.0784 0.1686 0.5490];
%Azul claro
relleno_target = [0 0.7490 0.7490];
plot(entrenamiento(:,2),'MarkerEdgeColor',contorno_target, 'MarkerFaceColor', relleno_target, 'LineWidth',1.5);
title('Conjunto de entrenamiento');
ylabel('f(p)');
xlabel('p');
legend('Salida del MLP','Targets');
hold off


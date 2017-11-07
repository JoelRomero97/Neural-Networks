function conjunto = genera_conjunto (numero_bits, numero_datos)
    conjunto = zeros (numero_datos, numero_bits + 1);
    for i = 0:(numero_datos - 1)
        %Convertimos cada numero en un numero binario de n bits
        binario = dec2bin (i, numero_bits);
        
        for j = 1:numero_bits
            %Agregamos el numero binario a cada fila
            conjunto ((i + 1), j) = str2num (binario (:, j));
        end
        
        %En la última columna, ponemos el valor decimal
        conjunto ((i + 1), (numero_bits + 1)) = i;
    end
end
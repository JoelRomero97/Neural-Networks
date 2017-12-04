function F = matriz_F (funcion, neuronas, a)
    if funcion == 1
        %Purelin
        F = diag (ones (1, neuronas));
    elseif funcion == 2
        %Logsig
        F = diag (logsig ('dn', a, a));
    else
        %Tansig
        F = diag (tansig ('dn', a, a));
    end
end


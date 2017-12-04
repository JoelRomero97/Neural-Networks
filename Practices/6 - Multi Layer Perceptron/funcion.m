function a = funcion (W, a, b, funcion)
    if funcion == 1
        %Purelin
        a = purelin ((W * a) + b);
    elseif funcion == 2
        %Logsig
        a = logsig ((W * a) + b);
    else
        a = tansig ((W * a) + b);
    end
end
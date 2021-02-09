function angulo = referencia_cabeza(amplitud,tiempo,desfase,periodo)
    if tiempo<desfase
        angulo=0;
    elseif tiempo>desfase+periodo
        angulo=0;
    else
        angulo=amplitud*sin((tiempo-desfase)*((2*pi)/periodo));
    end
end
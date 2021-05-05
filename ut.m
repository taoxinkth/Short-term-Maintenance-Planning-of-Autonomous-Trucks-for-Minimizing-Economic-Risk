%utility function of availability loss

function uu= ut(up,pe_max,t_max)
if up<2
    uu=0;
else if up>t_max
        uu=pe_max;
    else uu=100*(up-2);
end
end
end



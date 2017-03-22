function [df] = argmin_d(sf, mu, Lf, Mx, Mf)

d =  ifftvec(sf + (1/mu)*Lf, Mx , Mf) ;
df = fftvec(d(:), Mf, Mx);

end



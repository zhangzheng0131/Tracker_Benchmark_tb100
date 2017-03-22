function [sf] = argmin_s(df, mu, Lf, MMx, Nf, ZX, ZZ)


  lambda = 10;
  ZZ = ZZ + (mu + lambda) *ones(size(ZZ));
  ZX = ZX + (mu*df) - Lf;
  sf = ZX./ZZ;

end
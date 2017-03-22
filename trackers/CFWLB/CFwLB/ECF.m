

function [df sf Ldsf mu] = ECF(X, Mx, Nf, Mf, term, minItr, maxItr, sf, df, Ldsf, ZZ, ZX, Visfilt)

[MMx Nx] = size(X);
MMf = prod(Mf);
% Visfilt = 0;
% ----------------------------------------
% get the lagrange multipliers
mu    = 0.01;
mumax = 20;
i = 1;
 o = zeros(maxItr,1);
% ----------------------------------------
% ALTERNATION!
% ----------------------------------------

while (i <=maxItr) || (1 > term && i <= maxItr)

    %   ADMM
    [sf] = argmin_s(df, mu, Ldsf, MMx, Nf, ZX, ZZ);
    [df] = argmin_d(sf, mu, Ldsf, Mx, Mf);
    Ldsf = Ldsf + (mu * (sf - df));
    mu = min(1.1 * mu, mumax);

    % ----------------------------------------
    % Visualizing the filters

    if Visfilt
        d  = ifftvec(reshape(df, MMx, Nf), Mx, Mf);
        s  = ifftvec(reshape(sf, MMx, Nf), Mx);
        figure(1);
        for n = 1:Nf
            subplot(121);
            imagesc(reshape(d(:,n), Mf));
            title(['Compact filter, size: ' '[' num2str(Mf(1)) ',' num2str(Mf(2)) ']']);
            colormap gray; axis image; axis off;
        end
        for n = 1:Nf
            subplot(122);
            imagesc(reshape(s(:,n), Mx));
            title(['Original filter, size: ' '[' num2str(Mx(1)) ',' num2str(Mx(2)) ',' num2str(i) ']' ]);
            colormap gray; axis image;  axis off;
        end
        pause(.05);
    end;
%     o(i) =  objective(df, MMx, Nx, Nf, X, ZX, ZZ);
    i = i+1;

end
% figure(4); plot(o);
end

% ----------------------------------------
% HELPER FUNCTIONS
% ----------------------------------------
%
function o = objective(sf, MMx, Nx, Nf, yf, xy, xx)
% o = abs(yf-2*conj(sf')*xy+sf'*xx*sf)/(Nf*Nx*MMx);
o  = norm(yf - sf.*xx)/MMx;
end



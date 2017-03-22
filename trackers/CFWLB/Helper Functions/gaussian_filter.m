%This program generates the 2D gaussian filter.
%To generate the filter,code should be written as f=gaussian_filter(size_of_kernel,sigma);
%This code was developed by Vivek Singh Bhadouria, NIT-Agartala India on 4
%August 2011, 12:59AM (E-mail:vivekalig@gmail.com)
function rsp=gaussian_filter(n,s, pos)
% close all;
rsp=zeros(n);
for i=1:n(1)
    for j=1:n(2)       
       rsp(i,j) = exp( -((i-pos(1)).^2+(j-pos(2)).^2)/(2*s^2) );        
    end;
end;
rsp = rsp + abs(min(rsp(:)));
rsp = rsp / max(rsp(:));
% rsp = reshape(rsp,prod(n),1);
end 
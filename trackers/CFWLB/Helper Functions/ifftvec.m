% ifftvec
%   x = ifftvec(xf, mn) computes the 2D ifft of a vectorised input, where x
%   is the input, and mn is its regular size [m n]. The returned output is
%   also vectorised
%   x = fftvec(xf, mn, crop) crops the final spatial output before 
%   returning. This is useful transforming signals that previously been
%   padded to a larger size with fftvec(x, mn, pad)
%
%   See also fftvec
function x = ifftvec(xf, mn, varargin)
  [M, N] = size(xf);
  if nargin == 3
    crop  = varargin{1};
    M = prod(crop); 
    x = zeros(M, N);
    for n=1:N
        ff=ifft2(reshape(xf(:,n), mn),'symmetric');
        x(:,n) = reshape(ff( 1:crop(1), 1:crop(2)), M, 1); 
    end
  else
    x = zeros(M, N);
    for n=1:N, x(:,n) = reshape(ifft2(reshape(xf(:,n), mn),'symmetric'), M, 1); end
  end  
end
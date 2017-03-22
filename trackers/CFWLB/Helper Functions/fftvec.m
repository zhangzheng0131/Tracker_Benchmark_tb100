% fftvec
%   xf = fftvec(x, mn) computes the 2D fft of a vectorised input, where x
%   is the input, and mn is its regular size [m n]. The returned output is
%   also vectorised
%   xf = fftvec(x, mn, pad) pads the input to size pad before taking the
%   fft
%
%   See also ifftvec
function xf = fftvec(x, mn, varargin)
  [M, N] = size(x);
  if nargin == 3
    pad = varargin{1};
    M  = prod(pad);
    xf = zeros(M, N);
    for n=1:N, xf(:,n) = reshape(fft2(reshape(x(:,n), mn), pad(1), pad(2)), M, 1); end
  else
    xf = zeros(M, N);
    for n=1:N,
        xf(:,n) = reshape(fft2(reshape(x(:,n), mn)), M, 1);
    end
  end  
end
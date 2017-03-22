function IT = affineTransform(I, varargin)
% affineTransform 2D Image Projective Transform
%   IT = affineTransform(I, translation, rotation, scale, shear)
%   performs a projective transform on the grayscale input image and
%   outputs the resulting image
%
%   I is the grayscale input image
%
%   TRANSLATION is a vector [tx ty] defining the amount of translation to 
%   apply in pixels
%
%   ROTATION is a scalar defining the rotation in degrees. Positive angles
%   are anticlockwise.
%
%   SCALE is a vector [sx sy] defining the scale factor to apply
%
%   SHEAR is a vector [sv sh] defining the shear factor to apply
%
%   IT = affineTransform(I, T) uses the predefined 3x2 affine transform
%   matrix T
%
%   See also findAffineTransform

% determine the Tmatrix
if nargin == 2, Tmatrix = varargin{1}; end
if nargin == 5
    trans = varargin{1};
    theta = varargin{2};
    scale = varargin{3};
    shear = varargin{4};
    
    Tmatrix = [scale(1)*cosd(theta)     -scale(2)*sind(theta);
               scale(1)*sind(theta)     scale(2)*cosd(theta) ;
               trans(1)                 trans(2)             ];
end

% apply the transform to the image and rescale
Isize   = size(I);
Isize   = Isize(1:2);
bounds  = [[1; 1] Isize'];
%ITSize  = [0 Isize(1); 0 Isize(2); 0 0]' * Tmatrix;
%centroid= mean(ITSize);
%ITSize  = transpose([mean(ITSize)-Isize/2; mean(ITSize)+Isize/2]);
T       = maketform('affine', Tmatrix);
IT      = imtransform(I, T, 'FillValues', 0, 'Size', Isize, ...
                      'XData', bounds(2,:),'YData', bounds(1,:));
function [imgs] = get_ini_perturbation(im, nop)
for i=1:nop
    low = -(2); high = (2);
    angle_rot = low + (high-low) * rand;
    low = 1; high = 1;
    scale = low + (high-low) * rand;
    low = -1; high = 1;
    x_shift = fix(low + (high-low) * rand);
    y_shift = x_shift ;
    pertIm = affineTransform(im, [x_shift y_shift], angle_rot, [scale scale], [1 1] );
%     imagesc(pertIm); axis off; axis image;colormap gray;  pause(1);
    imgs(:,i) = reshape(double(pertIm), [],1);
end;
end
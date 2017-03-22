function [PSR] = Get_PSR(im, in_lobe_sz, out_lobe_sz)

im = im + abs(min(im(:)));
im = im / max(im(:));
[crd_x crd_y] = find(im == max(im(:)));

gmax = max(max(im));
[ys xs out] = get_subwindow2(im, [crd_x crd_y], in_lobe_sz );

% Im(max(maxCrd(1)-2,maxCrd(1)) :min(maxCrd(1)+2, maxCrd(1)), max(maxCrd(2)-2, maxCrd(2)):min(maxCrd(2)+2, maxCrd(2)))= NaN;
im(ys, xs) = NaN;
[yos xos out_lobe] = get_subwindow2(im, [crd_x crd_y], out_lobe_sz);
nan_l = find(~isnan(out_lobe));
mus1 = mean(out_lobe(nan_l)); 
s1 = std(out_lobe(nan_l));
PSR = abs(gmax-mus1)/s1; 
% PSR = s1;

end
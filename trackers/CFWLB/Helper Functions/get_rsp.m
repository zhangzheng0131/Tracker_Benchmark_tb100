function [rsp pos] = get_rsp( cropIm, df, s_filt_size, b_filt_size)

d = ifftvec(df, b_filt_size, s_filt_size);
df = fftvec(d, s_filt_size, b_filt_size);
rsp = fftvec(cropIm(:), b_filt_size).*df;
rsp = reshape(rsp, b_filt_size);
rsp = reshape(ifftvec(rsp(:), b_filt_size), b_filt_size);
rsp = circshift(rsp, -fix(s_filt_size/2));
[x y] = find(rsp == max(rsp(:)),1);
pos = [x y];
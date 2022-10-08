function [A,D] = dwt_analysis(im,wname)
[LoD,HiD,~,~] = wfilters(wname);
% periodically extension
s_ext = wextend('1','sym',im,length(wname)-1);
A1 = conv(s_ext,LoD,'same');
D1 = conv(s_ext,HiD,'same');
A_cut = A1(length(wname)-1:end-length(wname));
D_cut = D1(length(wname)-1:end-length(wname));
% downsampling
A = downsample(A_cut,2);
D = downsample(D_cut,2);
end


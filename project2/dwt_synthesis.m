function [recon] = dwt_synthesis(A,D,wname)
[~,~,LoR,HiR] = wfilters(wname);
% check a and d are the same size
if length(A) > length(D)
    A = A(1:end-1);   
elseif length(A) < length(D)
    D = D(1:end-1);     
end
% upsampling
A_up = upsample(A,2);
D_up = upsample(D,2);
% periodically extension
A_ext = wextend('1D','per',A_up,length(wname)-1);
D_ext = wextend('1D','per',D_up,length(wname)-1);

lp_recon = conv(A_ext,LoR,'same');
hp_recon = conv(D_ext,HiR,'same');

recon_uncut = lp_recon + hp_recon;
recon = recon_uncut(length(wname):end-length(wname)+1);
end


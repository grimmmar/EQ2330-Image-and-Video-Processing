function [recon,rate] = resbitrate(movblk,orgblk,steplen)
blksize = size(movblk,1);
[height,width] = size(movblk);
residual = orgblk - movblk;
resdct = blkproc(residual,[8 8],@dct2);
resdctq = uniquant(resdct,steplen);
resrecon = blkproc(resdctq,[8 8],@idct2);
recon = resrecon + movblk;
value = reshape(resdctq(:,:),[1,height*width]);
bins = min(value):steplen:max(value);
pr = hist(value(:),bins(:));
prb = pr/sum(pr);
entropy = -sum(prb.*log2(prb+eps)); %eps added for log of 0 vals
rate = entropy*(blksize^2);
end


function [blkrecon,rate] = bitrate(blk,steplen)
[height,width] = size(blk);
blksize = 16;
blkdct = blkproc(blk,[8 8],@dct2);
blkdctq = uniquant(blkdct,steplen);
blkrecon = blkproc(blkdctq,[8 8],@idct2);
value = reshape(blkdctq(:,:),[1,height*width]);
bins = min(value):steplen:max(value);
pr = hist(value(:),bins(:));
prb = pr/sum(pr);
entropy = -sum(prb.*log2(prb+eps)); %eps added for log of 0 vals
rate = entropy*(blksize^2);
end
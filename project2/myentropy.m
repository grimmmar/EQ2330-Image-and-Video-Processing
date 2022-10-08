function [entropy] = myentropy(value,steplen)
bins = min(value):steplen:max(value);
pr = hist(value(:),bins(:));
prb = pr/sum(pr);
entropy = -sum(prb.*log2(prb+eps));
end


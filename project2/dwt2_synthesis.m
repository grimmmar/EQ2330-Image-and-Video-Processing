function [recon] = dwt2_synthesis(cA,cH,cV,cD,wname)
[m,n] = size(cA);
[~, ~, LoR, HiR] = wfilters(wname);
for j = 1:n
    L(:,j) = idwt(cA(:,j),cV(:,j),LoR,HiR,'mode','per');
end
for j = 1:n
    H(:,j) = idwt(cH(:,j),cD(:,j),LoR,HiR,'mode','per');
end
m=2*m;
for i = 1:m
    recon(i,:) = idwt(L(i,:),H(i,:),LoR,HiR,'mode','per');
end
end


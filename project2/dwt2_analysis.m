function [cA,cH,cV,cD] = dwt2_analysis(im,wname)
[m,n] = size(im);
[LoD, HiD, ~, ~] = wfilters(wname);
for i=1:m
    [A,D] = dwt(im(i,:),LoD,HiD,'mode','per');
    im(i,:) = [A,D];
end

for j=1:n
    [A,D] = dwt(im(:,j),LoD,HiD,'mode','per');
    im(:,j) = [A;D];
end

cA=im(1:m/2,1:n/2); % approximation coefficients
cH=im(1:m/2,n/2+1:n); % horizontal detail coefficients
cV=im(m/2+1:m,1:n/2); % vertical detail coefficients
cD=im(m/2+1:m,n/2+1:n); % diagonal detail coefficients

end


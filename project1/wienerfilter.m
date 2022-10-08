function F_hat = wienerfilter(g,h,K)
% Wiener filter
% Input: g(x,y) the blurred image
%        h(x,y) the blur function
%        K noise-to-undegraded-signal ratio

[M,N]=size(g);
[m,n]=size(h);
g1 = padarray(g,[m,n],'replicate','both');

M1 = M + 2*m;
N1 = N + 2*n;

% zero padding
if m<M1||n<N1
    h(M1,N1)=0;
end

H = fft2(h);
G = fft2(g1);

for i = 1:M1
    for j = 1:N1
        F(i,j)=1/H(i,j)*(abs(H(i,j)))^2/((abs(H(i,j)))^2+K)*G(i,j);
    end
end

% cut the padded edge
F_hat = uint8(ifft2(F));
cut1 = (m+1)/2;
cut2 = (n+1)/2;
F_hat =  F_hat(cut1:M+cut1-1,cut2:N+cut2-1);
end


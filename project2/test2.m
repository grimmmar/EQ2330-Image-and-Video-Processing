%main function
clc;
clear;
close all;
img=double(imread('harbour512x512.tif'));
[m n]=size(img);
%compute wavelet coefficients for scale 4
scale = 4;
[LL1,LH1,HL1,HH1]=db4_dwt2D(img);
[LL2,LH2,HL2,HH2]= db4_dwt2D(LL1);
[LL3,LH3,HL3,HH3]= db4_dwt2D(LL2);
[LL4,LH4,HL4,HH4]= db4_dwt2D(LL3);

%quantization for step size 1
LL4q = uniformquant(LL4,1);
LL3q = uniformquant(LL3,1);
LL2q = uniformquant(LL2,1);
LL1q = uniformquant(LL1,1);
LH1q = uniformquant(LH1,1);
LH2q = uniformquant(LH2,1);
LH3q = uniformquant(LH3,1);
LH4q = uniformquant(LH4,1);
HL4q = uniformquant(HL4,1);
HL3q = uniformquant(HL3,1);
HL2q = uniformquant(HL2,1);
HL1q = uniformquant(HL1,1);
HH1q = uniformquant(HH1,1);
HH2q = uniformquant(HH2,1);
HH3q = uniformquant(HH3,1);
HH4q = uniformquant(HH4,1);

%reconstruction
LL31 = db4_idwt2D(LL4q,LH4q,HL4q,HH4q);
LL21 = db4_idwt2D(LL31,LH3q,HL3q,HH3q);
LL11 = db4_idwt2D(LL21,LH2q,HL2q,HH2q);
recon_img = db4_idwt2D(LL11,LH1q,HL1q,HH1q);
error = max(abs(img(:)-recon_img(:)));

%calculate psnr and bitrate
[psnr, bitrates]=bitrate(img);
figure;
plot(bitrates, psnr, '+-', 'linewidth', 1.5);
grid;
% set(gca, ’fontname’, ’Times’);
% set(gca, ’fontsize’, 16);
xlabel('Rate [bits/pixel]');
ylabel('PSNR [dB]');
title('rate-PSNR curve');
%mse for coefficients
mse_ig = mse_img(recon_img,img);
mse_LL1 = mse_img(LL1q,LL1);
mse_LH1 = mse_img(LH1q,LH1);
mse_LH2 = mse_img(LH2q,LH2);
mse_LH3 = mse_img(LH3q,LH3);
mse_LH4 = mse_img(LH4q,LH4);
mse_HL1 = mse_img(HL1q,HL1);
mse_HL2 = mse_img(HL2q,HL2);
mse_HL3 = mse_img(HL3q,HL3);
mse_HL4 = mse_img(HL4q,HL4);
mse_HH1 = mse_img(HH1q,HH1);
mse_HH2 = mse_img(HH2q,HH2);
mse_HH3 = mse_img(HH3q,HH3);
mse_HH4 = mse_img(HH4q,HH4);

function [LL,LH,HL,HH]=db4_dwt2D(img)
% 2 dimentional wavelet transform
[m,n]=size(img);
for i=1:m
[L, H] = db4_dwt(img(i,:));
img(i,:)=[L H];
end
for j=1:n
[L, H] = db4_dwt(img(:,j));
img(:,j)=[L;H];
end
LL=img(1:m/2,1:n/2);
LH=img(1:m/2,n/2+1:n);
HL=img(m/2+1:m,1:n/2);
HH=img(m/2+1:m,n/2+1:n);
end

function [x_quan]=uniformquant(x,step)
%uniform quantization for different step size
x_quan = round(x/step)*step;
end

function [recon]=db4_idwt2D(LL,LH,HL,HH)
% 2-dimentional inverse FWT
[m,n]=size(LL);
for j = 1:n
L(:,j) = db4_idwt(LL(:,j),HL(:,j));
end
for j = 1:n
H(:,j) = db4_idwt(LH(:,j),HH(:,j));
end
m=2*m;
for i = 1:m
recon(i,:) = db4_idwt(L(i,:),H(i,:));
end
end
function [psnr, bitrates]=bitrate(img)
%calculate bitrate and PSNR
[LL1,LH1,HL1,HH1]=db4_dwt2D(img);
[LL2,LH2,HL2,HH2]= db4_dwt2D(LL1);
[LL3,LH3,HL3,HH3]= db4_dwt2D(LL2);
[LL4,LH4,HL4,HH4]= db4_dwt2D(LL3);
steps = [1:10]';
for i = 1:10
steps(i) = 2^(i-1);
LL4q = uniformquant(LL4,i);
LL3q = uniformquant(LL3,i);
LL2q = uniformquant(LL2,i);
LL1q = uniformquant(LL1,i);
LH1q = uniformquant(LH1,i);
LH2q = uniformquant(LH2,i);
LH3q = uniformquant(LH3,i);
LH4q = uniformquant(LH4,i);
HL4q = uniformquant(HL4,i);
HL3q = uniformquant(HL3,i);
HL2q = uniformquant(HL2,i);
HL1q = uniformquant(HL1,i);
HH1q = uniformquant(HH1,i);
HH2q = uniformquant(HH2,i);
HH3q = uniformquant(HH3,i);
HH4q = uniformquant(HH4,i);
LL31 = db4_idwt2D(LL4q,LH4q,HL4q,HH4q);
LL21 = db4_idwt2D(LL31,LH3q,HL3q,HH3q);
LL11 = db4_idwt2D(LL21,LH2q,HL2q,HH2q);
recon_img = db4_idwt2D(LL11,LH1q,HL1q,HH1q);
mse(i)=sum(sum(( recon_img-img).^2))/(512*512);
psnr(i)=10*log10(255^2/mse(i));
H = zeros(1,13); %entropy
H(1)=entro(LL4q,i);
H(2)=entro(LH1q,i);
H(3)=entro(LH2q,i);
H(4)=entro(LH3q,i);
H(5)=entro(LH4q,i);
H(6)=entro(HL1q,i);
H(7)=entro(HL2q,i);
H(8)=entro(HL3q,i);
H(9)=entro(HL4q,i);
H(10)=entro(HH1q,i);
H(11)=entro(HH2q,i);
H(12)=entro(HH3q,i);
H(13)=entro(HH4q,i);
bitrates(i) = mean2(H);
end
end

function [H]=entro(vals,i)
%calculate entopy of the image
p = hist(vals,min(vals):i:max(vals));
p = p/sum(p);
H = -sum(p.*log2(p+eps)); %eps added for log of 0 vals
end

function [mse] = mse_img(img_recon,img)
%calculate MSE
[m,n]=size(img);
mse=sum(sum((img_recon-img).^2))/(m*n);
end

function [recon]=db4_idwt(L,H)
% 1 dimentional inverse dwt
wname = 'db4';
[LoD, HiD, LoR, HiR] = wfilters(wname);
recon = idwt(L,H,LoR, HiR,'mode', 'per');
end

function [L,H]=db4_dwt(img)
% 1 dimentional dwt
wname = 'db4';
[LoD, HiD, LoR, HiR] = wfilters(wname);
[L,H] = dwt(img,LoD,HiD,'mode', 'per');
end
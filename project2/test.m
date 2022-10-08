function recon_img = test()
img=double(imread('harbour512x512.tif'));
%compute wavelet coefficients for scale 4
[LL1,LH1,HL1,HH1]=db4_dwt2D(img);
[LL2,LH2,HL2,HH2]= db4_dwt2D(LL1);
[LL3,LH3,HL3,HH3]= db4_dwt2D(LL2);
[LL4,LH4,HL4,HH4]= db4_dwt2D(LL3);
%plot wavelet coefficients for scale 4
% figure;
% subplot(2,2,1);
% plot_matrix(LL4);
% title('Approximation Coef.');
% subplot(2,2,2)
% plot_matrix(HL4);
% title('Horizontal Detail Coef.');
% subplot(2,2,3)
% plot_matrix(LH4);
% title('Vertical Detail Coef.');
% subplot(2,2,4)
% plot_matrix(HH4);
% title('Diagonal Detail Coef.');
% sgtitle('Wavelet coefficients of scale 4 using dwt()');

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
%plot reconstructed image
% figure;
% plot_matrix(recon_img);
% title('reconstructed image using dwt()');
end

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
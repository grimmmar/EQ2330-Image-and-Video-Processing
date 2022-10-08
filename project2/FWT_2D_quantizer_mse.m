% assignment 3.2&3.3&3.4.1
% 2-D FWT and quantizer
% The average distortion d will be the mean squared error between the original and the
% reconstructed images. Compare d with the mean squared error between the original and
% the quantized wavelet coefficients.
clc;
clear;

load('coeffs.mat');
wname = 'db4';
im = double(imread('harbour512x512.tif'));
[m,n] = size(im);
scale = 4;

[cA1,cH1,cV1,cD1] = dwt2_analysis(im,wname);
[cA2,cH2,cV2,cD2] = dwt2_analysis(cA1,wname);
[cA3,cH3,cV3,cD3] = dwt2_analysis(cA2,wname);
[cA4,cH4,cV4,cD4] = dwt2_analysis(cA3,wname);

%plot wavelet coefficients for scale 4
figure(1);
subplot(1,4,1);
plot_matrix(cA4);
title('Approximation Coef.');
subplot(1,4,2)
plot_matrix(cV4);
title('Horizontal Detail Coef.');
subplot(1,4,3)
plot_matrix(cH4);
title('Vertical Detail Coef.');
subplot(1,4,4)
plot_matrix(cD4);
title('Diagonal Detail Coef.');
sgtitle('Wavelet coefficients of scale 4');

%quantization for step size 1
cA4q = uniquant(cA4,1);
cA3q = uniquant(cA3,1);
cA2q = uniquant(cA2,1);
cA1q = uniquant(cA1,1);

cH4q = uniquant(cH4,1);
cH3q = uniquant(cH3,1);
cH2q = uniquant(cH2,1);
cH1q = uniquant(cH1,1);

cV4q = uniquant(cV4,1);
cV3q = uniquant(cV3,1);
cV2q = uniquant(cV2,1);
cV1q = uniquant(cV1,1);

cD4q = uniquant(cD4,1);
cD3q = uniquant(cD3,1);
cD2q = uniquant(cD2,1);
cD1q = uniquant(cD1,1);

% synthesis
recon3 = dwt2_synthesis(cA4q,cH4q,cV4q,cD4q,wname);
recon2 = dwt2_synthesis(recon3,cH3q,cV3q,cD3q,wname);
recon1 = dwt2_synthesis(recon2,cH2q,cV2q,cD2q,wname);
recon = dwt2_synthesis(recon1,cH1q,cV1q,cD1q,wname);

% plot reconstructed image
figure(2);
subplot(1,2,1);
plot_matrix(im);
title('original image');
subplot(1,2,2);
plot_matrix(recon);
title('reconstructed image');

% compare d with the mean squared error between the original and the quantized wavelet coefficients
[mse,mse_co] = mymse2(im,1,wname);
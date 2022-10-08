% assignment 2.1&2.2
clc;
clear;

im = double(imread('peppers512x512.tif'));
m = 50;
M = 8;

% assignment 2.1
I = im(m+1:m+M,m+1:m+M);
figure(1);
subplot(1,3,1);
plot_matrix(I);
title('Original');

[D,A] = mydct2(I,M); % DCT
subplot(1,3,2);
plot_matrix(D);
title('DCT');

Dinv = A'*D*A; % inverse DCT 
subplot(1,3,3);
plot_matrix(Dinv);
title('IDCT');

% assignment 2.2
x = [-5:0.01:5];
steplen = 1; %step length
quant = uniquant(x,steplen); % uniform quantizer function
figure(2);
plot(x,quant);
title('Quantizer function');
xlabel('Input value');ylabel('Quantized values');


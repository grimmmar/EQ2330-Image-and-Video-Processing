% assignment 3.1
% 1-D FWT analysis and synthesis
clc;
clear;
load('coeffs.mat');
wname = 'db4';
x = rand(1,50);
[LoD, HiD, LoR, HiR] = wfilters(wname);
[cA,cD] = dwt(x,LoD,HiD,'mode','per');
x_r = idwt(cA,cD,LoR,HiR,'mode','per');

subplot(1,2,1);
plot(x);
title('original 1D signal');
subplot(1,2,2);
plot(x_r);
title('reconstructed 1D signal');
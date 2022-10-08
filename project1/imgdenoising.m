% 2.2 Image denoising
clc;
clear all;

% Plot the histogram (with 8 bits resolution) of the input image
L=2^8;% grey level;
f=imread('lena512.bmp');

% Generate and apply noise
gaussian_n = mynoisegen('gaussian', 512, 512, 0, 64);
saltp_n = mynoisegen('saltpepper', 512, 512, 0.05, 0.05);

f_gaussian = double(f) + gaussian_n;
f_saltp = f;
f_saltp(saltp_n==0) = 0;
f_saltp(saltp_n==1) = 255;
f_saltp = uint8(f_saltp);

% Apply mean filter
meanfilter = (1/9)*ones(3,3);
f_gaussian_meanfilt = conv2(double(f_gaussian), double(meanfilter), 'same');
f_saltp_meanfilt = conv2(double(f_saltp), double(meanfilter), 'same');

% Apply median filter
f_gaussian_medfilt = medfilt2(f_gaussian);
f_saltp_medfilt = medfilt2(f_saltp);

% Display histogram
figure(1);
subplot(2,3,1);
histogram(f_gaussian);
xlabel('r');
ylabel('h(r)');
title('gaussian noise image');
axis([0 255 0 inf]);
subplot(2,3,2);
histogram(f_gaussian_meanfilt);
xlabel('r');
ylabel('h(r)');
title('gaussian noise image after mean filter');
axis([0 255 0 inf]);
subplot(2,3,3);
histogram(f_gaussian_medfilt);
xlabel('r');
ylabel('h(r)');
title('gaussian noise image after median filter');
axis([0 255 0 inf]);
subplot(2,3,4);
histogram(f_saltp);
xlabel('r');
ylabel('h(r)');
title('salt&pepper noise image');
axis([0 255 0 inf]);
subplot(2,3,5);
histogram(f_saltp_meanfilt);
xlabel('r');
ylabel('h(r)');
title('salt&pepper noise image after mean filter');
axis([0 255 0 inf]);
subplot(2,3,6);
histogram(f_saltp_medfilt);
xlabel('r');
ylabel('h(r)');
title('salt&pepper noise image after median filter');
axis([0 255 0 inf]);

% Display the 'Lena' image
figure(2);
subplot(2,3,1);
imagesc(f_gaussian,[0 255]);
title('gaussian noise image');
subplot(2,3,2);
imagesc(f_gaussian_meanfilt,[0 255]);
title('gaussian noise image after mean filter');
subplot(2,3,3);
imagesc(f_gaussian_medfilt,[0 255]);
title('gaussian noise image after median filter');
subplot(2,3,4);
imagesc(f_saltp,[0 255]);
title('salt&pepper noise image');
subplot(2,3,5);
imagesc(f_saltp_meanfilt,[0 255]);
title('salt&pepper noise image after mean filter');
subplot(2,3,6);
imagesc(f_saltp_medfilt,[0 255]);
title('salt&pepper noise image after median filter');
colormap gray(256);
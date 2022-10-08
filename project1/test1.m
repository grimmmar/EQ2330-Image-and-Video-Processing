f = imread('images/man512_outoffocus.bmp');
n_var = 0.0833;
h = myblurgen('gaussian',r); % generate h(x,y)
% image deblurring
nsr = n_var./var(double(f(:))); % noise-to-signal ratio
g_deblur = deconvwnr(f,h,nsr); % Wiener filter

% plot the image
figure(2);
subplot(1,2,1);
imagesc(f,[0 255]);
title('blurred image');
subplot(1,2,2);
imagesc(g_deblur,[0 255]);
title('deblurred image');
colormap gray(256);
% 3 Frequency domain filtering
f = imread('lena512.bmp');
r = 8; % radius
[Row,Col] = size(f);
n_mean = 0;
n_var = 0.0833;

% blur the image
h = myblurgen('gaussian',r); % generate h(x,y)
gaussian_n = mynoisegen('gaussian', Row, Col, n_mean, n_var); % generate noise
f_blur = conv2(double(f),h,'same');
g = f_blur + gaussian_n;
for i=1:Row
    for j=1:Col
        if g(i,j)>255
            g(i,j)=255;
        elseif g(i,j)<0
            g(i,j)=0;
        end
    end
end

% Fourier transform
F = fft2(im2double(f));
F = fftshift(F);%  center the spectra
F = real(F);
F_log = log(F+1); % Log transform
G = fft2(im2double(g));
G = fftshift(G);%  center the spectra
G = real(G);
G_log = log(G+1); % Log transform

% plot the Fourier spectra
figure(1);
subplot(1,2,1);
imshow(F_log,[]);
title('original image');
subplot(1,2,2);
imshow(G_log,[]);
title('blurred image');

% image deblurring
g_deblur = wienerfilter(g,h,0.0833);

% plot the image
figure(2);
subplot(1,2,1);
imagesc(g,[0 255]);
title('blurred image');
subplot(1,2,2);
imagesc(g_deblur,[0 255]);
title('deblurred image');
colormap gray(256);
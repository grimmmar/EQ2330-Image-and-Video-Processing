% 2.1 Histogram equalization
clc;
clear all;

% Plot the histogram (with 8 bits resolution) of the input image
L=2^8;% grey level;
f=imread('images/lena512.bmp');
figure(1);
histogram(f);
xlabel('r');
ylabel('h(r)');
title('Histogram of original image');
axis([0 255 0 inf])

% Simulate a low-contrast image by reducing the dynamic range of the image
a=0.2;
b=50;
g=a*f+b;
[Row,Col]=size(g);
for i=1:Row
    for j=1:Col
        if g(i,j)>255
            g(i,j)=255;
        elseif g(i,j)<0
            g(i.j)=0;
        end
    end
end
figure(2);
histogram(g);
xlabel('r');
ylabel('h(r)');
title('Histogram of low-contrast image');
axis([0 255 0 inf]);

% Plot the histogram of the enhanced image.
n_k=imhist(g);
p_r=n_k./(Row*Col);
for i=1:length(p_r)
    sum=cumsum(p_r(1:i));
    s_k(i)=sum(end);
end
s_k=(L-1)*s_k;
for i=1:Row
    for j=1:Col
        g_eq(i,j)=s_k(g(i,j));
    end
end
figure(3);
histogram(g_eq);
xlabel('r');
ylabel('h(r)');
title('Histogram of equalized image');
axis([0 255 0 inf]);

% Display the images
figure(4);
subplot(1,3,1);
imagesc(f,[0 255]);
title('original image');
subplot(1,3,2);
imagesc(g,[0 255]);
title('low-contrast image');
subplot(1,3,3);
imagesc(g_eq,[0 255]);
title('equalized image');
colormap gray(256);
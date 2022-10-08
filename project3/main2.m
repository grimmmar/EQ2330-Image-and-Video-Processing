% assignment 3
clc;
clear;

video_width = 176;
video_height = 144;
numfra = 50;
framerate = 30;
blksize = 16;
rownum = video_height/16;
colnum = video_width/16;
numblk = video_width*video_height/(blksize^2);
V = yuv_import_y('foreman_qcif.yuv',[video_width video_height],numfra);
steplen = [3,4,5,6];

frame = zeros(video_height,video_width,numfra);
for f = 1:numfra
    frame(:,:,f) = V{f,1};
end

recon1 = zeros(video_height,video_width,numfra,length(steplen));
psnr1 = zeros(numfra,length(steplen));
rate1 = zeros(numfra,length(steplen));

recon2 = zeros(video_height,video_width,numfra,length(steplen));
psnr2 = zeros(numfra,length(steplen));
rate2 = zeros(numfra,length(steplen));

num_replblk = zeros(1,numfra,length(steplen));
num_replblk(:,1,:) = 0;

% code the first frame            
for q = 1:length(steplen)
    m = 1:blksize;
    n = 1:blksize;
    step = 2^steplen(q);
    for row = 1:rownum   
        for col = 1:colnum
            [recon2(blksize*(row-1)+m,blksize*(col-1)+n,1,q),rate] = ...
                bitrate(frame(blksize*(row-1)+m,blksize*(col-1)+n,1),step);
            rate2(1,q) = rate2(1,q) + rate;
        end
    end 
    recon1(1,q) = recon2(1,q);
    rate1(1,q) = rate2(1,q);
    psnr2(1,q) = PSNR(mse(frame(:,:,1),recon2(:,:,1,q))); 
    psnr1(1,q) = psnr2(1,q);
end

for f = 2:numfra
    for q = 1:length(steplen)
        m = 1:blksize;
        n = 1:blksize;
        step = 2^steplen(q);
        for row = 1:rownum
            for col = 1:colnum           
                [blkrecon,R1] = bitrate(frame(blksize*(row-1)+m,blksize*(col-1)+n,f),step);
                distortion1 = mse(frame(blksize*(row-1)+m,blksize*(col-1)+n,f),blkrecon);
                distortion2 = mse(frame(blksize*(row-1)+m,blksize*(col-1)+n,f),...
                    recon2(blksize*(row-1)+m,blksize*(col-1)+n,f-1,q));
                
                R1 = R1 + 1; % one additional bit for mode selection
                R2 = 1;
                
                J1 = Lagrangian(distortion1,step,R1);
                J2 = Lagrangian(distortion2,step,R2);
                J = [J1,J2];
                [minJ,choosemode] = min(J);
                        
                if choosemode == 1 % intra mode
                    recon2(blksize*(row-1)+m,blksize*(col-1)+n,f,q) = blkrecon;
                    rate2(f,q) = rate2(f,q) + R1;
                elseif choosemode == 2 % copy mode
                    recon2(blksize*(row-1)+m,blksize*(col-1)+n,f,q) = ...
                        recon2(blksize*(row-1)+m,blksize*(col-1)+n,f-1,q);
                    num_replblk(1,f,q) = num_replblk(1,f,q)+1;
                    rate2(f,q) = rate2(f,q) + R2;
                end
                recon1(blksize*(row-1)+m,blksize*(col-1)+n,f,q) = blkrecon;
                rate1(f,q) = rate1(f,q) + R1 - 1;
            end
        end
        psnr1(f,q) = PSNR(mse(recon1(:,:,f,q),frame(:,:,f)));
        psnr2(f,q) = PSNR(mse(recon2(:,:,f,q),frame(:,:,f)));
    end
end

rate1 = mean(rate1,1)* framerate/1000;
rate2 = mean(rate2,1)* framerate/1000;
psnr1m = mean(psnr1,1);
psnr2m = mean(psnr2,1);
plot(rate1,psnr1m,'o-');
hold on;
plot(rate2,psnr2m,'o-');
grid on;
title('rate-PSNR curve for conditional replenishment video coder');
legend('only intra mode','conditional replenishment');
xlabel('rate [Kbps]');ylabel('PSNR[dB]');

% calculate the number of each mode
num_copymode = zeros(1,length(steplen));
num_total = zeros(1,length(steplen));
num_intramode = zeros(1,length(steplen));
for q = 1:length(steplen)
    for f = 1:numfra
        num_copymode(q) = num_copymode(q) + num_replblk(1,f,q);
    end
    num_total(q) = numblk*numfra;
    num_intramode(q) = num_total(q) - num_copymode(q);
end

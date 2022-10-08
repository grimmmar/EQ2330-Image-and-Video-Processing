% assignment 4
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
V = yuv_import_y('mother-daughter_qcif.yuv',[video_width video_height],numfra);
steplen = [3,4,5,6];

frame = zeros(video_height,video_width,numfra);
for f = 1:numfra
    frame(:,:,f) = V{f,1};
end

% initialize
recon1 = zeros(video_height,video_width,numfra,length(steplen));
psnr1 = zeros(numfra,length(steplen));
rate1 = zeros(numfra,length(steplen));

recon2 = zeros(video_height,video_width,numfra,length(steplen));
psnr2 = zeros(numfra,length(steplen));
rate2 = zeros(numfra,length(steplen));

recon3 = zeros(video_height,video_width,numfra,length(steplen));
psnr3 = zeros(numfra,length(steplen));
rate3 = zeros(numfra,length(steplen));

% intra, copy and motion compensation
num_interblk = zeros(length(steplen),3);

% motion compensation mode
maxshift = 10;
numshift = (2*maxshift + 1)^2;
shiftvector = zeros(2,numshift);
index = 1;
for dx = -maxshift:1:maxshift
    for dy = -maxshift:1:maxshift
        shiftvector(1,index) = dx;
        shiftvector(2,index) = dy;
        index = index + 1;
    end
end

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
    recon1(:,:,1,q) = recon2(:,:,1,q);
    recon3(:,:,1,q) = recon2(:,:,1,q);
    rate1(1,q) = rate2(1,q);
    rate3(1,q) = rate2(1,q);
    psnr2(1,q) = PSNR(mse(frame(:,:,1),recon2(:,:,1,q))); 
    psnr1(1,q) = psnr2(1,q);
    psnr3(1,q) = psnr2(1,q);
end

for f = 2:numfra
    for q = 1:length(steplen)
        m = 1:blksize;
        n = 1:blksize;
        step = 2^steplen(q);
        blknum = 1;
        shiftdirection = shift(recon3(:,:,f-1,q),frame(:,:,f),shiftvector);
        
        for row = 1:rownum
            for col = 1:colnum           
                
                % intra mode and copy mode
                [blkrecon,R1] = bitrate(frame(blksize*(row-1)+m,blksize*(col-1)+n,f),step);
                distortion1 = mse(frame(blksize*(row-1)+m,blksize*(col-1)+n,f),blkrecon);
                distortion2 = mse(frame(blksize*(row-1)+m,blksize*(col-1)+n,f),...
                    recon2(blksize*(row-1)+m,blksize*(col-1)+n,f-1,q));
                R1 = R1 + 1;% one additional bit for mode selection
                R2 = 1;
                J1 = Lagrangian(distortion1,step,R1);
                J2 = Lagrangian(distortion2,step,R2);
                J = [J1,J2];
                [~,choosemode] = min(J);
                
                if choosemode == 1 % intra mode
                    recon2(blksize*(row-1)+m,blksize*(col-1)+n,f,q) = blkrecon;
                    rate2(f,q) = rate2(f,q) + R1;
                elseif choosemode == 2 % copy mode
                    recon2(blksize*(row-1)+m,blksize*(col-1)+n,f,q) = ...
                        recon2(blksize*(row-1)+m,blksize*(col-1)+n,f-1,q);
                    rate2(f,q) = rate2(f,q) + R2;
                end
                
                recon1(blksize*(row-1)+m,blksize*(col-1)+n,f,q) = blkrecon;
                rate1(f,q) = rate1(f,q) + R1 - 1;
                
                % intra mode, copy mode and motion compensation mode
                dy = shiftvector(1,shiftdirection(blknum));
                dx = shiftvector(2,shiftdirection(blknum));
                ymov = blksize*(row-1) + dy + m;
                xmov = blksize*(col-1) + dx + n;
                movedBlk = recon3(ymov,xmov,f-1,q);
                [blkrecon_res, R3] = resbitrate(movedBlk,frame(ymov,xmov,f),step);
                
                distortion3 = mse(frame(blksize*(row-1)+m,blksize*(col-1)+n,f),blkrecon_res);
                
                R1 = 2 + R1; % two additional bit for mode selection
                R2 = 2;
                R3 = 2 + 10 + R3;
                J1 = Lagrangian(distortion1,step,R1);
                J2 = Lagrangian(distortion2,step,R2);
                J3 = Lagrangian(distortion3,step,R3);
                J = [J1,J2,J3];
                [minJ,choosemode] = min(J);
                        
                if choosemode == 1 % intra mode
                    recon3(blksize*(row-1)+m,blksize*(col-1)+n,f,q) = blkrecon;
                    rate3(f,q) = rate3(f,q) + R1;
                elseif choosemode == 2 % copy mode
                    recon3(blksize*(row-1)+m,blksize*(col-1)+n,f,q) = ...
                        recon3(blksize*(row-1)+m,blksize*(col-1)+n,f-1,q);
                    num_interblk(q,2) = num_interblk(q,2) + 1;
                    rate3(f,q) = rate3(f,q) + R2;
                elseif choosemode == 3 % motion compensation mode
                    recon3(blksize*(row-1)+m,blksize*(col-1)+n,f,q) = blkrecon_res;
                    num_interblk(q,3) = num_interblk(q,3) + 1;
                    rate3(f,q) = rate3(f,q) + R3;
                end
                blknum = blknum + 1;
            end
        end
        psnr1(f,q) = PSNR(mse(recon1(:,:,f,q),frame(:,:,f)));
        psnr2(f,q) = PSNR(mse(recon2(:,:,f,q),frame(:,:,f)));
        psnr3(f,q) = PSNR(mse(recon3(:,:,f,q),frame(:,:,f)));
    end
end

rate1 = mean(rate1,1)* framerate/1000;
rate2 = mean(rate2,1)* framerate/1000;
rate3 = mean(rate3,1)* framerate/1000;
psnr1m = mean(psnr1,1);
psnr2m = mean(psnr2,1);
psnr3m = mean(psnr3,1);
plot(rate1,psnr1m,'o-');
hold on;
plot(rate2,psnr2m,'o-');
hold on;
plot(rate3,psnr3m,'o-');
grid on;
title('rate-PSNR curve for "mode 1","mode 1&2","mode 1&2&3"');
legend('intra mode','conditional replishment mode','motion compensation mode');
xlabel('rate [Kbps]');ylabel('PSNR[dB]');

num_total = zeros(1,length(steplen));
for q = 1:length(steplen)
    num_total(q) = numblk*numfra;
    num_interblk(q,1) = num_total(q) - num_interblk(q,2) - num_interblk(q,3);
end
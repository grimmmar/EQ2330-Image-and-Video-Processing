% assignment 2
clc;
clear;

video_width = 176;
video_height = 144;
numfra = 50;
framerate = 30;
steplen = [3,4,5,6];
V1 = yuv_import_y('foreman_qcif.yuv',[video_width video_height],numfra);
V2 = yuv_import_y('mother-daughter_qcif.yuv',[video_width video_height],numfra);

% foreman
% DCT
for i = 1:length(V1)
    Vdct1{i,1} = blkproc(V1{i,1},[16 16],@dct16x16);
end

% Quantization

for i = 1:length(steplen)
    s = steplen(i);
    step = 2^s;
    for j = 1:numfra
        Vdctq1{j,i} = uniquant(Vdct1{j,1},step);
    end
end

% MSE
for i = 1:length(steplen)
    for j = 1:numfra
        error1(j,i) = mse(Vdct1{j,1},Vdctq1{j,i});
    end
end

% inverse DCT
for i = 1:length(steplen)
    for j = 1:numfra
        recon1{j,i} = blkproc(Vdctq1{j,i},[16 16],@idct16x16);
    end
end

for j=1:length(steplen)
    for i=1:numfra
        Video1(:,:,i,j) = recon1{i,j};
    end
end

Vpsnr1 = mean(PSNR(error1));

bitrates1 = zeros(size(steplen)); 
rownum = video_width/16;
colnum = video_height/16;
%calculate bitrates/s per each qunatizer step
for j=1:length(steplen) %for each quantizer step
    s = steplen(j);
    step = 2^s;
    K = zeros(16,16,rownum*colnum*length(Vdctq1));
    
    for i=1:length(Vdctq1) %for each frame
        index = 1;
        for row=1:rownum
            for col=1:colnum
                for m=1:16
                    for n=1:16
                        K(m,n,(i-1)*rownum*colnum+index) = Vdctq1{i,j}(16*(col-1)+n,16*(row-1)+m);
                    end
                end
                index = index + 1;
            end
        end
    end
    
    % calculate R
    entropy=zeros(16,16);
    for m=1:16
        for n=1:16
            value = K(m,n,:);
            bins = min(value):step:max(value);
            pr = hist(value(:),bins(:));
            prb = pr/sum(pr);
            entropy(m,n) = -sum(prb.*log2(prb+eps)); %eps added for log of 0 vals
        end
    end
    bitrates1(j) = mean2(entropy);
end
%covert to kbit/s
ratesKBPS1 = bitrates1 .* ((video_height*video_width*framerate)/1000);

% mother-daughter
% DCT
for i = 1:length(V1)
    Vdct2{i,1} = blkproc(V2{i,1},[16 16],@dct16x16);
end

% Quantization

for i = 1:length(steplen)
    s = steplen(i);
    step = 2^s;
    for j = 1:numfra
        Vdctq2{j,i} = uniquant(Vdct2{j,1},step);
    end
end

% MSE
for i = 1:length(steplen)
    for j = 1:numfra
        error2(j,i) = mse(Vdct2{j,1},Vdctq2{j,i});
    end
end

% inverse DCT
for i = 1:length(steplen)
    for j = 1:numfra
        recon2{j,i} = blkproc(Vdctq2{j,i},[16 16],@idct16x16);
    end
end

for j=1:length(steplen)
    for i=1:numfra
        Video2(:,:,i,j) = recon2{i,j};
    end
end

Vpsnr2 = mean(PSNR(error2));

bitrates2 = zeros(size(steplen)); 
rownum = video_width/16;
colnum = video_height/16;
%calculate bitrates/s per each qunatizer step
for j=1:length(steplen) %for each quantizer step
    s = steplen(j);
    step = 2^s;
    K = zeros(16,16,rownum*colnum*length(Vdctq2));
    
    for i=1:length(Vdctq2) %for each frame
        index = 1;
        for row=1:rownum
            for col=1:colnum
                for m=1:16
                    for n=1:16
                        K(m,n,(i-1)*rownum*colnum+index) = Vdctq2{i,j}(16*(col-1)+n,16*(row-1)+m);
                    end
                end
                index = index + 1;
            end
        end
    end
    
    % calculate R
    entropy=zeros(16,16);
    for m=1:16
        for n=1:16
            value = K(m,n,:);
            bins = min(value):step:max(value);
            pr = hist(value(:),bins(:));
            prb = pr/sum(pr);
            entropy(m,n) = -sum(prb.*log2(prb+eps)); %eps added for log of 0 vals
        end
    end
    bitrates2(j) = mean2(entropy);
end
%covert to kbit/s
ratesKBPS2 = bitrates2 .* ((video_height*video_width*framerate)/1000);

figure;
plot(ratesKBPS1, Vpsnr1, 'b-o');
hold on;
plot(ratesKBPS2, Vpsnr2, 'r-o');
title('rate-PSNR curve');
grid on;
legend('foreman','mother-daughter');
xlabel('rate[Kbps] ');
ylabel('PSNR[dB] ');

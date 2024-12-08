clc;
close all;
clear all;
n=[0:255];
N=256;
sig=round(sin(2*pi*n/N)*127);
fprintf('%5u ', sig);
%sig=round(sin(2*pi*n/N)*32767);

% 计算 FFT
sig_freq_re = real(fft(sin(2*pi*n/N)*127,256));
sig_freq_im = imag(fft(sin(2*pi*n/N)*127,256));

% 将 sig_freq_re 保存到 re.log 文件
fid_re = fopen('re.log', 'w+');
fprintf(fid_re, '%10f \n', sig_freq_re); % 以浮点格式保存
fclose(fid_re);

% 将 sig_freq_im 保存到 im.log 文件
fid_im = fopen('im.log', 'w+');
fprintf(fid_im, '%10f \n', sig_freq_im); % 以浮点格式保存
fclose(fid_im);

% 转换为补码形式
for i=1:256
    if(sig(i)<0)
        sig(i) = 256 + sig(i); % 对于负数转换为补码形式
        %sig(i) = 65536 + sig(i); % 16位补码形式
    else
        sig(i) = sig(i);
    end
end

% 生成 COE 文件
fid = fopen('ram_init_data.coe', 'w+');
fprintf(fid, 'memory_initialization_radix = 10; \n');
fprintf(fid, 'memory_initialization_vector = \n');
for i=1:255
    fprintf(fid, '%d,', sig(i));
end
fprintf(fid, '%d;', sig(256));
fclose(fid);

%https://blog.csdn.net/weixin_39789553/article/details/122470300
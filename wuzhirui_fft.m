clc;
close all;
clear all;
n=[0:255];
N=256;
sig=round(sin(2*pi*n/N)*127);
%sig=round(sin(2*pi*n/N)*32767);
sig_freq_re=real(fft(sin(2*pi*n/N),256));
sig_freq_im=imag(fft(sin(2*pi*n/N),256));
%figure(1),plot(abs(sig_freq));

for i=1:256
    if(sig(i)<0)
        sig(i)=256+sig(i);%对于负数要转换为补码形式
        %sig(i)=65536+sig(i);%对于负数要转换为补码形式
    else
        sig(i)=sig(i);
    end
end
fid=fopen('ram_init_data.coe','w+')
fprintf(fid,'memory_initialization_radix = 10; \n')
fprintf(fid,'memory_initialization_vector = \n')
for i=1:255
    fprintf(fid,'%d,',sig(i));
end
fprintf(fid,'%d;',sig(256));
fclose(fid);
%https://blog.csdn.net/weixin_39789553/article/details/122470300
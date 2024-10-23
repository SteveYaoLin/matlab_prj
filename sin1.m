% 参数定义
N = 16384;             % 采样点数
f3 = 13.56e6;          % s3 波形的频率为 13.56 MHz
fs = 65e6;             % 采样频率为 65 MHz
A3 = 127.5;            % s3 振幅的一半
DC3 = 127.5;           % s3 的直流偏移，使其在 0 到 255 之间
p3 = 0;                % s3 的初始相位为 0

% 时间序列
t = (0:N-1)/fs;        % 采样时间序列

% 生成 s3 正弦波
s3 = A3 * sin(2 * pi * f3 * t + p3) + DC3;
s3 = round(s3);        % 将信号四舍五入到整数范围

% 绘制 s3 波形
figure;
plot(t*1e6, s3, '-o');  % t*1e6 转换为微秒显示
xlabel('时间 (\mus)');
ylabel('幅度');
title('s3 波形 (13.56 MHz)');
legend('s3');

% 对 s3 进行 FFT 计算
S3 = fft(s3);
S3_mag = abs(S3/N);           % 计算 FFT 幅度，并归一化
S3_mag = S3_mag(1:N/2+1);     % 只取前 N/2+1 个点（实部）
S3_mag(2:end-1) = 2*S3_mag(2:end-1); % 单边频谱加倍

% 频率轴
f_axis = (0:N/2)*(fs/N);      % 频率轴

% 绘制频谱图
figure;
stem(f_axis/1e6, S3_mag, 'filled');  % 转换为 MHz 显示
xlabel('频率 (MHz)');
ylabel('幅度');
title('s3 波形的频谱图 (FFT)');

% 计算并显示频率分辨率
frequency_resolution = fs / N;
disp(['FFT 频率分辨率: ', num2str(frequency_resolution), ' Hz']);

% 参数定义
N = 16384;             % 采样点数
f3 = 13.56e6;          % s3 和 s4 波形的频率为 13.56 MHz
fs = 65e6;             % 采样频率为 65 MHz
A3 = 8191;             % s3 振幅的一半 (14-bit 最大值)
DC3 = 8191;            % s3 的直流偏移，使其在 0 到 16383 之间
p3 = pi/2;             % s3 的初始相位
A4 = 819;              % s4 振幅的一半 (较小幅度)
p4 = pi/4;             % s4 的初始相位

% 时间序列
t = (0:N-1)/fs;        % 采样时间序列

% 生成 s3 和 s4 正弦波
s3 = A3 * sin(2 * pi * f3 * t + p3) + DC3;
s4 = A4 * sin(2 * pi * f3 * t + p4) + DC3;
s3 = round(s3);        % 四舍五入到整数范围
s4 = round(s4);

% 绘制时域波形，只显示前 128 个点
figure;
plot(t(1:128)*1e6, s3(1:128), '-o', 'DisplayName', 's3 波形'); hold on;
plot(t(1:128)*1e6, s4(1:128), '-x', 'DisplayName', 's4 波形');
xlabel('时间 (\mus)');
ylabel('幅度');
title('s3 和 s4 波形 (13.56 MHz) - 前 128 个采样点');
legend show;

% 对 s3 和 s4 进行 FFT 计算
S3 = fft(s3);
S4 = fft(s4);

% 提取实部、虚部、幅度和相位
S3_real = real(S3);
S3_imag = imag(S3);
S3_mag = abs(S3/N);                     % 幅度归一化
S3_mag = S3_mag(1:N/2+1);               % 只取前 N/2+1 个点
S3_mag(2:end-1) = 2 * S3_mag(2:end-1);  % 单边频谱加倍
S3_phase = angle(S3);                   % 计算相位
S3_phase = S3_phase(1:N/2+1);

S4_real = real(S4);
S4_imag = imag(S4);
S4_mag = abs(S4/N);                     % 幅度归一化
S4_mag = S4_mag(1:N/2+1);
S4_mag(2:end-1) = 2 * S4_mag(2:end-1);
S4_phase = angle(S4);                   % 计算相位
S4_phase = S4_phase(1:N/2+1);

% 计算相位差
phase_diff = S3_phase - S4_phase;

% 频率分辨率
frequency_resolution = fs / N;          % 计算频率分辨率
f_axis = (0:N/2);                       % 使用索引作为横轴

% 创建并打开日志文件
log_file = fopen('fft_log.txt', 'w');

% 写入前 128 个点的 FFT 实部、虚部、取模和相位
fprintf(log_file, '前 128 个点的 FFT 结果:\n');
for i = 0:127
    fprintf(log_file, '第 %d 个点: %d, s3 实部: %f, s3 虚部: %f, s3 取模: %f, s3 相位: %f, ', ...
            i, i, S3_real(i+1), S3_imag(i+1), S3_mag(i+1), S3_phase(i+1));
    fprintf(log_file, 's4 实部: %f, s4 虚部: %f, s4 取模: %f, s4 相位: %f, 相位差: %f\n', ...
            S4_real(i+1), S4_imag(i+1), S4_mag(i+1), S4_phase(i+1), phase_diff(i+1));
end

% 写入 3000 到 3500 点范围的 FFT 实部、虚部、取模和相位
fprintf(log_file, '\n3000 到 3500 个点的 FFT 结果:\n');
for i = 3000:3500
    fprintf(log_file, '第 %d 个点: %d, s3 实部: %f, s3 虚部: %f, s3 取模: %f, s3 相位: %f, ', ...
            i, i, S3_real(i+1), S3_imag(i+1), S3_mag(i+1), S3_phase(i+1));
    fprintf(log_file, 's4 实部: %f, s4 虚部: %f, s4 取模: %f, s4 相位: %f, 相位差: %f\n', ...
            S4_real(i+1), S4_imag(i+1), S4_mag(i+1), S4_phase(i+1), phase_diff(i+1));
end

% 将频率分辨率写入日志文件
fprintf(log_file, '\nFFT 频率分辨率: %f Hz\n', frequency_resolution);

% 关闭日志文件
fclose(log_file);

% 绘制幅度谱图
figure;
subplot(2, 1, 1);
stem(f_axis, S3_mag, 'filled', 'DisplayName', 's3 幅度'); hold on;
xlabel(['频率索引, 每点分辨率 = ', num2str(frequency_resolution), ' Hz']);
ylabel('幅度');
title('s3 波形的幅度谱图 (FFT)');
legend show;

subplot(2, 1, 2);
stem(f_axis, S4_mag, 'filled', 'DisplayName', 's4 幅度');
xlabel(['频率索引, 每点分辨率 = ', num2str(frequency_resolution), ' Hz']);
ylabel('幅度');
title('s4 波形的幅度谱图 (FFT)');
legend show;

% 绘制相位谱图
figure;
subplot(2, 1, 1);
plot(f_axis, S3_phase, '-o', 'DisplayName', 's3 相位');
xlabel(['频率索引, 每点分辨率 = ', num2str(frequency_resolution), ' Hz']);
ylabel('相位 (弧度)');
title('s3 波形的相位图 (FFT)');
legend show;

subplot(2, 1, 2);
plot(f_axis, S4_phase, '-x', 'DisplayName', 's4 相位');
xlabel(['频率索引, 每点分辨率 = ', num2str(frequency_resolution), ' Hz']);
ylabel('相位 (弧度)');
title('s4 波形的相位图 (FFT)');
legend show;

% 绘制相位差图
figure;
plot(f_axis, phase_diff, '-o', 'DisplayName', '相位差 (s3 - s4)');
xlabel(['频率索引, 每点分辨率 = ', num2str(frequency_resolution), ' Hz']);
ylabel('相位差 (弧度)');
title('s3 和 s4 的相位差图');
legend show;

% 日志文件已生成并保存在当前目录下
disp('FFT 计算的日志信息已保存到文件 fft_log.txt');

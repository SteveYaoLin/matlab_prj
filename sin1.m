% 参数定义
N = 16384;             % 采样点数
f3 = 13.56e6;          % s3 波形的频率为 13.56 MHz
fs = 65e6;             % 采样频率为 65 MHz
A3 = 127.5;            % s3 振幅的一半
DC3 = 127.5;           % s3 的直流偏移，使其在 0 到 255 之间
p3 = pi/2;                % s3 的初始相位为 0

% 时间序列
t = (0:N-1)/fs;        % 采样时间序列

% 生成 s3 正弦波
s3 = A3 * sin(2 * pi * f3 * t + p3) + DC3;
s3 = round(s3);        % 将信号四舍五入到整数范围

% 绘制 s3 波形，只显示前 128 个点
figure;
plot(t(1:128)*1e6, s3(1:128), '-o');  % t*1e6 转换为微秒显示
xlabel('时间 (\mus)');
ylabel('幅度');
title('s3 波形 (13.56 MHz) - 前 128 个采样点');
legend('s3');

% 对 s3 进行 FFT 计算
S3 = fft(s3);

% 提取实部、虚部、幅度和相位
S3_real = real(S3);
S3_imag = imag(S3);
S3_mag = abs(S3/N);                     % 计算 FFT 幅度，并归一化
S3_mag = S3_mag(1:N/2+1);               % 只取前 N/2+1 个点（实部）
S3_mag(2:end-1) = 2 * S3_mag(2:end-1);  % 单边频谱加倍
S3_phase = angle(S3);                   % 计算相位
S3_phase = S3_phase(1:N/2+1);           % 只取前 N/2+1 个点的相位

% 频率分辨率
frequency_resolution = fs / N;          % 计算频率分辨率
f_axis = (0:N/2);                       % 使用索引作为横轴

% 计算目标频率在 FFT 中的索引
s3_index = f3 / frequency_resolution;

% 创建并打开日志文件
log_file = fopen('fft_log.txt', 'w');

% 写入前 128 个点的 FFT 实部、虚部、取模和相位
fprintf(log_file, '前 128 个点的 FFT 结果:\n');
for i = 0:127
    fprintf(log_file, '第 %d 个点: %d, 实部: %f, 虚部: %f, 取模: %f, 相位: %f\n', i, i, S3_real(i+1), S3_imag(i+1), S3_mag(i+1), S3_phase(i+1));
end

% 写入 s3 附近 3400 到 3500 点范围的 FFT 实部、虚部、取模和相位
fprintf(log_file, '\n3400 到 3500 个点的 FFT 结果:\n');
for i = 3400:3500
    fprintf(log_file, '第 %d 个点: %d, 实部: %f, 虚部: %f, 取模: %f, 相位: %f\n', i, i, S3_real(i+1), S3_imag(i+1), S3_mag(i+1), S3_phase(i+1));
end

% 将频率分辨率和目标频率对应的索引写入日志文件
fprintf(log_file, '\nFFT 频率分辨率: %f Hz\n', frequency_resolution);
fprintf(log_file, 's3 的频率应在大约 %.2f 点位置\n', s3_index);

% 关闭日志文件
fclose(log_file);

% 绘制幅度谱图
figure;
stem(f_axis, S3_mag, 'filled');  % 横坐标显示为索引
xlabel(['频率索引, 每点对应的频率分辨率 = ', num2str(frequency_resolution), ' Hz']);
ylabel('幅度');
title('s3 波形的频谱图 (FFT)');

% 绘制相位谱图
figure;
plot(f_axis, S3_phase, '-o');  % 相位图
xlabel(['频率索引, 每点对应的频率分辨率 = ', num2str(frequency_resolution), ' Hz']);
ylabel('相位 (弧度)');
title('s3 波形的相位图 (FFT)');

% 日志文件已生成并保存在当前目录下
disp('FFT 计算的日志信息已保存到文件 fft_log.txt');

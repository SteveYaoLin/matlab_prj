% 参数定义
N = 256;                 % 采样点数
A1 = 127.5;              % 第一个波形的振幅的一半 (峰值与谷值的差的一半)
DC1 = 127.5;             % 第一个波形的偏移量 (将正弦波的范围平移到0到255之间)
f1 = 1;                  % 第一个波形的信号频率，单周期内的频率为1
w1 = 2*pi*f1;            % 第一个波形的角频率
p1 = 0;                  % 第一个波形的初始相位为0

A2 = hex2dec('3f');      % 第二个波形的振幅为3f (63)
DC2 = hex2dec('7f');     % 第二个波形的偏移量为7f (127)
f2 = 2;                  % 第二个波形的信号频率，即两个周期
w2 = 2*pi*f2;            % 第二个波形的角频率
p2 = 0;                  % 第二个波形的初始相位为0

fs = 256e3;              % 采样频率为256kHz
t = (0:N-1)/fs;          % 时间序列，间隔为 1/fs

% 生成第一个正弦信号
s1 = A1*sin(w1*t*fs/N + p1) + DC1;   % 生成第一个信号
s1 = round(s1);                      % 将信号四舍五入到整数范围

% 生成第二个正弦信号
s2 = A2*sin(w2*t*fs/N + p2) + DC2;   % 生成第二个信号
s2 = round(s2);                      % 将信号四舍五入到整数范围

% 将两个波形叠加
s = s1 + s2;

% 绘制叠加后的波形
figure;
hold on;
plot(t*1e3, s1, '-o', 'DisplayName', '第一个波形'); % t*1e3 转换为毫秒显示
plot(t*1e3, s2, '-x', 'DisplayName', '第二个波形');
plot(t*1e3, s, '-s', 'DisplayName', '叠加后的波形');
xlabel('时间 (ms)');
ylabel('幅度');
title('叠加波形');
legend;
hold off;

% FFT计算
S = fft(s);                   % 对叠加后的波形进行FFT
S_mag = abs(S/N);             % 计算FFT结果的幅度，并归一化
S_mag = S_mag(1:N/2+1);       % 只取前N/2+1个点（实部）
S_mag(2:end-1) = 2*S_mag(2:end-1); % 因为使用了单边频谱，需要将幅度加倍

% 频率轴
f_axis = (0:N/2)*(fs/N);      % 真实频率轴，单位为Hz

% 绘制频谱图
figure;
stem(f_axis/1e3, S_mag, 'filled');  % f_axis/1e3 转换为kHz
xlabel('频率 (kHz)');
ylabel('幅度');
title('叠加波形的频谱图 (FFT)');

% 显示信号的第一个点（用于验证）
disp(['第一个采样点的值: ', num2str(s(1))]);

% 如果需要将结果显示为16进制
hex_values = dec2hex(s);
disp('叠加后采样点对应的16进制值:');
disp(hex_values);

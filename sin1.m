% ��������
N = 16384;             % ��������
f3 = 13.56e6;          % s3 ���ε�Ƶ��Ϊ 13.56 MHz
fs = 65e6;             % ����Ƶ��Ϊ 65 MHz
A3 = 127.5;            % s3 �����һ��
DC3 = 127.5;           % s3 ��ֱ��ƫ�ƣ�ʹ���� 0 �� 255 ֮��
p3 = 0;                % s3 �ĳ�ʼ��λΪ 0

% ʱ������
t = (0:N-1)/fs;        % ����ʱ������

% ���� s3 ���Ҳ�
s3 = A3 * sin(2 * pi * f3 * t + p3) + DC3;
s3 = round(s3);        % ���ź��������뵽������Χ

% ���� s3 ���Σ�ֻ��ʾǰ 128 ����
figure;
plot(t(1:128)*1e6, s3(1:128), '-o');  % t*1e6 ת��Ϊ΢����ʾ
xlabel('ʱ�� (\mus)');
ylabel('����');
title('s3 ���� (13.56 MHz) - ǰ 128 ��������');
legend('s3');

% �� s3 ���� FFT ����
S3 = fft(s3);

% ��ȡʵ�����鲿
S3_real = real(S3);
S3_imag = imag(S3);

% ���� FFT ����
S3_mag = abs(S3/N);           % ���� FFT ���ȣ�����һ��
S3_mag = S3_mag(1:N/2+1);     % ֻȡǰ N/2+1 ���㣨ʵ����
S3_mag(2:end-1) = 2*S3_mag(2:end-1); % ����Ƶ�׼ӱ�

% Ƶ�ʷֱ���
frequency_resolution = fs / N;    % ����Ƶ�ʷֱ���
f_axis = (0:N/2);                 % ʹ��������Ϊ����

% ����Ŀ��Ƶ���� FFT �е�����
s3_index = f3 / frequency_resolution;

% ����������־�ļ�
log_file = fopen('fft_log.txt', 'w');

% д��ǰ 128 ����� FFT ʵ�����鲿
fprintf(log_file, 'ǰ 128 ����� FFT ���:\n');
for i = 0:127
    fprintf(log_file, '�� %d ����: %d, ʵ��: %f, �鲿: %f\n', i, i, S3_real(i+1), S3_imag(i+1));
end

% д�� s3 ���� 3400 �� 3500 �㷶Χ�� FFT ʵ�����鲿
fprintf(log_file, '\n3400 �� 3500 ����� FFT ���:\n');
for i = 3400:3500
    fprintf(log_file, '�� %d ����: %d, ʵ��: %f, �鲿: %f\n', i, i, S3_real(i+1), S3_imag(i+1));
end

% ��Ƶ�ʷֱ��ʺ�Ŀ��Ƶ�ʶ�Ӧ������д����־�ļ�
fprintf(log_file, '\nFFT Ƶ�ʷֱ���: %f Hz\n', frequency_resolution);
fprintf(log_file, 's3 ��Ƶ��Ӧ�ڴ�Լ %.2f ��λ��\n', s3_index);

% �ر���־�ļ�
fclose(log_file);

% ����Ƶ��ͼ
figure;
stem(f_axis, S3_mag, 'filled');  % ��������ʾΪ����
xlabel(['Ƶ������, ÿ���Ӧ��Ƶ�ʷֱ��� = ', num2str(frequency_resolution), ' Hz']);
ylabel('����');
title('s3 ���ε�Ƶ��ͼ (FFT)');

% ��־�ļ������ɲ������ڵ�ǰĿ¼��
disp('FFT �������־��Ϣ�ѱ��浽�ļ� fft_log.txt');

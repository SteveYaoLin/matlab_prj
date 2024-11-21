% ��������
N = 16384;             % ��������
f3 = 13.56e6;          % s3 �� s4 ���ε�Ƶ��Ϊ 13.56 MHz
fs = 65e6;             % ����Ƶ��Ϊ 65 MHz
A3 = 8191;             % s3 �����һ�� (14-bit ���ֵ)
DC3 = 8191;            % s3 ��ֱ��ƫ�ƣ�ʹ���� 0 �� 16383 ֮��
p3 = pi/2;             % s3 �ĳ�ʼ��λ
A4 = 819;              % s4 �����һ�� (��С����)
p4 = pi/4;             % s4 �ĳ�ʼ��λ

% ʱ������
t = (0:N-1)/fs;        % ����ʱ������

% ���� s3 �� s4 ���Ҳ�
s3 = A3 * sin(2 * pi * f3 * t + p3) + DC3;
s4 = A4 * sin(2 * pi * f3 * t + p4) + DC3;
s3 = round(s3);        % �������뵽������Χ
s4 = round(s4);

% ����ʱ���Σ�ֻ��ʾǰ 128 ����
figure;
plot(t(1:128)*1e6, s3(1:128), '-o', 'DisplayName', 's3 ����'); hold on;
plot(t(1:128)*1e6, s4(1:128), '-x', 'DisplayName', 's4 ����');
xlabel('ʱ�� (\mus)');
ylabel('����');
title('s3 �� s4 ���� (13.56 MHz) - ǰ 128 ��������');
legend show;

% �� s3 �� s4 ���� FFT ����
S3 = fft(s3);
S4 = fft(s4);

% ��ȡʵ�����鲿�����Ⱥ���λ
S3_real = real(S3);
S3_imag = imag(S3);
S3_mag = abs(S3/N);                     % ���ȹ�һ��
S3_mag = S3_mag(1:N/2+1);               % ֻȡǰ N/2+1 ����
S3_mag(2:end-1) = 2 * S3_mag(2:end-1);  % ����Ƶ�׼ӱ�
S3_phase = angle(S3);                   % ������λ
S3_phase = S3_phase(1:N/2+1);

S4_real = real(S4);
S4_imag = imag(S4);
S4_mag = abs(S4/N);                     % ���ȹ�һ��
S4_mag = S4_mag(1:N/2+1);
S4_mag(2:end-1) = 2 * S4_mag(2:end-1);
S4_phase = angle(S4);                   % ������λ
S4_phase = S4_phase(1:N/2+1);

% ������λ��
phase_diff = S3_phase - S4_phase;

% Ƶ�ʷֱ���
frequency_resolution = fs / N;          % ����Ƶ�ʷֱ���
f_axis = (0:N/2);                       % ʹ��������Ϊ����

% ����������־�ļ�
log_file = fopen('fft_log.txt', 'w');

% д��ǰ 128 ����� FFT ʵ�����鲿��ȡģ����λ
fprintf(log_file, 'ǰ 128 ����� FFT ���:\n');
for i = 0:127
    fprintf(log_file, '�� %d ����: %d, s3 ʵ��: %f, s3 �鲿: %f, s3 ȡģ: %f, s3 ��λ: %f, ', ...
            i, i, S3_real(i+1), S3_imag(i+1), S3_mag(i+1), S3_phase(i+1));
    fprintf(log_file, 's4 ʵ��: %f, s4 �鲿: %f, s4 ȡģ: %f, s4 ��λ: %f, ��λ��: %f\n', ...
            S4_real(i+1), S4_imag(i+1), S4_mag(i+1), S4_phase(i+1), phase_diff(i+1));
end

% д�� 3000 �� 3500 �㷶Χ�� FFT ʵ�����鲿��ȡģ����λ
fprintf(log_file, '\n3000 �� 3500 ����� FFT ���:\n');
for i = 3000:3500
    fprintf(log_file, '�� %d ����: %d, s3 ʵ��: %f, s3 �鲿: %f, s3 ȡģ: %f, s3 ��λ: %f, ', ...
            i, i, S3_real(i+1), S3_imag(i+1), S3_mag(i+1), S3_phase(i+1));
    fprintf(log_file, 's4 ʵ��: %f, s4 �鲿: %f, s4 ȡģ: %f, s4 ��λ: %f, ��λ��: %f\n', ...
            S4_real(i+1), S4_imag(i+1), S4_mag(i+1), S4_phase(i+1), phase_diff(i+1));
end

% ��Ƶ�ʷֱ���д����־�ļ�
fprintf(log_file, '\nFFT Ƶ�ʷֱ���: %f Hz\n', frequency_resolution);

% �ر���־�ļ�
fclose(log_file);

% ���Ʒ�����ͼ
figure;
subplot(2, 1, 1);
stem(f_axis, S3_mag, 'filled', 'DisplayName', 's3 ����'); hold on;
xlabel(['Ƶ������, ÿ��ֱ��� = ', num2str(frequency_resolution), ' Hz']);
ylabel('����');
title('s3 ���εķ�����ͼ (FFT)');
legend show;

subplot(2, 1, 2);
stem(f_axis, S4_mag, 'filled', 'DisplayName', 's4 ����');
xlabel(['Ƶ������, ÿ��ֱ��� = ', num2str(frequency_resolution), ' Hz']);
ylabel('����');
title('s4 ���εķ�����ͼ (FFT)');
legend show;

% ������λ��ͼ
figure;
subplot(2, 1, 1);
plot(f_axis, S3_phase, '-o', 'DisplayName', 's3 ��λ');
xlabel(['Ƶ������, ÿ��ֱ��� = ', num2str(frequency_resolution), ' Hz']);
ylabel('��λ (����)');
title('s3 ���ε���λͼ (FFT)');
legend show;

subplot(2, 1, 2);
plot(f_axis, S4_phase, '-x', 'DisplayName', 's4 ��λ');
xlabel(['Ƶ������, ÿ��ֱ��� = ', num2str(frequency_resolution), ' Hz']);
ylabel('��λ (����)');
title('s4 ���ε���λͼ (FFT)');
legend show;

% ������λ��ͼ
figure;
plot(f_axis, phase_diff, '-o', 'DisplayName', '��λ�� (s3 - s4)');
xlabel(['Ƶ������, ÿ��ֱ��� = ', num2str(frequency_resolution), ' Hz']);
ylabel('��λ�� (����)');
title('s3 �� s4 ����λ��ͼ');
legend show;

% ��־�ļ������ɲ������ڵ�ǰĿ¼��
disp('FFT �������־��Ϣ�ѱ��浽�ļ� fft_log.txt');

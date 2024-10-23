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

% ���� s3 ����
figure;
plot(t*1e6, s3, '-o');  % t*1e6 ת��Ϊ΢����ʾ
xlabel('ʱ�� (\mus)');
ylabel('����');
title('s3 ���� (13.56 MHz)');
legend('s3');

% �� s3 ���� FFT ����
S3 = fft(s3);
S3_mag = abs(S3/N);           % ���� FFT ���ȣ�����һ��
S3_mag = S3_mag(1:N/2+1);     % ֻȡǰ N/2+1 ���㣨ʵ����
S3_mag(2:end-1) = 2*S3_mag(2:end-1); % ����Ƶ�׼ӱ�

% Ƶ����
f_axis = (0:N/2)*(fs/N);      % Ƶ����

% ����Ƶ��ͼ
figure;
stem(f_axis/1e6, S3_mag, 'filled');  % ת��Ϊ MHz ��ʾ
xlabel('Ƶ�� (MHz)');
ylabel('����');
title('s3 ���ε�Ƶ��ͼ (FFT)');

% ���㲢��ʾƵ�ʷֱ���
frequency_resolution = fs / N;
disp(['FFT Ƶ�ʷֱ���: ', num2str(frequency_resolution), ' Hz']);

% ad9248_signal_ADTT1_1.m
% 描述：直接运行脚本，读取指定路径的 CSV 文件，提取数据并生成图表。

% 数据文件的绝对路径
file_path = 'D:\JIZY\matlab\sin_fft\matlab_prj\AD9248.csv';

try
    % 打开文件
    fid = fopen(file_path, 'r');
    if fid == -1
        error('无法打开文件: %s', file_path);
    end

    % 跳过分页符前的数据，找到有效内容的起始位置
    is_data_start = false;
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'Vpp,vpp,DATA,DEC')
            is_data_start = true;
            break;
        end
    end

    if ~is_data_start
        error('未找到有效的数据起始位置');
    end

    % 读取数据
    data = textscan(fid, '%f%*s%*s%*s%*s%f%*s', 'Delimiter', ',', 'HeaderLines', 0);
    fclose(fid);

    % 提取所需的列
    x_data = data{1}(2:min(100, length(data{1}))); % 第1列，第2行到第100行
    y_data = data{2}(2:min(100, length(data{2}))); % 第6列

    % 检查数据完整性
    if isempty(x_data) || isempty(y_data)
        error('读取的数据不足以生成图表');
    end

    % 绘制图表
    figure;
    plot(x_data, y_data, '-o', 'LineWidth', 1.5);
    xlabel('Vpp (Index)');
    ylabel('V (mV)');
    title('Vpp vs V (mV)');
    grid on;

    % 保存图表
    [path, name, ~] = fileparts(file_path);
    output_file = fullfile(path, [name, '_chart.png']);
    saveas(gcf, output_file);
    disp(['图表已保存为: ', output_file]);

catch ME
    % 错误处理
    disp(['处理文件时发生错误: ', ME.message]);
    if exist('fid', 'var') && fid ~= -1
        fclose(fid);
    end
end

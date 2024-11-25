import chardet

def detect_file_encoding(file_path):
    with open(file_path, 'rb') as file:  # 以二进制方式打开文件
        raw_data = file.read(10000)  # 读取文件前10000字节
        result = chardet.detect(raw_data)  # 检测编码
        return result['encoding']

def generate_chart_from_vcs(file_path):
    """
    从VCS文件中读取数据并生成图表。
    
    参数:
        file_path (str): VCS文件的路径。
    """
    try:
        # 检测文件编码
        encoding = detect_file_encoding(file_path)
        print(f"检测到文件编码为: {encoding}")
        
        # 使用检测到的编码打开文件
        with open(file_path, 'r', encoding=encoding) as file:
            lines = file.readlines()

        # 找到分页符后的数据
        data_start = None
        for i, line in enumerate(lines):
            if 'Vpp,vpp,DATA,DEC' in line:  # 数据标题行
                data_start = i + 1
                break
        
        if data_start is None:
            raise ValueError("未找到有效的数据起始位置")
        
        # 读取数据到 DataFrame
        data_lines = lines[data_start:]
        data = pd.DataFrame(
            [line.strip().split(',') for line in data_lines if line.strip()],  # 忽略空行
            columns=["Vpp", "vpp", "DATA", "DEC", "lsb(14bit)", "V(mV)", "V补"]
        )
        
        # 转换列类型
        data["Vpp"] = pd.to_numeric(data["Vpp"], errors="coerce")
        data["V(mV)"] = pd.to_numeric(data["V(mV)"], errors="coerce")
        
        # 筛选出需要的数据
        x_data = data["Vpp"].iloc[1:101].dropna()  # 第1列，从第2行到第100行
        y_data = data["V(mV)"].iloc[1:101].dropna()  # 第6列的对应数据
        
        if x_data.empty or y_data.empty:
            raise ValueError("提取的数据不足以绘制图表")
        
        # 绘图
        plt.figure(figsize=(10, 6))
        plt.plot(x_data, y_data, marker='o', label="Vpp vs V(mV)")
        plt.xlabel("Vpp (Index)")
        plt.ylabel("V (mV)")
        plt.title("Vpp vs V (mV) Chart")
        plt.grid(True)
        plt.legend()
        plt.tight_layout()
        
        # 保存图表
        output_file = file_path.replace('.csv', '_chart.png')  # 替换文件扩展名
        plt.savefig(output_file)
        plt.show()
        
        print(f"图表已保存为 {output_file}")
    
    except Exception as e:
        print(f"处理文件时发生错误: {e}")

# 示例使用
file_path = r"D:\JIZY\matlab\sin_fft\matlab_prj\AD9248.csv"  # 使用绝对路径
generate_chart_from_vcs(file_path)

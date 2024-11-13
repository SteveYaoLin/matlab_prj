% MATLAB Script to Calculate Magnitude and Phase from FFT Output in 1QN Format
% Input: Real and Imaginary parts in two's complement, 15-bit signed fixed-point 1QN
% Output: Phase in two's complement, 15-bit signed fixed-point 2Q13

% Define input data (two's complement 15-bit signed 1QN fixed-point format)
real_part_hex = '0D71';  % Example input for Real part
imag_part_hex = '7993';  % Example input for Imaginary part

% Convert hexadecimal input to decimal integers
real_part = hex2dec(real_part_hex);
imag_part = hex2dec(imag_part_hex);

% Check if the real part is negative (15-bit two's complement)
if real_part >= 2^14
    real_part = real_part - 2^15;
end

% Check if the imaginary part is negative (15-bit two's complement)
if imag_part >= 2^14
    imag_part = imag_part - 2^15;
end

% Display real and imaginary parts
fprintf('Real Part (Decimal): %d\n', real_part);
fprintf('Imaginary Part (Decimal): %d\n', imag_part);

% Convert to 1QN fixed-point values (in range [-1, 1))
real_val = real_part / 2^14;
imag_val = imag_part / 2^14;

% Display the fixed-point values
fprintf('Real Part (Fixed-point 1QN): %.4f\n', real_val);
fprintf('Imaginary Part (Fixed-point 1QN): %.4f\n', imag_val);

% Step 1: Calculate Magnitude
magnitude = sqrt(real_val^2 + imag_val^2);
fprintf('Magnitude (Floating-point): %.4f\n', magnitude);

% Convert magnitude to 15-bit signed 1QN format (two's complement)
magnitude_fixed = round(magnitude * 2^14);
if magnitude_fixed >= 2^15
    magnitude_fixed = 2^15 - 1; % Saturate at maximum value for 15-bit signed
end
fprintf('Magnitude (1QN Fixed-point, Hex): 0x%04X\n', magnitude_fixed);

% Step 2: Calculate Phase using arctan(imag/real)
% Here, arctan produces a result in the range [-π/2, π/2]
if real_val == 0  % To avoid division by zero
    phase_rad = sign(imag_val) * pi / 2;
else
    phase_rad = atan(imag_val / real_val);
end
fprintf('Phase (Radians): %.4f\n', phase_rad);

% Convert phase to 15-bit signed 2Q13 format
% Scale by 2^13 as required by Xilinx CORDIC phase output in fix15_12 format
phase_fixed = round(phase_rad * 2^13 / (pi / 2));

% Ensure output is within 15-bit signed range for two's complement
if phase_fixed >= 2^14
    phase_fixed = 2^14 - 1;  % Saturate positive limit
elseif phase_fixed < -2^14
    phase_fixed = -2^14;     % Saturate negative limit
end

% Convert negative values to two's complement format
if phase_fixed < 0
    phase_fixed = phase_fixed + 2^15;
end

fprintf('Phase (2Q13 Fixed-point, Hex): 0x%04X\n', phase_fixed);

% Display final results
fprintf('Final Results:\n');
fprintf('Magnitude (1QN, Hex): 0x%04X\n', magnitude_fixed);
fprintf('Phase (2Q13, Hex): 0x%04X\n', phase_fixed);

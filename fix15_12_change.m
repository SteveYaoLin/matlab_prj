function main()
    % Define an example decimal number within the range [-π/2, π/2]
    decimalNumber = pi / 4;

    % Convert the decimal number to 1Q12 fixed-point format
    fixedPointValue = decimal_to_1Q12(decimalNumber);
    fprintf('Decimal Number: %.4f\n', decimalNumber);
    fprintf('1Q12 Format (hex): %s\n', dec2hex(fixedPointValue, 4));

    % Convert the 1Q12 fixed-point value back to a 4-digit decimal format
    recoveredDecimal = Q12_to_decimal(fixedPointValue);
    fprintf('Recovered Decimal (4 digits): %.4f\n', recoveredDecimal);

    % Define a 15-bit hexadecimal 1Q12 format variable "phase"
    phaseHex = '0d71'; % Example value, can be changed
    fprintf('\nOriginal Phase (hex): %s\n', phaseHex);

    % Convert "phase" from hexadecimal 1Q12 format to signed decimal
    phaseFixed = hex2dec(phaseHex);
    phaseDecimal = Q12_to_decimal(phaseFixed);
    fprintf('Phase in Decimal (4 digits): %.4f\n', phaseDecimal);

    % Convert back the phase decimal to 1Q12 fixed-point hex format
    phaseFixedBack = decimal_to_1Q12(phaseDecimal);
    fprintf('Converted Back Phase (hex): %s\n', dec2hex(phaseFixedBack, 4));
end

function fixedPointValue = decimal_to_1Q12(decimalNumber)
    % Convert a decimal number in the range [-π/2, π/2] to 1Q12 fixed-point format
    scaleFactor = 2^12;

    % Convert decimal to fixed-point by scaling and rounding
    fixedPointValue = round(decimalNumber * scaleFactor);

    % Ensure the result is within the 15-bit signed range for 1Q12 format
    if fixedPointValue > 2^14 - 1
        fixedPointValue = 2^14 - 1; % Positive saturation
    elseif fixedPointValue < -2^14
        fixedPointValue = -2^14; % Negative saturation
    end

    % Convert to 15-bit representation by handling negative values
    if fixedPointValue < 0
        fixedPointValue = bitand(fixedPointValue, 2^15 - 1); % Apply 15-bit mask
    end
end

function decimalValue = Q12_to_decimal(fixedPointValue)
    % Convert a 1Q12 fixed-point value (15-bit signed integer) to a decimal
    scaleFactor = 2^12;

    % Handle negative values in 15-bit two's complement format
    if bitget(fixedPointValue, 15) == 1
        fixedPointValue = fixedPointValue - 2^15;
    end

    % Convert back to decimal by dividing by scale factor
    decimalValue = fixedPointValue / scaleFactor;
end

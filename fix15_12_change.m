function main()
    % Main script to test the conversion functions
    % Define an example decimal number within the range [-π/2, π/2]
    decimalNumber = pi / 4; 

    % Convert the decimal number to 1Q12 fixed-point format
    fixedPointValue = decimal_to_1Q12(decimalNumber);
    fprintf('Decimal Number: %.4f\n', decimalNumber);
    fprintf('1Q12 Format (binary): %s\n', dec2bin(fixedPointValue, 15));

    % Convert the 1Q12 fixed-point value back to a 4-digit decimal format
    recoveredDecimal = Q12_to_decimal(fixedPointValue);
    fprintf('Recovered Decimal (4 digits): %.4f\n', recoveredDecimal);
end

function fixedPointValue = decimal_to_1Q12(decimalNumber)
    % Convert a decimal number in the range [-π/2, π/2] to 1Q12 fixed-point format
    % Scale factor for 1Q12 format (12 fractional bits)
    scaleFactor = 2^12;

    % Convert decimal to fixed-point by scaling and rounding
    fixedPointValue = round(decimalNumber * scaleFactor);

    % Ensure the result is within the 15-bit signed range for 1Q12 format
    if fixedPointValue > 2^14 - 1
        fixedPointValue = 2^14 - 1; % Positive saturation
    elseif fixedPointValue < -2^14
        fixedPointValue = -2^14; % Negative saturation
    end
end

function decimalValue = Q12_to_decimal(fixedPointValue)
    % Convert a 1Q12 fixed-point value (15-bit signed integer) to a 4-digit decimal
    % Scale factor for 1Q12 format (12 fractional bits)
    scaleFactor = 2^12;

    % Convert back to decimal by dividing by scale factor
    decimalValue = fixedPointValue / scaleFactor;
end

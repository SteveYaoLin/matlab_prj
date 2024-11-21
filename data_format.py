def decimal_to_fixed_point(value, total_bits, int_bits, frac_bits):
    """
    Convert a signed decimal number into fixed-point representation (original code, one's complement, and two's complement).

    :param value: Signed decimal number to be converted.
    :param total_bits: Total number of bits for representation (including the sign bit).
    :param int_bits: Number of bits for the integer part.
    :param frac_bits: Number of bits for the fractional part.
    :return: A dictionary containing original code, one's complement, and two's complement as binary and hexadecimal.
    """
    if total_bits != int_bits + frac_bits + 1:
        raise ValueError("Total bits must be equal to 1 (sign bit) + int_bits + frac_bits")

    # Scale the input value to fixed-point range
    scale_factor = 2 ** frac_bits
    scaled_value = round(value * scale_factor)

    # Compute the range of the fixed-point representation
    max_val = (2 ** (total_bits - 1)) - 1
    min_val = -(2 ** (total_bits - 1))

    if not (min_val <= scaled_value <= max_val):
        raise ValueError(f"Value {value} is out of range for {total_bits}-bit representation")

    # Compute the unsigned binary representation (for positive values)
    unsigned_value = scaled_value & ((1 << total_bits) - 1)

    # Convert to binary strings for representation
    original_code = f"{unsigned_value:0{total_bits}b}"

    # Compute one's complement (only meaningful for negative values)
    if scaled_value < 0:
        ones_complement = ''.join('1' if bit == '0' else '0' for bit in original_code)
    else:
        ones_complement = original_code

    # Compute two's complement
    twos_complement = f"{(unsigned_value & ((1 << total_bits) - 1)):0{total_bits}b}"

    return {
        "original_code": {
            "binary": original_code,
            "hex": f"{int(original_code, 2):X}"
        },
        "ones_complement": {
            "binary": ones_complement,
            "hex": f"{int(ones_complement, 2):X}"
        },
        "twos_complement": {
            "binary": twos_complement,
            "hex": f"{int(twos_complement, 2):X}"
        }
    }

# Example usage
if __name__ == "__main__":
    total_bits = 15
    int_bits = 2
    frac_bits = 12
    value = -0.3927

    result = decimal_to_fixed_point(value, total_bits, int_bits, frac_bits)

    print("Original Code:")
    print(f"  Binary: {result['original_code']['binary']}")
    print(f"  Hex: {result['original_code']['hex']}")

    print("One's Complement:")
    print(f"  Binary: {result['ones_complement']['binary']}")
    print(f"  Hex: {result['ones_complement']['hex']}")

    print("Two's Complement:")
    print(f"  Binary: {result['twos_complement']['binary']}")
    print(f"  Hex: {result['twos_complement']['hex']}")

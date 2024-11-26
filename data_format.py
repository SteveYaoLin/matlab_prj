def decimal_to_fixed_point(value, total_bits, int_bits, frac_bits):
    if total_bits != int_bits + frac_bits + 1:
        raise ValueError("Total bits must be equal to 1 (sign bit) + int_bits + frac_bits")

    # Scale the input value to fixed-point range
    scale_factor = 2 ** frac_bits
    scaled_value = round(value * scale_factor)

    max_val = (2 ** (total_bits - 1)) - 1
    min_val = -(2 ** (total_bits - 1))

    if not (min_val <= scaled_value <= max_val):
        raise ValueError(f"Value {value} is out of range for {total_bits}-bit representation")

    # Compute Original Code (Sign-Magnitude Representation)
    abs_value = abs(scaled_value)
    magnitude = abs_value & ((1 << (total_bits - 1)) - 1)
    sign_bit = '1' if value < 0 else '0'
    original_code = sign_bit + f"{magnitude:0{total_bits - 1}b}"

    # Compute One's Complement
    if scaled_value < 0:
        ones_complement = ''.join('1' if bit == '0' else '0' for bit in original_code)
    else:
        ones_complement = original_code

    # Compute Two's Complement
    unsigned_value = scaled_value & ((1 << total_bits) - 1)
    twos_complement = f"{unsigned_value:0{total_bits}b}"

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
    value = -0.7854

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

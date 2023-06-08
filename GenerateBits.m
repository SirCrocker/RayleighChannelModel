% Generate the desired number of random bits
% n_bits: positive int
function bits_list = Generate_bits(n_bits)
    bits_list = int32(randi([0, 1], [1, n_bits]));
end
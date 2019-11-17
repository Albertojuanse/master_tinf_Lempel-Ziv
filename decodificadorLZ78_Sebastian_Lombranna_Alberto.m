function decodificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputCompressed,filenameOutputUncompressed)
%DECODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This decoder implements the Lempel-Ziv 78 algorithm

%% Retrieve information from ASCII input
% The coder ensures that an byte-even number of bits are used; count them.
input_file_id = fopen(filenameInputCompressed, 'r');
[i, count] = fread(input_file_id,'ubit8');
input_size_bits = count * 8;        % Size of the input in bits

%% Other variables
dictionary = {};                    % Dictionary

%% 

input_file_id = fopen(filenameInputCompressed, 'r');
input = [];
input = [input fread(input_file_id, 1, 'ubit1')];
input = [input fread(input_file_id, 1, 'ubit8')];
input = [input fread(input_file_id, 1, 'ubit2')];
input = [input fread(input_file_id, 1, 'ubit8')];
input = [input fread(input_file_id, 1, 'ubit2')];
input = [input fread(input_file_id, 1, 'ubit8')];
input = [input fread(input_file_id, 1, 'ubit3')];
input = [input fread(input_file_id, 1, 'ubit8')];
input = [input fread(input_file_id, 1, 'ubit3')];
input = [input fread(input_file_id, 1, 'ubit8')];
input = [input fread(input_file_id, 1, 'ubit3')];
input = [input fread(input_file_id, 1, 'ubit8')];
input = [input fread(input_file_id, 1, 'ubit3')];
input = [input fread(input_file_id, 1, 'ubit8')];
input = [input fread(input_file_id, 1, 'ubit8')]
%input = [1 116 2 117 1 117 4 118 3 118 6 119 7 120 3];
fclose(input_file_id);

%% Close output file
fclose(output_file_id);

end
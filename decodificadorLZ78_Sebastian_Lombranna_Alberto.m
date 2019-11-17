function decodificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputCompressed,filenameOutputUncompressed)
%DECODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This decoder implements the Lempel-Ziv 78 algorithm

%% Retrieve ASCII characters from input



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

%% Variables

input_size = size(input, 1);        % Total number of characters
input_pointer = 1;                  % Points the current character analized
pointer_offset = 0;                 % Offset for point the dictionaries
dictionary = {};                    % Dictionary



end
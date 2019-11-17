function decodificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputCompressed,filenameOutputUncompressed)
%DECODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This decoder implements the Lempel-Ziv 78 algorithm

%% Retrieve ASCII characters from input

input_file_id = fopen(filenameInputCompressed, 'r');
input = fread(input_file_id, 'ubit8');
%input = [1 116 2 117 1 117 4 118 3 118 6 119 7 120 3];
fclose(input_file_id);

decoder_output = [];
for i_character = 1:size(input,1)
    decoder_output = [decoder_output input(i_character)];
end
decoder_output

%% Variables

input_size = size(input, 1);        % Total number of characters
input_pointer = 1;                  % Points the current character analized
pointer_offset = 0;                 % Offset for point the dictionaries
dictionary = {};                    % Dictionary
output = [];                        % Output




end
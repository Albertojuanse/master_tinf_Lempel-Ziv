function codificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputUncompressed,filenameOutputCompressed)
%CODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This coder implements the Lempel-Ziv 78 algorithm

%% Retrieve ASCII characters from input

input_file_id = fopen(filenameInputUncompressed);
input = fread(input_file_id);
fclose(input_file_id);


%% Save ASCII characters to output
output_file_id = fopen(filenameOutputCompressed);
fwrite(output_file_id, [], 'uint8');
fclose(output_file_id);

end


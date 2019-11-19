clear all;
tic;
delete coder_output;
delete decoder_output;
codificadorLZ78_Sebastian_Lombranna_Alberto('input','coder_output');
decodificadorLZ78_Sebastian_Lombranna_Alberto('coder_output','decoder_output');

input_file_id = fopen('input', 'r');
[i, count] = fread(input_file_id,'ubit8');
input_bits = count * 8
fclose(input_file_id );

input_file_id = fopen('coder_output', 'r');
[i, count] = fread(input_file_id,'ubit8');
coder_output_bits = count * 8
fclose(input_file_id );

input_file_id = fopen('decoder_output', 'r');
[i, count] = fread(input_file_id,'ubit8');
decoder_output_bits = count * 8
fclose(input_file_id );
tiempo = toc
clear all;
tic;
delete coder_output2;
delete decoder_output2;
codificadorLZ78_Sebastian_Lombranna_Alberto('input2','coder_output2');

tiempo_codificador = toc
tic;
decodificadorLZ78_Sebastian_Lombranna_Alberto('coder_output2','decoder_output2');

input_file_id = fopen('input2', 'r');
[i, count] = fread(input_file_id,'ubit8');
input_bits = count * 8
fclose(input_file_id );

input_file_id = fopen('coder_output2', 'r');
[i, count] = fread(input_file_id,'ubit8');
coder_output_bits = count * 8
fclose(input_file_id );

input_file_id = fopen('decoder_output2', 'r');
[i, count] = fread(input_file_id,'ubit8');
decoder_output_bits = count * 8
fclose(input_file_id );
tiempo_decodificador = toc
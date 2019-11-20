clear all;
tic;
delete coder_outputW;
delete decoder_outputW;
codificadorLZW_Sebastian_Lombranna_Alberto('input','coder_outputW');

tiempo_codificador = toc
tic;
decodificadorLZW_Sebastian_Lombranna_Alberto('coder_outputW','decoder_outputW');

input_file_id = fopen('input', 'r');
[i, count] = fread(input_file_id,'ubit8');
input_bits = count * 8
fclose(input_file_id );

input_file_id = fopen('coder_outputW', 'r');
[i, count] = fread(input_file_id,'ubit8');
coder_output_bits = count * 8
fclose(input_file_id );

input_file_id = fopen('decoder_outputW', 'r');
[i, count] = fread(input_file_id,'ubit8');
decoder_output_bits = count * 8
fclose(input_file_id );
tiempo_decodificador = toc
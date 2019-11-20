clear all;
tic;
delete coder_output2;
delete decoder_output2;
delete coder_output;
delete decoder_output;
codificadorLZ78_Sebastian_Lombranna_Alberto('input','coder_output');

tiempo_codificador = toc
tic;
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
tiempo_decodificador = toc

input_file_id = fopen('prueba', 'w+');
fwrite(input_file_id, [80 65],'ubit8');
fseek(input_file_id, 0, 'bof');
fwrite(input_file_id, [112 97],'ubit8');
fclose(input_file_id);



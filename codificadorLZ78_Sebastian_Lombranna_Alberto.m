function codificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputUncompressed,filenameOutputCompressed)
%CODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This coder implements the Lempel-Ziv 78 algorithm

%% Retrieve ASCII characters from input

input_file_id = fopen(filenameInputUncompressed, 'r');
input = fread(input_file_id, 'ubit8');
%input = [116; 117; 116; 117; 118 ;116 ;117 ;118 ;119; 120; 116; 117];
fclose(input_file_id);

%% Variables

input_size = size(input, 1);        % Total number of characters
input_pointer = 1;                  % Points the current character analized
pointer_offset = 0;                 % Offset for point the dictionaries
dictionary = containers.Map;        % Dictionary
i_entry = 0;                        % Dictionary index
total_bits = 0;                     % Number of bits saved in the file
output_file_id = fopen(filenameOutputCompressed, 'a');

%% Algorithm description
% coge la entrada i
% coge la entrada j del diccionario
%   si coincide la entrada i con el caracter 1 de la entrada j
%       ¿hay más caracteres en la entrada?
%       coge la entrada i + 1
%       si coincide la entrada i + 1 con el caracter 2 de la entrada j
%           ¿hay más caracteres en la entrada? -> SI
%           coge la entrada i + 2
%           (···)
%
%       si coincide la entrada i + 1 con el caracter 2 de la entrada j
%           ¿hay más caracteres en la entrada? -> NO
%               cadena válida; guardarla, no habrá otra igual
%
%       si no coincide la entrada i + 1 con el caracter 2 de la entrada j
%           descartar; hay otra que es la buscada pero no esta
%
%   si no coincide la entrada i con el caracter 1 de la entrada j
%   	descartar; la buscada no es esta
%
% OJO: break en el momento que se encuentre una cadena del tamaño
% máximo almacenado
%
% OJO: break en el momento que se finalice el diccionario
% preinicializado; llevar un conteo

%% Execution

% The algorithm will analyze each character one by one, using a pointers
% for the entries analyzed
if input_size > 0
    while  input_pointer <= input_size

        % Search the current input and following until a codeword can be
        % generated

        % Inspec the entry for searching if the first character is the
        % searched one;
        % then, if so, verify the second character and so on.
        searched_entry = [];
        i_entry_found = -1;
        entry_found = [];
        pointer_offset = 0;
        flag_entry_found = true;
        while flag_entry_found

            if (input_pointer + pointer_offset <= input_size)
                try
                    searched_entry = [searched_entry input(input_pointer + pointer_offset,1)];
                    i_entry_found = dictionary(num2str(searched_entry));
                    entry_found = searched_entry;
                catch exception
                    flag_entry_found = false;
                    break;
                end
            else
                flag_entry_found = false;
                break;
            end

            pointer_offset = pointer_offset + 1;

        end

        % Upload the dictionary and save the codeword
        if i_entry_found < 0
            % No entry found

            i_entry = i_entry + 1;
            entry_found = searched_entry;
            dictionary(num2str(entry_found)) = i_entry;
            i_entry_found = i_entry;

            % Precision needed to codify the maximum dictionary entry
            % posible
            i_entry_bin = dec2bin(i_entry);
            num_bits = 8*ceil(size(i_entry_bin,2)/8);
            precision = strcat('ubit',num2str(num_bits));

            % Save the codeword
            fwrite(output_file_id, i_entry_found, precision);
            fwrite(output_file_id, entry_found,'ubit8');
            total_bits = total_bits + num_bits + 8;

            % Depending of the value of pointer_offset value, if the entry is
            % found and a new codeword is compose, the input_pointer must be
            % uploaded.
            input_pointer = input_pointer + pointer_offset + 1;

        else
            % Entry found was saved while searching it
            if input_pointer + pointer_offset <= input_size
                i_next_input_after_entry_found = input_pointer + pointer_offset;
                next_input_after_entry_found = input(i_next_input_after_entry_found,1);            
                i_entry = i_entry + 1;
                dictionary(num2str([entry_found next_input_after_entry_found])) = i_entry;
            else            
                next_input_after_entry_found = 0;
            end

            % Precision needed to codify the maximum dictionary entry posible
            i_entry_bin = dec2bin(i_entry);        
            num_bits = 8*ceil(size(i_entry_bin,2)/8);
            precision = strcat('ubit',num2str(num_bits));

            % Save the codeword
            fwrite(output_file_id, i_entry_found, precision);
            fwrite(output_file_id, next_input_after_entry_found,'ubit8');
            total_bits = total_bits + num_bits + 8;

            % Depending of the value of pointer_offset value, if the entry is
            % found and a new codeword is compose, the input_pointer must be
            % uploaded.
            input_pointer = input_pointer + pointer_offset + 1;

        end

    end
end
%% Close the output file
fclose(output_file_id);

end
function codificadorLZ78_Sebastian_Lombranna_Alberto(filenameInputUncompressed,filenameOutputCompressed)
%CODIFICADORLZ78_SEBASTIAN_LOMBRANNA_ALBERTO This coder implements the Lempel-Ziv 78 algorithm

%% Retrieve ASCII characters from input

input_file_id = fopen(filenameInputUncompressed, 'r');
input = fread(input_file_id, 'ubit8');
input = [116; 117; 116; 117; 118 ;116 ;117 ;118 ;119; 120; 116; 117];
fclose(input_file_id);

%% Variables

input_size = size(input, 1);        % Total number of characters
input_pointer = 1;                  % Points the current character analized
pointer_offset = 0;                 % Offset for point the dictionaries
dictionary = {};                    % Dictionary
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

% -> str_cmp
% -> dec2bin(,8) <- 8 bits ; uint8() lo satura
% -> ojo con parseing a más 
% -> dec2bin( id_entrada , ceil(log2(id_entrada)))

% Sictionary schematic:
%   { [1]   ;
%     [1 2] ;
%     [2]   ;
%     [2 3]
%   }

%% Execution

% The algorithm will analyze each character one by one, using a pointers
% for the entries analyzed
while  input_pointer <= input_size
    
    % Search the current input and following until a codeword can be
    % generated
    % Dictionary schematic:
    %   { [1]   ;
    %     [1 2] ;
    %     [2]   ;
    %     [2 3]
    %   }

    % For each entry of the dictionary
    candidate_entry_found = false;
    i_entry_found = -1;
    size_dictionary = size(dictionary, 1);
    
    for i_entry = 1:size_dictionary
        entry = dictionary{i_entry};
        entry_size = size(entry, 2);
        
        % Inspec the entry for searching if the first character is the
        % searched one;
        % then, if so, verify the second character and so on.
        for i_entry_character = 1:entry_size

            character = entry(1, i_entry_character);

            % The input character analyzed is the current if is the first
            % entry, the current+1 if its the second...                
            pointer_offset = (i_entry_character - 1);

            if input_pointer + pointer_offset <= input_size
                if character == input(input_pointer + pointer_offset,1)
                    % This character is equals to the entry one.
                    candidate_entry_found = true;
                else                    
                    % This character is not equals to the entry one.
                    candidate_entry_found = false;
                    break;
                end
            else
                % If the end of the input is reached, the entry to find is
                % the one which is exactly the rest of the input, so find it 
                candidate_entry_found = false;
                break;
            end
        end

        % Refresh the entry found if this one is longer than the previous one
        if candidate_entry_found
            if i_entry_found < 0
                i_entry_found = i_entry;
            else
                last_entry_found_size = size(dictionary{i_entry_found}, 2);
                new_candidate_entry_size = size(dictionary{i_entry}, 2);

                if new_candidate_entry_size > last_entry_found_size
                    i_entry_found = i_entry;
                end
            end
        end
        % OJO: break en el momento que se encuentre una cadena del tamaño
        % máximo almacenado
        %
        % OJO: break en el momento que se finalice el diccionario
        % preinicializado; llevar un conteo
    end
    
    % Upload the dictionary and save the codeword
    if i_entry_found < 0
        % No entry found
        dictionary{end + 1,1} = [input(input_pointer,1)];
        i_entry_found = size(dictionary,1);
        
        % Precision needed to codify the dictionary entry
        size_dictionary = size(dictionary,1)
        size_dictionary_bin = dec2bin(size_dictionary);
        num_bits = size(size_dictionary_bin,2);
        precision = strcat('ubit',num2str(num_bits))

        % Save the codeword
        fwrite(output_file_id, i_entry_found, precision);
        fwrite(output_file_id, input(input_pointer,1),'ubit8');
        
        % Update input pointer
        input_pointer = input_pointer + 1;

    else
        % Entry found
        entry_found = dictionary{i_entry_found};
        if input_pointer + size(entry_found,2) +1 <= input_size
            i_next_input_after_entry = input_pointer + size(entry_found,2);
            next_input_after_entry = input(i_next_input_after_entry,1);
            dictionary{end + 1,1} = [entry_found next_input_after_entry];
        
            % Precision needed to codify the dictionary entry
            size_dictionary = size(dictionary,1)
            size_dictionary_bin = dec2bin(size_dictionary);
            num_bits = size(size_dictionary_bin,2);
            precision = strcat('ubit',num2str(num_bits))
        
            % Save the codeword
            fwrite(output_file_id, i_entry_found, precision);
            fwrite(output_file_id, input(i_next_input_after_entry,1),'ubit8');
            
        else
            % If the end of the input is reached, the entry to find is
            % the one which is exactly the rest of the input and there is
            % not a next entry; the file ends with the entry and so its not
            % even. The decoder will not find the next one and will asume
            % that it's finished.

            % Save the codeword; precision is 8 bits for the last word in
            % any case
            fwrite(output_file_id, i_entry_found, 'ubit8');
        end

        % Depending of the value of pointer_offset alue, if the entry is
        % found and a new codeword is compose, the input_pointer must be
        % uploaded 
        input_pointer = input_pointer + (size(entry_found,2) + 1);
    end

end

%% Close output file
fclose(output_file_id);

end


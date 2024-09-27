function [matlab_output_file] = read_lammps_dump(par, current_dir, input_dir, output_dir)

    % input:
    % par: simulation parameters
    % output_dir: output directory

    % output:
    % matlab_output_file: path of saved MATLAB file

    % function reads lammps output and saves matlab files containing the
    % output data

    % matlab file path 
    matlab_output_file = [output_dir '/dump.mat'];
    % if matlab file already exists, no need to create it
    if (~isfile(matlab_output_file))
        % files to read are dump files
        fileNamesStruct = dir([output_dir '/dump*']); %Find input files.
        for j = 1:length(fileNamesStruct) 
            file_paths{j,:} = [output_dir '/' fileNamesStruct(j).name]; 
        end
    
        file_paths=natsortfiles(file_paths);
        % Initialize variables
        num_files = length(file_paths);
        timesteps = zeros(num_files, 1);
        num_atoms = [];
        box_bounds = [];
        
        % Read the first file to determine the number of atoms
        fileID = fopen(file_paths{1}, 'r');
        while ~feof(fileID)
            line = fgetl(fileID);
            if startsWith(line, 'ITEM: NUMBER OF ATOMS')
                num_atoms = str2double(fgetl(fileID));
                break;
            end
        end
        fclose(fileID);
        
        % Initialize atom data tensor (num_atoms x 5 x num_files)
        atom_data_tensor = zeros(num_atoms, 5, num_files);
        
        % loop over files
        for i = 1:num_files
            file_path = file_paths{i};
            fileID = fopen(file_path, 'r');
            
            while ~feof(fileID)
                line = fgetl(fileID);
                
                if startsWith(line, 'ITEM: TIMESTEP')
                    timesteps(i) = str2double(fgetl(fileID)) * par.timestep;
                elseif startsWith(line, 'ITEM: BOX BOUNDS')
                    if isempty(box_bounds)
                        box_bounds = zeros(3, 2, num_files);
                    end
                    for j = 1:3
                        bounds_line = fgetl(fileID);
                        box_bounds(j, :, i) = str2double(strsplit(bounds_line));
                    end
                elseif startsWith(line, 'ITEM: ATOMS')
                    for j = 1:num_atoms
                        atom_line = fgetl(fileID);
                        atom_data = str2double(strsplit(atom_line));
                        atom_id = atom_data(1);
                        atom_data_tensor(atom_id, :, i) = atom_data;
                    end
                end
            end
            
            fclose(fileID);
        end

        % save the matlab files
        save(matlab_output_file, "timesteps", "num_atoms", "box_bounds", "atom_data_tensor");
    end
end
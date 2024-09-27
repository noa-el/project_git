function convertDumpToData(dumpFilePath, dataFilePath)
    % function reads data in dump file in file path path dumpFilePath
    % and writes data file containing the same data to file path dataFilePath

    % Open the dump file for reading
    fid = fopen(dumpFilePath, 'r');
    if fid == -1
        error('Could not open dump file.');
    end
    
    % Read the dump file
    timestep = 0;
    numAtoms = 0;
    boxBounds = zeros(3, 2);
    atoms = [];
    
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'ITEM: TIMESTEP')
            timestep = str2double(fgetl(fid));
        elseif contains(line, 'ITEM: NUMBER OF ATOMS')
            numAtoms = str2double(fgetl(fid));
        elseif contains(line, 'ITEM: BOX BOUNDS')
            for i = 1:3
                bounds = str2double(strsplit(fgetl(fid)));
                boxBounds(i, :) = bounds;
            end
        elseif contains(line, 'ITEM: ATOMS')
            atomData = textscan(fid, '%f %f %f %f %f', numAtoms);
            atoms = [atomData{1}, atomData{2}, atomData{3}, atomData{4}, atomData{5}];
        end
    end
    fclose(fid);
    
    % Open the data file for writing
    fid = fopen(dataFilePath, 'w');
    if fid == -1
        error('Could not open data file.');
    end
    
    % Write the header
    fprintf(fid, '# Data file made by MATLAB script\n');
    fprintf(fid, '%d atoms\n', numAtoms);
    fprintf(fid, '%d atom types\n', length(unique(atoms(:, 2))));
    fprintf(fid, '%f %f xlo xhi\n', boxBounds(1, 1), boxBounds(1, 2));
    fprintf(fid, '%f %f ylo yhi\n', boxBounds(2, 1), boxBounds(2, 2));
    fprintf(fid, '%f %f zlo zhi\n', boxBounds(3, 1), boxBounds(3, 2));
    fprintf(fid, '\nAtoms # atomic\n\n');
    
    % Write the atom data
    for i = 1:numAtoms
        fprintf(fid, '%d %d %f %f %f\n', atoms(i, 1), atoms(i, 2), atoms(i, 3), atoms(i, 4), atoms(i, 5));
    end
    
    fclose(fid);
end

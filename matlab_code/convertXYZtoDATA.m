
function convertXYZtoDATA(xyzFilename, dataFilename)
    % function reads xyz in dump file in file path path xyzFilename
    % and writes data file containing the same data to file path dataFilePath
    % the function also deletes the xyz file

    % Open the .xyz file for reading
    fid = fopen(xyzFilename, 'r');
    if fid == -1
        error('Could not open the file %s for reading.', xyzFilename);
    end

    % Read the header information
    header = fgetl(fid); % First line (comment line)
    numAtoms = fscanf(fid, '%d', 1); % Number of atoms
    fgetl(fid);
    numAtomTypes = fscanf(fid, '%d', 1); % Number of atom types
    fgetl(fid);
    
    % Read the box bounds
    xlo = fscanf(fid, '%f', 1);
    xhi = fscanf(fid, '%f', 1);
    fgetl(fid);
    ylo = fscanf(fid, '%f', 1);
    yhi = fscanf(fid, '%f', 1);
    fgetl(fid);
    zlo = fscanf(fid, '%f', 1);
    zhi = fscanf(fid, '%f', 1);
    fgetl(fid);
    
    % Skip the "Atoms # atomic" line
    fgetl(fid);
    fgetl(fid);
    
    % Read the atomic data
    data = fscanf(fid, '%d %d %f %f %f', [5, numAtoms])';
    fclose(fid);

    % Open the .data file for writing
    fid = fopen(dataFilename, 'w');
    if fid == -1
        error('Could not open the file %s for writing.', dataFilename);
    end

    % Write the header
    fprintf(fid, '# Data file made by S.Kim DATE: %s\n', datestr(now, 'yyyy-mm-dd'));
    fprintf(fid, '%d atoms\n', numAtoms);
    fprintf(fid, '%d atom types\n', numAtomTypes);
    fprintf(fid, '%.6f %.6f xlo xhi\n', xlo, xhi);
    fprintf(fid, '%.6f %.6f ylo yhi\n', ylo, yhi);
    fprintf(fid, '%.6f %.6f zlo zhi\n', zlo, zhi);
    fprintf(fid, '\nAtoms # atomic\n\n');

    % Write the atomic data
    for i = 1:numAtoms
        fprintf(fid, '%d %d %.8f %.8f %.8f\n', data(i, 1), data(i, 2), data(i, 3), data(i, 4), data(i, 5));
    end

    % Close the .data file
    fclose(fid);
    
    % Delete the .xyz file
    delete(xyzFilename);
end

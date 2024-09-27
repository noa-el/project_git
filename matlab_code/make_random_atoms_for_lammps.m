function [r,type,sim_box] = make_random_atoms_for_lammps(number_of_atoms, box_lim)
    % input: 
    % number_of_atoms: number of atoms
    % box_lim: the length of the box sides

    % output: 
    % r: random locations for the atoms 
    % type: type of the atoms
    % sim_box: box limits in x,y,z axis

    % the function 
    % generates random locations for particles
    % and returns them, the box limits, and atom types

    % initialize r
    r = zeros(number_of_atoms, 3);
    % write sim_box
    sim_box=[0 box_lim;
        0 box_lim;
        0 box_lim];
    
    % Define the range [a, b], same for every axis
    a = 0;
    b = box_lim;
    
    % loop over axis x,y,z
    for axis_ind = 1:3
        % Generate a vector of random uniformly distributed numbers in the range [a, b]
        r(:,axis_ind) = a + (b-a) * rand(1, number_of_atoms);
    end
    
    % atom type is one for all atoms
    type=ones(length(r(:,1)),1);

end
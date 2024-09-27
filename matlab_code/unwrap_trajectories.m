function unwrapped_atom_locations = unwrap_trajectories(atom_locations, box_bounds)
    % input:
    % atom_locations: the atom locations in all simulation timesteps with
    % ***PERIODIC BOUNDRY CONDITIONS***
    % box_bounds: the x,y,z limits of the simulation box
    
    % output:
    % unwrapped_atom_locations: atom locations unwrapped - continous
    % unlimited locations instead of periodic boundry conditions jumps

    % the function “unwraps” particle coordinates to make the particle trajectories continuous

    % set a threshold distance from the box limit
    threshold = 2;
    % initialize unwrapped_atom_locations
    unwrapped_atom_locations = atom_locations;
    % loop over atoms
    for atom_i = 1:size(atom_locations,1)
        % loop over axes
        for axis_i = 1:size(atom_locations,2)
            % initialize num_to_add - a sum of the addings to cancel periodic jumps
            num_to_add = 0;
            % loop over timesteps
            for timestep = 1:size(atom_locations,3) - 1
                % update unwrapped_atom_locations
                unwrapped_atom_locations(atom_i, axis_i, timestep) = atom_locations(atom_i, axis_i, timestep) + num_to_add;
                % check if particle was close to different sides in consecutive timesteps
                % if so, update num_to_add
                if(atom_locations(atom_i, axis_i, timestep) - box_bounds(axis_i,1,timestep) < threshold) && (box_bounds(axis_i,2,timestep + 1) - atom_locations(atom_i, axis_i, timestep + 1) < threshold)
                    num_to_add = num_to_add - (box_bounds(axis_i,2,timestep + 1) - box_bounds(axis_i,1,timestep)); 
                elseif (atom_locations(atom_i, axis_i, timestep + 1) - box_bounds(axis_i,1,timestep + 1) < threshold) && (box_bounds(axis_i,2,timestep) - atom_locations(atom_i, axis_i, timestep) < threshold)
                    num_to_add = num_to_add + (box_bounds(axis_i,2,timestep + 1) - box_bounds(axis_i,1,timestep));
                end
            end
            % last step update unwrapped_atom_locations
            unwrapped_atom_locations(atom_i, axis_i, end) = atom_locations(atom_i, axis_i, end) + num_to_add;
        end
    end
end
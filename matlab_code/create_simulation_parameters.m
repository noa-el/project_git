function par = create_simulation_parameters(temp, s, rstart, timestep, dumpstep, nstep)
    % input: the parameters that can be different in the dislocation first and second run 
    % temp: temperature
    % s: "softness" parameter
    % rstart: start radius of potential table
    % timestep: time between steps
    % dumpstep: number of steps between output steps
    % nstep:  number of simulation steps

    % output:
    % par: a struct of the parameters, including the input parameters and

    % run_analysis: 1 for running analysis
    % langevin: 0 for brownian, 1 for langevin
    % fcc: 0 for RANDOM, 1 for FCC
    % center: 1 center of mass is constant during simulation
    % dislocation: 0 - no dislocation, 1 - lomer dislocation, 2 - perfect dislocation

    % phi: volume fraction 
    % r_cut: potential r cut
    % epsilon: potential coefficient
    % force_resolution: number of points from rstart to rcut

    % parameters for RANDOM run - relevant only if par.fcc == 0
    % RANDOM_number_of_atoms: number of atoms
    % RANDOM_box_lim: side length of the simulation box

    % parameters for clean FCC run -  relevant only if par.fcc == 1, no dislocation
    % d: nearest neighbor distance
    % N: number of unit cell along x, y, z-axis. (Total: ~4*N^(3) number of
    % particles)

    % RUN PARAMETERS
    par.run_analysis = 0; % 1 for running analysis
    par.langevin = 0; % 0 for brownian, 1 for langevin
    par.fcc = 1; % 0 for RANDOM, 1 for FCC
    par.center = 1; % 1 center of mass is constant during simulation
    par.dislocation = 2; % 0 - no dislocation, 1 - lomer dislocation, 2 - perfect dislocation

    % parameters for RANDOM run - relevant only if par.fcc == 0
    par.RANDOM_number_of_atoms = 10; % number of atoms
    par.RANDOM_box_lim = 100; % side length of the simulation box

    % parameters for clean FCC run -  relevant only if par.fcc == 1, no dislocation
    par.N = 4; % number of unit cell along x, y, z-axis.
    if (par.dislocation)
        par.d = 1; % nearest neighbor distance, DO NOT CHANGE - d is 1 in the dislocation code
    else
        par.d = 1; % nearest neighbor distance, can be changed
    end

    % PARAMETERS RELEVANT FOR ALL RUNS

    % POTENTIAL PARAMETERS - PARTICLE RADIUS
    %par.phi = 0.7;
    par.phi = 0.6; % volume fraction
    r_over_d = (par.phi * 3 / (4 * sqrt(2) * pi))^(1/3);
    par.rcut = round(2 * par.d * r_over_d,3); % potential r cut
    
    % POTENTIAL PARAMETERS
    % VanSaders, Bryan, Julia Dshemuchadse, and Sharon C. Glotzer. 
    % "Strain fields in repulsive colloidal crystals." Physical Review Materials 2.6 (2018): 063604.
    % eq 2
    par.epsilon = 1; % potential coefficient
    par.s = s; % "softness" parameter
    par.rstart = rstart; % start radius of potential table
    par.force_resolution = 10000; % number of points from rstart to rcut.

    % SIMULATION PARAMETERS
    %par.timestep = 0.001;
    par.timestep = timestep; % time between steps
    %par.dumpstep = par.nstep/10000;
    par.dumpstep = dumpstep; % number of steps between output steps
    %par.nstep = 1000000;
    par.nstep = nstep; % number of simulation steps

    %par.dumpstep = 1;
    par.temp = temp;   %temperature

end
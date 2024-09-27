%close all; clear; clc;

% relevant directories
current_dir = 'C:/Users/noae1/lammps';
addpath 'C:\Users\noae1\lammps\matlab_code'

% PARAMETERS FOR NO DISLOCATION RUN OR DISLOCATION FIRST RUN
% S, R_CUT AND R_START MUST COMPLY: -s * 2^(1/6) + r_cut = d < r_start 
%(temp, s, rstart, timestep, dumpstep, nstep)

%par = create_simulation_parameters(0.01, 0.1, 0.88, 0.00001, 100, 1000000);
par = create_simulation_parameters(0.0001, 1, 0.5, 0.00001, 100, 1000);

% strings for paths
if par.dislocation > 0
    parameter_str = ['dislocation' num2str(par.dislocation) '_'];
else
    if(par.fcc)
        parameter_str = ['FCC_phi_' num2str(par.phi) '_N_' num2str(par.N) '_d_' num2str(par.d)];
    else
        parameter_str = ['RANDOM_number_of_atoms_' num2str(par.RANDOM_number_of_atoms) '_box_lim_' num2str(par.RANDOM_box_lim)];
    end
end

if(par.langevin == 1)
    langevin_str = 'langevin';
else
    langevin_str = 'brownian';
end

% results directories
results_dir = [current_dir '/results/' parameter_str langevin_str '_rcut_' num2str(par.rcut)];
input_dir = [results_dir '/input'];
output_dir = [results_dir '/output'];

if ~exist(results_dir, 'dir')
   mkdir(results_dir)
   mkdir(input_dir)
   mkdir(output_dir)
end


% create input file 
if par.dislocation > 0
    makeMixedStraightDislocation(input_dir, par.dislocation)
    convertXYZtoDATA([input_dir '\loc.xyz'], [input_dir '\loc_test.data'])
else
    write_lammps_data_file(par, [input_dir '\loc_test.data']);
end

% mid run - because dislocation files have too small distances between pairs 
% a run with soft potential will seperate them
if par.dislocation > 0
    % DISLOCATION FIRST RUN
    mid_output_dir = [output_dir '/' 'temperature_'  num2str(par.temp) '_s_' num2str(par.s) '_rstart_' num2str(par.rstart) '_timestep_' num2str(par.timestep) '_dumpstep_' num2str(par.dumpstep) '_nstep_' num2str(par.nstep)];
    if ~exist(mid_output_dir, 'dir')
        batch_md_hardsphere_run(par, current_dir, input_dir, mid_output_dir)
        input_dir = [mid_output_dir '/mid_input'];
        mkdir(input_dir)
        convertDumpToData([num2str(mid_output_dir) '/dump.' num2str(par.nstep)], [input_dir '/loc_test.data'])
    end
    input_dir = [mid_output_dir '/mid_input'];
    % PARAMETERS FOR SECOND DISLOCATION RUN
    % S, R_CUT AND R_START MUST COMPLY: -s * 2^(1/6) + r_cut = d < r_start 
    %(temp, s, rstart, timestep, dumpstep, nstep)
    % par = create_simulation_parameters(0.0001, 0.4, 0.5, 0.001, 10000, 1000000);
     par = create_simulation_parameters(0.0001, 0.2, 0.75, 0.0001, 10000, 10000000);
else
    mid_output_dir = output_dir;
end

% output directory
final_output_dir = [mid_output_dir '/' 'temperature_'  num2str(par.temp) '_s_' num2str(par.s) '_rstart_' num2str(par.rstart) '_timestep_' num2str(par.timestep) '_dumpstep_' num2str(par.dumpstep) '_nstep_' num2str(par.nstep) 'L_80'];

% NO DISLOCATION RUN OR DISLOCATION SECOND RUN
if (~isfolder(final_output_dir))
    % run lammps
    batch_md_hardsphere_run(par, current_dir, input_dir, final_output_dir)
end

if(par.run_analysis)
    % read LAMMPS output files
    [matlab_output_file] = read_lammps_dump(par, current_dir, input_dir, final_output_dir);
    % run analysis
    analysis_output_file = results_analysis(matlab_output_file, final_output_dir, 0,0);
    % plot analysis results graphs
    plot_results_analysis(matlab_output_file, analysis_output_file)
end
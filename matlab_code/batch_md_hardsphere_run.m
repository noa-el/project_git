function batch_md_hardsphere_run(par, current_dir, input_dir, output_dir)
    %%%
    potential_file = output_dir + "/potential.table";
    if ~exist(output_dir, 'dir')
       mkdir(output_dir)
    end
    write_pair_style_table(potential_file,par)
    
    fileNamesStruct = dir([input_dir '/loc*']); %Find input files.
    for j = 1:length(fileNamesStruct) 
        fileNames{j,:} = fileNamesStruct(j).name; 
    end
    fileNames=natsortfiles(fileNames);
    
    for j = 1:length(fileNames)
        intemplate = write_lammps_script(input_dir,fileNames{j}, par);
        lammps_run(output_dir,intemplate,current_dir)
    end
end

function intemplate = write_lammps_script(input_dir, filename, par)
    %%% Make an input script for LAMMPS.
    
    if(par.langevin == 1)
        langevin_command = "fix 2 mobile langevin "+num2str(par.temp)+" "+num2str(par.temp)+" 1.0 3213";
    else
        langevin_command = "fix 2 mobile brownian "+num2str(par.temp)+" 3213 gamma_t 1.0";
    end

    if(par.center == 1)
        center_command = "fix 3 mobile recenter INIT INIT INIT";
    else
        center_command = "";
    end

    if(par.dislocation == 1)
        minimize_command = "minimize 5 1000 1000 100000";
    else
        minimize_command = "";
    end




    intemplate = [
    "# ---------- Initialize simulation ---------------------";
    "units lj"
    "atom_style atomic"
    "dimension  3"
    "boundary   p p p"
    "read_data "+input_dir+"/"+filename
    "mass * 1.0"
    "group immobile type 2"
    "group mobile type 1"
    ""
    "pair_style table linear "+num2str(par.force_resolution)
    "pair_coeff * * potential.table power_law "+num2str(par.rcut)
    ""
    "velocity mobile create "+num2str(par.temp)+" 87287 dist gaussian"
    "velocity immobile set 0.0 0.0 0.0"
    "compute displ all displace/atom"

%    minimize_command

    "fix 1 all nve"
     langevin_command
     center_command
     "fix 4 immobile setforce 0.0 0.0 0.0"

    "#--------- Dump file ------------------"
    "thermo_style custom step pe ke temp press"
    "thermo "+num2str(par.dumpstep)
    "dump 1 all custom "+num2str(par.dumpstep)+" dump.*"+" id type x y z    "
    
    ""
    "# --------- Run -------------"
    "timestep "+num2str(par.timestep)
    "run "+num2str(par.nstep)
    ];

end
   
function lammps_run(output_dir, intemplate, current_dir)   
    
    filename = output_dir+"/lammps.in";
    text_file = fopen(filename, 'w');
    for j = 1:length(intemplate)
    fprintf(text_file,'%s\n',intemplate(j));
    end
    fclose(text_file);
    
    cd(output_dir)
    system("lmp.exe -pk omp 4 -sf omp -in lammps.in"); %Execute Lammps. For windows.
    %system("mpirun  -n 4 lmp_mpi -in lammps.in") % For mac.
    cd(current_dir)
end
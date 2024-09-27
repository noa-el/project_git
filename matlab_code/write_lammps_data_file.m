function write_lammps_data_file(par, filename)

% d: nearest neighbor distance.
% N: number of unit cell along x, y, z-axis. (Total: ~4*N^(3) number of
% particles)

if(par.fcc)
    [r,type,sim_box]=make_fcc_for_lammps(par.d,par.N);
else
    number_of_atoms = par.RANDOM_number_of_atoms;
    box_lim = par.RANDOM_box_lim;
    [r,type,sim_box] = make_random_atoms_for_lammps(number_of_atoms, box_lim);
end


yy=year(datetime);mm=month(datetime);dd=day(datetime);
N=length(r(:,1));
Ntype=length(unique(type));

script = [
    "# Data file made by S.Kim"+" DATE: "+num2str(yy)+"-"+num2str(mm)+"-"+num2str(dd);
    num2str(N)+" atoms";
    num2str(Ntype)+" atom types";
    num2str(sim_box(1,1))+" "+num2str(sim_box(1,2))+" xlo xhi";
    num2str(sim_box(2,1))+" "+num2str(sim_box(2,2))+" ylo yhi";
    num2str(sim_box(3,1))+" "+num2str(sim_box(3,2))+" zlo zhi";
    ""
    "Atoms  # atomic"
    ""
    ];

text_file = fopen(filename, 'w');
for j=1:length(script)
    fprintf(text_file,'%s\n',script(j));
end

NN=1:N;
fprintf(text_file,'%d %d %8.8f %8.8f %8.8f\n',[NN', type, r]');
fclose(text_file);


end
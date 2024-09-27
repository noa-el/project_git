function write_pair_style_table(filename,par)
%This code writes potential energy and force as a function of distance into
%a text file.
%OUTPUT: a matrix where each colum is : 
%        index, distance, potential energy, force

N=par.force_resolution;
rstart=par.rstart;
rcut=par.rcut;
epsilon=par.epsilon;
[r,V,f]=smoothed_power_law_potential(epsilon,rstart,rcut,N,par.s);


%%%Writing Starts%%%

yy=year(datetime);mm=month(datetime);dd=day(datetime);
intemplate1 = [
    "# DATE: "+num2str(yy)+"-"+num2str(mm)+"-"+num2str(dd)+"  UNITS: lj";
    "# Smoothed_power_law_potential";
    ""
    "power_law";
    "N "+num2str(N);
    ""
    ];


text_file = fopen(filename, 'w');
for j=1:length(intemplate1)
    fprintf(text_file,'%s\n',intemplate1(j));
end
NN=1:N;
fprintf(text_file,'%d %8.8f %8.8f %8.8f \n',[NN; r; V; f]);
fclose(text_file);


end

function [r,V,f]=smoothed_power_law_potential(epsilon,rstart,rcut,N,s)

syms x
r_min=s*2^(1/6);
d=-r_min+rcut;

U=4*epsilon*((s./(x-d)).^12-(s./(x-d)).^6)+epsilon;

U(x) = 4 * epsilon *((s/(x-d))^(12)-((s/(x-d))^(6))) + epsilon;
% U(x)=epsilon*(x/rcut-1)^(2)*(rcut/x)^(24);
F=-diff(U);

r=linspace(rstart,rcut,N);

V=double(U(r));
figure(3)
plot(r,V);
f=double(F(r));

end
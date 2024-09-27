function xyz_make(r,type,box,save_path,fileName) 
%save_path should be the full path [pwd '\' exper{j}]

%path=[pwd '\' exper '_loc.xyz'];
if (nargin<4)
save_path='C:/Analysis/Harvard';
end
if ~(exist('fileName'))
    fileName='loc.xyz';
end

yy=year(datetime);mm=month(datetime);dd=day(datetime);
N=length(r(:,1));
NN=(1:N)';

Ntype=length(unique(type));

script = [
    "# Data file DATE: "+num2str(yy)+"-"+num2str(mm)+"-"+num2str(dd);
    num2str(N)+" atoms";
    num2str(Ntype)+" atom types";
    num2str(box(1,1))+" "+num2str(box(1,2))+" xlo xhi";
    num2str(box(2,1))+" "+num2str(box(2,2))+" ylo yhi";
    num2str(box(3,1))+" "+num2str(box(3,2))+" zlo zhi";
    ""
    "Atoms  # atomic"
    ""
    ];

fid=fopen([save_path '/' fileName],'w');
for j=1:length(script)
    fprintf(fid,'%s\n',script(j));
end

fprintf(fid,'%d %d %8.8f %8.8f %8.8f\r\n',[NN, type, r]');
fclose(fid);

%fprintf(fid,'%d\r\n',length(r(:,1)));
%fprintf(fid,'Lattice="%f %f %f %f %f %f %f %f %f" Origin="%f %f
%%f"\r\n',length(r(:,1))); %need to define cell
%fprintf(fid,'\r\n');
%fprintf(fid,'%f %f %f\r\n',r(:,1:3)');
%fprintf(fid,'%d %f %f %f \r\n',r(:,[4 1:3])');
%fclose(fid);
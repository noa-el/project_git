function xyz_make(r,save_path,fileName) 
%save_path should be the full path [pwd '\' exper{j}]

%path=[pwd '\' exper '_loc.xyz'];
if (nargin<2)
save_path='C:/Analysis/Harvard';
end
if ~(exist('fileName'))
    fileName='loc.xyz';
end

fid=fopen([save_path '/' fileName],'w');

fprintf(fid,'%d\r\n',length(r(:,1)));
%fprintf(fid,'Lattice="%f %f %f %f %f %f %f %f %f" Origin="%f %f
%%f"\r\n',length(r(:,1))); %need to define cell
fprintf(fid,'\r\n');
fprintf(fid,'%f %f %f\r\n',r(:,1:3)');
%fprintf(fid,'%d %f %f %f \r\n',r(:,[4 1:3])');

fclose(fid);
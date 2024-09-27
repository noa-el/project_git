function makeMixedStraightDislocation(save_path)
% 'C:\Users\noae1\lammps';

%--Define crystal parameters (All lengths are in \mum)
scale=1;%1 - mum, 1e-6 -m
p.d=2^0.5*1*scale;
p.LCrys=[40 40 40]*scale;
p.theta=45/180*pi; %Crystal oriantation
p.nu=1/3;
[r0,v]=make_fcc_lattice4(p.LCrys,p.d,p.theta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--Define Lomer dislocation 1/2*[1,-1,0]
% j=1;
% d(j).b=1/2*[1,-1,0]; 
% d(j).rref=[0,0,p.LCrys(3)/2];
% d(j).z=[1,1,0];
% % %screw part
% %% d(j).s=[2,-1,-1];
% d(j).s=0; %Should double check that bXs=n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--Define perfect dislocation 1/2*[-1,0,1] on (-11-1) plane!!!Doesn't work
j=1;
d(j).b=1/2*[-1,0,1]; 
d(j).rref=[0,0,p.LCrys(3)/2];
d(j).z=[1,1,0];
% %screw part
d(j).s=[-1,1,2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=r0;

for j=1:length(d)

    %------shift rref to middle of the crystalline cell
    %rref=disLineCenter(d(j).rref,r,v);
    rref=d(j).rref;
    %--rotate to the lab frame and assign units
    b=(v'*d(j).b')';
    z=(v'*d(j).z')';
    z=z/norm(z);
    s=(v'*d(j).s')';
    s=s/norm(s);

    %=======Straight dislocation
    bs=(b*z')*z;
    be=b-bs;

    if norm(be)>0
        [~,ue]=make_edge_dislocation_3(r0,p.nu,be,z,rref);
    else
        ue=0;
    end
    if norm(bs)>0
        [~,us]=make_screw_dislocation(r0,bs,s,rref);
    else
        us=0;
    end
    r=r+ue+us;

end
xyz_make(r,save_path)


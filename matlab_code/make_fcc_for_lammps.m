function [r,type,sim_box]=make_fcc_for_lammps(d,N)

% d: nearest neighbor distance.
% N: number of unit cell along x, y, z-axis. (Total: ~2*N^(3) number of
% particles)

r0=[0 0 0;
    d/sqrt(2) 0 d/sqrt(2);
    0 d/sqrt(2) d/sqrt(2)
    d/sqrt(2) d/sqrt(2) 0];

r=[];

for i=0:1:N-1
    for j=0:1:N-1
        for k=0:1:N-1
            r_new=r0+[d*sqrt(2) 0 0]*i+[0 d*sqrt(2) 0]*j+[0 0 d*sqrt(2)]*k;
            r=[r; r_new];
        end
    end
end

type=ones(length(r(:,1)),1);

sim_box=[0 sqrt(2)*d*N;
    0 sqrt(2)*d*N;
    0 sqrt(2)*d*N];

end
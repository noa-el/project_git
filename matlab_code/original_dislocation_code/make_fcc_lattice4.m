function [r,v]=make_fcc_lattice4(L,d,theta)
%Similar to V.3 but now the lab frame is square. Probably there is a
%smarter way to do that.
%--Crystal dimensions will be -L(1)/2<x<L(1)/2, -L(2)/2<y<L(2)/2, 0<z<L(3)
%Bravais lattice + basis

p=0;
v=[d 0 0; 0 d 0; 0 0 d];% each row is a Bravais vector 
b=[d/2 d/2 0 ; 0 d/2 d/2 ; d/2 0 d/2]; % each row is a basis vector 

%-----rotate the crystal with respect to the lab frame
R=@(theta) [cos(theta), sin(theta); -sin(theta), cos(theta)];

for j=1:3
v(j,1:2)=(R(-theta)*v(j,1:2)')';
end

for j=1:3
b(j,1:2)=(R(-theta)*b(j,1:2)')';
end

%----make crystal
n_x=ceil(norm(L(1:2))/2/d);
n_y=ceil(norm(L(1:2))/2/d);
n_z=ceil(L(3)/2/d);

r=zeros(4*(2*n_x+1)*(2*n_y+1)*(2*n_z+1),3);

for k=0:2*n_z
    for i=-n_x:n_x
        for j=-n_y:n_y
    
            p=p+1;
            r(p,:)=i*v(1,:)+j*v(2,:)+k*v(3,:);
            r0=r(p,:);
            
            for l=1:3
                p=p+1;
                r(p,:)=r0+b(l,:);
            end
            
        end
    end
end

%--Cut the crystal to lab frame dimensions
index=find(r(:,1)>L(1)/2 | r(:,1)<-L(1)/2 | r(:,2)>L(2)/2 | r(:,2)<-L(2)/2 | r(:,3)>L(3));
r(index,:)=[];

%figure();
% scatter3(r(:,1),r(:,2),r(:,3),10,'filled');
% daspect([1 1 1]);
% view(0,90);
% axis equal;
% axis tight;

        
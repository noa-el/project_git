function [rb,ub]=make_screw_dislocation(r,b,s,rref)
% rb, ub - distorted fcc particles positions resulting from a screw dislocation
%b-burgers vector
%s perp. to b define the slip plane
%rref - ref point for the dis. line

%--n and b should be opposite sign!
%nb=1*[1,1,1];%normal to the slip plane of dislocation, 
%b=-1/6*[-1,-1,2];% Burgers vector
%b=-1/6*[2,-1,-1];% Burgers vector
%b=-1/6*[-1,2,-1];% Burgers vector
%b=-1/2*[-1,0,1];
%rref=[-100,100,0]; %(integer numbers) position of the dislocation line

%-----
N=length(r(:,1));

s=s/norm(s);
b_hat=b/norm(b);%direction of the burger vector
n_hat=cross(b_hat,s);

%--define x,y coordinates with respect to dislocation line
r_rref=r-repmat(rref,N,1);
y=sum(r_rref.*repmat(n_hat,N,1),2);
x=sum(r_rref.*repmat(s,N,1),2);
%x=sum(r_rref.*repmat(b_hat,N,1),2);

%---
theta=atan2(y,x);
x([1,10])';
ub=repmat(b,N,1)/(2*pi).*repmat(theta,1,3);
rb=r+ub;


%----plot
% figure();
% scatter3(rb(:,1),rb(:,2),rb(:,3),8,theta,'filed');
% hold all; 
% scatter3(rref(1),rref(2),rref(3),12,'filed','MarkerFaceColor','k');
% daspect([1 1 1]);
% view(b);
% axis equal;
% axis tight;
% colorbar




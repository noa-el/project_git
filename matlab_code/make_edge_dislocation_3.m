function [rb,ub]=make_edge_dislocation_3(r,nu,b,z,rref)
%Most recent version

%--Input
%r - particle locations [\mumn]
%b - burger's vector [\mum]
%v - Each row of v is lattice vector
%z - direction of the dislocation line
%rref - reference point (x,y,z) [\mum]
%--r,b,z,rref should be in the same coordinate system
%---Output
% rb - distorted fcc particles positions resulting from an edge dislocation

N=length(r(:,1));

%----
b_hat=b/norm(b);%direction of the burger vector
z_hat=z/norm(z);%direction of the dislocation line
n_hat=cross(z_hat,b_hat);%direction of the fault

%--define x,y coordinates with respect to dislocation line
r_rref=r-repmat(rref,N,1);

y=sum(r_rref.*repmat(n_hat,N,1),2);
x=sum(r_rref.*repmat(b_hat,N,1),2);

rho=sqrt(x.^2+y.^2);
theta=atan2(y,x);
x([1,10])';

 if (theta<0)
    theta=theta+2*pi; 
 end

% %---First form, Calc dislpacemnent in polar coordinates E. 3.49 Anderson,Hirth & Lothe
u_rho=norm(b)/(2*pi)*( -(1-2*nu)/(2*(1-nu))*sin(theta).*log(rho)+sin(theta)/(4*(1-nu))+theta.*cos(theta) );
u_theta=norm(b)/(2*pi)*( -(1-2*nu)/(2*(1-nu))*cos(theta).*log(rho)-cos(theta)/(4*(1-nu))-theta.*sin(theta) );

%-----Second equivalent form that can be compared to curved dis form
% u_rho_1=theta.*cos(theta);
% u_rho_2=-sin(theta).*log(rho);
% u_rho_3=1/(1-nu)*sin(theta)/2.*(log(rho)+1/2);
% 
% u_theta_1=-theta.*sin(theta);
% u_theta_2=-cos(theta).*log(rho);
% u_theta_3=1/(1-nu)*cos(theta)/2.*(log(rho)-1/2);
% 
% u_rho=norm(b)/(2*pi)*(u_rho_1+u_rho_2+u_rho_3);
% u_theta=norm(b)/(2*pi)*(u_theta_1+u_theta_2+u_theta_3);

%-----------
rho_hat=(x.*b_hat+y.*n_hat)./rho;
theta_hat=(-y.*b_hat+x.*n_hat)./rho;
ub=u_rho.*rho_hat+u_theta.*theta_hat;

%------------
rb=r+ub;
%--- check and clean NaN particles
nanIndex=find(isnan(rb));

if ~isempty( nanIndex)
    display('Warning : particle positions with NaN values were deleted');
    [row,~]=ind2sub(size(rb),nanIndex);
    row=unique(row);
    rb(row,:)=[];

end

%make z faces flat
% index=rb(:,3)>L(3)/2;
% rb(index,:)=[];
% index=rb(:,3)<-L(3)/2;
% rb(index,:)=[];

% %----plot
%    figure();
%scatter3(rb(:,1),rb(:,2),rb(:,3),8,theta,'filed');
% scatter3(r(:,1),r(:,2),r(:,3),8,theta,'filed');
% % % % hold all; 
% % %  %scatter3(rref(1),rref(2),rref(3),12,'filed','MarkerFaceColor','k');
% % %  daspect([1 1 1]);
%   view([z_hat]);
%    axis equal;
%    axis tight;
% %  colorbar;
% %  v=theta_hat;
% % quiver3(rb(:,1),rb(:,2),rb(:,3),v(:,1),v(:,2),v(:,3));
%   v=ub*5;
%  quiver3(rb(:,1),rb(:,2),rb(:,3),v(:,1),v(:,2),v(:,3));


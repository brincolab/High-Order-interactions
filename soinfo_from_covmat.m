function [oinfo,sinfo] = soinfo_from_covmat(covmat,T)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% author = Rubén Herzog, sirius.high@gmail.com, modify by Marilyn Gatica, marilyn.gatica@usach.cl
% Computes the O-Information and S-Information of gaussian data given their covariance
% matrix 'covmat'.
%
% INPUTS
% covmat = N x N covariance matrix 
% T = length data
%
% OUTPUT
% oinfo (O-Information) 
% sinfo (S-Information) of the system with covariance matrix covmat.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ent_fun = @(x,y) 0.5.*log(((2*pi*exp(1)).^(x)).*y);%function to compute the entropy of multivariate gaussian distribution, where x is dimensionsionality
% and y is the variables variance of the covariance matrix determinant.
N = length(covmat);
emp_det = det(covmat); % determinant
single_vars = diag(covmat); % variance of single variables
%% bias corrector for N,(N-1) and one gaussian variables
biascorrN = gaussian_ent_biascorr(N,T);
biascorrNmin1 = gaussian_ent_biascorr(N-1,T);
biascorr_1 = gaussian_ent_biascorr(1,T);
%% Computing estimated measures for multi-variate gaussian variables
tc = sum(ent_fun(1,single_vars)-biascorr_1) - (ent_fun(N,emp_det)-biascorrN);%tc=Total Correlation
Hred = 0;
reduce_x = @(x,covmat) covmat((1:N)~=x,(1:N)~=x);
for red=1:N
    Hred = Hred + ent_fun((N-1),det(reduce_x(red,covmat)))-biascorrNmin1;
end
dtc = Hred - (N-1)*(ent_fun(N,emp_det)-biascorrN);%dtc=Dual Total Correlation
oinfo = tc - dtc;
sinfo = tc + dtc;
return 

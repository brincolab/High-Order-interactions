function [gaussian_data,covmat] = data2gaussian(data)
% Transforms 'data' (T samples x N dimensionmatrix) to Gaussian with 0 mean and 1 sd
% using empirical copulas
% 
% INPUT
% data = T samples x N variables matrix
%
% OUTPUT
% gaussian_data = T samples x N variables matrix with the gaussian copula
% transformed data
% covmat = N x N covariance matrix of gaussian copula transformed data.
% Author: Rubén Herzog.

[T,~] = size(data);
[~,sortid] = sort(data,1); % sort data and keep sorting indexes
[~,copdata] = sort(sortid,1); % sorting sorting indexes
copdata = copdata./(T+1); % normalization to have data in [0,1]
gaussian_data= norminv(copdata);% uniform data to gaussian data
gaussian_data(isinf(gaussian_data)) = 0; % removing inf
covmat = (gaussian_data'*gaussian_data) / (T - 1); % covariance matrix
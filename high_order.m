%{ 
Code description: Function to compute S-Information, O-Information, and characterize the High-order interactions among n variables governed by Redundancy or Synergy.

Input: - 'data': Matrix with dimensionality (N,T), where N is the number of brain regions or modules, and T is the number of samples.
       - 'n': number of interactions or n-plets. n must be greater or equal, and if n=3, then the interactions is among triplets. 

Output: - 'Red': Matrix with dimension (Npatients,Modules), with the redundancy values per patient and per module
        - 'Syn': Matrix with dimension (Npatients,Modules), with the synergy values per patient and per module
        - 'Oinfo': O-Information for all the n-plets.
        - 'Sinfo': S-Information for all the n-plets

@author: Marilyn Gatica, marilyn.gatica@postgrado.uv.cl
Acknowledgment: data2gaussian(), soinfo_from_covmat() created by Ruben
Herzog, ruben.herzog@postgrado.uv.cl; modify by Marilyn Gatica.
%}
function [Oinfo,Sinfo,Red,Syn]=high_order(data,n)
Modules=size(data,1);
Red=zeros(1,Modules);%matrix to save the redundant values, per patient and per module
Syn=zeros(1,Modules);
nplets=combnk(1:Modules,n);%n-tuples without repetition over 20 modules
Oinfo=zeros(size(nplets,1),1);%vector Oinfo to save the O-Information value for each n-tuple
Sinfo=zeros(size(nplets,1),1);%vector Sinfo to save the S-Information value for each n-tuple
i=1;
dataNorm=bsxfun(@minus,data,mean(data,2));%normalize the time series (per module: BOLD signal- mean(BOLD signal))
[~,est_covmat] = data2gaussian(dataNorm');% Transformation to Copulas and Covariance Matrix Estimation
for npletIndex=nplets'%moving in each interaction of n-tuples: npletIndex
    sub_covmat=est_covmat(npletIndex,npletIndex);%create a sub covariance matrix with only the particular values npletIndex
    [est_oinfo,est_sinfo] = soinfo_from_covmat(sub_covmat,size(dataNorm,2));% Estimating O-Information and S-Info with bias corrector
    Oinfo(i)=est_oinfo;%O-Information for the n-plet with index 'i'
    Sinfo(i)=est_sinfo;%S-Information for the n-plet with index 'i'
    i=i+1;
end
for module=1:Modules
    [modRow,~,~]=find(nplets==module);%find the interactions where the module 'module' belong
    Oinfo_module=Oinfo(modRow);%compute the Oinfo per module
    Red(1,module)=mean(Oinfo_module(Oinfo_module>0));%if Oinfo is positive, the interaction is governed by redundancy
    Syn(1,module)=mean(abs(Oinfo_module(Oinfo_module<0)));%if Oinfo is negative, the interaction is governed by synergy     
end    
Syn(isnan(Syn))=0;%if not exist negative Oinfo, the Synergy return nan.
end

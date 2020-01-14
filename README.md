# High-Order: Quantify high-order interactions among n brain areas.
Function to compute

| Platform | Version tested              |
| :------: | :----------------------:    |
| Matlab   | R2017b                      |

### Scripts
*  `[sinfo,oinfo,red,syn]=high_order(data,n)` Main function. Estimate the O-Information, S-Information, Redundancy and Synergy among n-plets from 'data' with dimensionality (T,N), where N is the number of brain regions or modules, etc. and T is the number of samples.

n must be greater or equal than three and we test up 20.
We recommend truncate all the data to the same number of samples T.
 

*  `[gaussian_data,covmat]=data2gaussian(data)` 
 Transforms 'data' (T samples x N dimension matrix) to Gaussian with mean 0 and standard desviation 1 using empirical copulas. Return the covariance matrix 'covmat' and the trasformed gaussian variables 'gaussian_data'
@author: Rubén Herzog, rubenherzog@postgrado.uv.cl

*  `[oinfo,sinfo] = soinfo_from_covmat(covmat,T)` 
Estimate O-Information and S-Information from covariance matrix 'covmat'. The estimations include analytic bias correction for the entropy of Gaussian variables depending on 'T' (samples) and 'N' (dimension of 'covmat' matrix).

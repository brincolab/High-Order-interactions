# High-Order interactions
Function to compute and characterize high-order interactions among n brain areas.

| Platform | Version tested              |
| :------: | :----------------------:    |
| Matlab   | R2017b                      |

### Scripts
*  `[sinfo,oinfo,red,syn]=high_order(data,n)` Main function. Estimate the O-Information, S-Information, Redundancy, and Synergy among n-plets from 'data' with dimensionality (T, N), where N is the number of brain regions or modules, and T is the number of samples. @author: Marilyn Gatica, marilyn.gatica@postgrado.uv.cl

*n must be greater or equal than three. We test from 3-plets up 20-plets, and we recommend truncating all the data to the same number of samples T.*
 
*  `[gaussian_data,covmat]=data2gaussian(data)` 
Transform' data' (T samples x N dimension matrix) to Gaussian with mean 0 and standard deviation 1 using empirical copulas. Return the covariance matrix 'covmat' and the transformed gaussian variables 'gaussian_data'
@author: Rubén Herzog, rubenherzog@postgrado.uv.cl

*  `[oinfo,sinfo] = soinfo_from_covmat(covmat,T)` 
Estimate O-Information and S-Information from the covariance matrix 'covmat'. The estimations include analytic bias correction (`gaussian_ent_biascorr(N,T)`) for the entropy of Gaussian variables depending on 'T' (samples) and 'N' (dimension of 'covmat' matrix).
@author: Rubén Herzog and modified by Marilyn Gatica.

### Example
We attach an example `example1` (without data) to show how to use higher order() among three tiem series. In particular, the example considers 8 subjects and 20 modules.

Questions / comments : marilyn.gatica@postgrado.uv.cl

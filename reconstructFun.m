function funVF = reconstructFun(s, model)
%% reconstructFun compute VF approximation
% This function computes function values for frequency points using a specified
% Vector Fitting model.
%
%  INPUTS
%   s: set of jw frequencies, double [1 x nS]
%   model: Vector Fitting model, struct
%        .poles: poles of the model, double [1 x nPoles] 
%        .residues: residues of the model, double [1 x nPoles]
%        .d: VF coefficient, double [1 x 1]
%        .e: VF coefficient, double [1 x 1]
%
%  OUTPUTS
%   funVF: VF approsimation samples, double [1 x nS]
%
%  SYNTAX
%
%  funVF = reconstructFun(s, model)
%
% Function reconstructFun determines samples at complex frequencies jw specified
% by _s_ from VF strcut _model_. The approsimation is defined as follows:
% $f(s) = \sum_{n=1}^{N}\frac{r_n}{s-p_n} + d + se$
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

funVF = zeros(size(s));
for iP = 1:size(model.poles, 1)
   funVF = funVF + model.residues(iP)./(s - model.poles(iP));
end
funVF = funVF + model.d + s.*model.e;
end
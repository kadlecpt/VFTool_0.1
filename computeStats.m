function stats = computeStats(curve, refCurve)
%% computeStats computes statistical parameters of two curves comparison
% This function searches specified curve for peaks in their position.
%
%  INPUTS
%   curve: approx. curve, double [1 x nS]
%   refCurve: reference curve samples, double [1 x nS]
% 
%  OUTPUTS
%   stats: values of curve comparison, struct
%        .rmse: root mean square error, double [1 x 1]
%        .mae: mean absolue error, double [1 x 1]
%        .maxAbs: maximum of absolute error, double [1 x 1]
%
%  SYNTAX
%
%  stats = computeStats(curveRef, curve)
%
% Function computeStats compares found _curve_ samples with samples of 
% a reference curve _refCurve_. The resultin statistical parameters are stored
% in form of struct _stats_.
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

nSamples = size(curve, 2);
difC = curve - refCurve;
difAbs = abs(difC);

stats.rmse = sqrt(1/nSamples*sum(difAbs.^2));
stats.mae = 1/nSamples*sum(difAbs);
stats.maxAbs = max(difAbs);


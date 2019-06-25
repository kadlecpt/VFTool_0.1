function [model, funVF, rmse] = automaticVectorFitting(s, fun, settings)
%% automaticVectorFitting searches for the VF model automatically
% This function searches for the VF model based on complex frequency, 
% complex function samples and specified settings.
%
%  INPUTS
%   s: complex frequency, double [1 x nS]
%   fun: function samples, double [1 x nS]
%   settings: struct [1 x 1]
%      .rmse: wanted rmse value, double [1 x 1]
%      .maxTrials: max VF runs, double [1 x 1]
%      .isPeaks: are peaks in the function, logical [1 x 1]
%      .poleDistribution: ioit pole distribution ('lin'/'log'), char [1 x 3]
%      .nIters: number of iterations per VF run, double [1 x 1]
%      .choiceType: take 'first' with good rmse  or 'best' from all, d. [1 x 1]
% 
%  OUTPUTS
%   model: VF model, struct
%        .poles: complex poles, double [nP x 1]
%        .residues: complex rsidues, double [nP x 1]
%        .d: VF coeff., double [1 x 1]
%        .d: VF coeff., double [1 x 1]
%   funVF: VF function approsimation, double [1 x nS]
%   rmse: root mean square error value, double [1 x 1]
%
%  SYNTAX
%
%  [model, funVF, rmse] = automaticVectorFitting(s, fun, settings)
%
% Function automaticVectorFitting searches for the VF model in automatic regime. 
% It saves either the 'first' model satisfying the rmse criterion, or the model 
% with the OK rmse value and minimal nuber of poles ('best').
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

nSamples = size(s, 2);

if nargin == 2
   settings.rmse = 1e-13;
   settings.maxTrials = 20;
   settings.isPeaks = true;
   settings.poleDistribution = 'linear';
   settings.nIters = 1;
   settings.choiceType = 'best';
else
   if ~isfield(settings, 'rmse')
      settings.rmse = 1e-3;
   end
   if ~isfield(settings, 'maxTrials')
      settings.maxTrials = 20;
   end
   if ~isfield(settings, 'isPeaks')
      settings.isPeaks = true;
   end
   if ~isfield(settings, 'poleDistribution')
      settings.poleDistribution = 'linear';
   end
   if ~isfield(settings, 'nIters')
      settings.nIters = 1;
   end
   if ~isfield(settings, 'choiceType')
      settings.choiceType = 'best';
   end
end
[peaks, ~] = findPeaks(abs(fun));
nPeaks = 2*floor(numel(peaks)/2);
if nPeaks < 2 
   initPoles = 2;
elseif nPeaks > 20
   initPoles = 30;
else
   initPoles = 2*nPeaks;
end

cikCak2 = 0:2:2*settings.maxTrials;
cikCak2(3:2:end) = -cikCak2(3:2:end);
cikCak2 = initPoles + cikCak2;
allModels = struct('poles', [], 'residues', [], 'd', [], 'e', []);
allFunVF = zeros(settings.maxTrials, nSamples);
allRmse = inf(1, settings.maxTrials);

if strcmp(settings.choiceType, 'best')
   %% take the best from all satisfying the rmse criteria
   for iIter = 1:settings.maxTrials
      curN = cikCak2(iIter);
      try
         allModels(iIter) = vectorFitting(s, fun, curN, ...
            settings.nIters, settings.isPeaks, settings.poleDistribution);
         if ~isempty(allModels(iIter).poles)
            allFunVF(iIter, :) = reconstructFun(s, allModels(iIter));
            stat = computeStats(fun, allFunVF(iIter, :));
            allRmse(iIter) = stat.rmse;
         end
      catch
      end
   end
   isBetter = allRmse < settings.rmse;
   if any(isBetter)
      cikCak2 = cikCak2(isBetter);
      allModels = allModels(isBetter);
      allRmse = allRmse(isBetter);
      allFunVF = allFunVF(isBetter, :);
      % take the one is minimum # of poles
      [~, ind] = min(cikCak2);
      allModels = allModels(ind);
      allRmse = allRmse(ind);
      allFunVF = allFunVF(ind, :);
   end
elseif strcmp(settings.choiceType, 'first')
   %% take first satisfying the rmse critria
   curRmse = 1;
   iIter = 1;
   while curRmse > settings.rmse && iIter <= settings.maxTrials
      curN = cikCak2(iIter);
      try
         allModels(iIter) = vectorFitting(s, fun, curN, ...
            settings.nIters, settings.isPeaks, settings.poleDistribution);
         if ~isempty(allModels(iIter).poles)
            allFunVF(iIter, :) = reconstructFun(s, allModels(iIter));
            stat = computeStats(fun, allFunVF(iIter, :));
            curRmse = stat.rmse;
            allRmse(iIter) = curRmse;
         end
      catch
      end
      
      iIter = iIter + 1;
   end
end

[rmseMin, ind] = min(allRmse);
%% try to make the best result better by adding 
if rmseMin > settings.rmse
   try 
      bestModel = vectorFitting(s, fun, cikCak2(ind), ...
         settings.nIters + 1, settings.isPeaks, settings.poleDistribution);
      if ~isempty(bestModel.poles)
         bestFunVF = reconstructFun(s, bestModel);
         stat = computeStats(fun, bestFunVF);
         bestRmse = stat.rmse;
         if bestRmse < rmseMin
            allModels(ind) = bestModel;
            allFunVF(ind, :) = bestFunVF;
            allRmse(ind) = bestRmse;
         end
      end
   catch
      
   end
end

model = allModels(ind);
funVF = allFunVF(ind, :);
rmse = allRmse(ind);
end
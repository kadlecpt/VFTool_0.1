function [peaks, ind] = findPeaks(curve, type)
%% findPeaks search for peaks in a curve
% This function searches specified curve for peaks in their position.
%
%  INPUTS
%   curve: curve samples, double [1 x nS]
%   curve: specify type of peaks - 'min'/'max'/'all', char [1 x n]
% 
%  OUTPUTS
%   peaks: values at found peaks, double [1 x nPeaks]
%   ind: indices of found peaks, double [1 x nPeaks]
%
%  SYNTAX
%
%  [peaks, ind] = findPeaks(curve, 'all')
%
% Function findPeaks determines peaks in a specified _curve_. The type of  
% peaks to be searched can be specified in _type_: 'min' searches for local
% minimum peaks, 'max' for local maxima, and 'all' for both min and max peaks.
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz
if nargin == 1
   type = 'all';
end

peaksMax = [];
peaksMin = [];
indMax = [];
indMin = [];
if strcmp(type, 'all')
   [peaksMax, indMax] = findPeaksType(curve, 'max');
   [peaksMin, indMin] = findPeaksType(curve, 'min');
elseif strcmp(type, 'max')
   [peaksMax, indMax] = findPeaksType(curve, 'max');
elseif strcmp(type, 'min')
   [peaksMax, indMax] = findPeaksType(curve, 'min');
end
peaks = [peaksMax, peaksMin];
ind = [indMax, indMin];
end

function [peaks, ind] = findPeaksType(curve, type)
   temp1 = 2:numel(curve) - 1;
   innerCurve = curve(2:end-1);
   if strcmp(type, 'max')
      isPeak = innerCurve > curve(1:end-2) & innerCurve > curve(3:end);
   else
      isPeak = innerCurve < curve(1:end-2) & innerCurve < curve(3:end);
   end
   peaks = innerCurve(isPeak);
   ind = temp1(isPeak);
end
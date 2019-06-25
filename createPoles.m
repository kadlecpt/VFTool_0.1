function [realPoles, complexPoles] = createPoles(s, order, isPeaks, ...
   poleDistribution)
%% createPoles search for initial poles for the VF model
% This function searches specified curve for peaks in their position.
%
%  INPUTS
%   s: complex frequency samples, double [1 x nS]
%   order: number of poles !HAS TO BE EVEN!, double [1 x 1]
%   isPeaks: are sharp peaks in the function?, logical [1 x 1]
%   poleDistribution, type of distribution: 'linear'/'logarithmic', char [1 x 3]
% 
%  OUTPUTS
%   realPoles: real poles positions, double [1 x nReal]
%   complexPoles: complex-conjugate pairs of poles, double [1 x nComplex]
%
%  SYNTAX
%
%  [realPoles, complexPoles] = createPoles(s, order, isPeaks, poleDistribution)
%
% Function createPoles determines starting position of the Vector Fitting model.
% The distribution can be either linear (_poleDistribution_ = 'linear') or 
% logarithmic ('logarithmic'). The poles are real when the curve contains sharp
% peaks (_isPeaks_ = true0.
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

freqLim = sort(imag(s));
realPoles = [];
complexPoles = [];
if strcmp(poleDistribution, 'linear')
   %% linear
   freqLim = freqLim([1, end]);
   if isPeaks
         complexPoles = linspace(freqLim(1), freqLim(2), order/2);
         complexPoles = reshape([-complexPoles/100 - 1j*complexPoles; ...
            -complexPoles/100 + 1j*complexPoles], 1, []);

   else
      % no peaks - use real poles
      realPoles = linspace(freqLim(1), freqLim(2), order);
   end
else
   %% logarithmic
   freqLim = floor(log(abs(freqLim([1, end])./(2*pi)))./log(10));
   
   if isPeaks
      % even number of poles - all complex
      complexPoles = -2*pi*logspace(freqLim(1), freqLim(2), order/2);
      complexPoles = reshape([complexPoles/100 - 1j*complexPoles; ...
         complexPoles/100 + 1j*complexPoles], 1, []);
   else
      % no peaks - use real poles
      realPoles = -2*pi*logspace(freqLim(1), freqLim(2), order);
   end
end
end
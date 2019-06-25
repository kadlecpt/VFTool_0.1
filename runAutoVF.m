function runAutoVF(hObject, eventData)
%% runAutoVF pushbutton callback to run automatic VF
% This function collects necessary data and calls the function for automatic VF.
%
%  INPUTS
%   hObject: pushbutton [1 x 1]
%   eventData: struct, not used
%
%  SYNTAX
%   runAutoVF(hObject)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

fig = hObject.Parent.Parent.Parent;
h = getappdata(fig, 'handles');

%% load settings
settings.maxTrials = str2num(h.autoEditMaxT.String); %#ok<*ST2NM>
settings.nIters = str2num(h.autoEditNIters.String);
settings.rmse = str2num(h.autoEditRmse.String);

validateattributes(settings.maxTrials, {'double'},{'>', 1})
validateattributes(settings.nIters, {'double'},{'>=', 1})
validateattributes(settings.rmse, {'double'},{'>', 0})

settings.choiceType = h.autoPopupResChoice.String{h.autoPopupResChoice.Value};
settings.poleDistribution = h.autoPopupDistr.String{h.autoPopupDistr.Value};
settings.isPeaks = strcmp('complex', ...
   h.autoPopupPoleType.String{h.autoPopupPoleType.Value});

% take data of the reference function
data = getappdata(fig, 'values');
if ~isempty (data)
   if ~isempty(data.funRef)
      s = 1j*2*pi*data.frequency;
      [model, funVF, rmse] = automaticVectorFitting(s, data.funRef, settings);
      data.funVF = funVF;
      data.model = model;
      data.rmse = rmse;
      setappdata(fig, 'values', data)
      
      updatePlot(fig)
   end
end
end
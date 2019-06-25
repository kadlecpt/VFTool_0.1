function runUserVF(hObject, eventData)
%% runUserVF pushbutton callback to run user-defined VF
% This function collects necessary data and calls the function for user-defined
% VF.
%
%  INPUTS
%   hObject: pushbutton [1 x 1]
%   eventData: struct, not used
%
%  SYNTAX
%   runUserVF(hObject)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

fig = hObject.Parent.Parent.Parent;

h = getappdata(fig, 'handles');

%% load and check settings from edits
nIters = str2num(h.userEditNIters.String); %#ok<*ST2NM>
nPoles = str2num(h.userEditNPoles.String);

validateattributes(nIters, {'double'},{'>=', 1})
validateattributes(nPoles, {'double'},{'>', 1, 'even'})

poleDistribution = h.userPopupDistr.String{h.userPopupDistr.Value};
isPeaks = strcmp('complex', ...
   h.userPopupPoleType.String{h.userPopupPoleType.Value});
% take data of the reference function
data = getappdata(fig, 'values');
if ~isempty(data)
   if ~isempty(data.funRef)
      s = 1j*2*pi*data.frequency;
      funVF = [];
      try
         model = vectorFitting(s, data.funRef, ...
            nPoles, nIters, isPeaks, poleDistribution);
         funVF = reconstructFun(s, model);
         stat = computeStats(data.funRef, funVF);
         
         rmse = stat.rmse;
      catch
         
      end
      if ~isempty(funVF)
         data.funVF = funVF;
         data.model = model;
         data.rmse = rmse;
         setappdata(fig, 'values', data)
         
         updatePlot(fig)
      end
   end
end
end
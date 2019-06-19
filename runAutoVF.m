function runAutoVF(hObject, eventData)

fig = hObject.Parent.Parent.Parent;

h = getappdata(fig, 'handles');

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

data = getappdata(fig, 'values');
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


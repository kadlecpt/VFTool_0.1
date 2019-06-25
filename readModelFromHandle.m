function readModelFromHandle(fig)
%% readModelFromHandle read fun. specification from handle fun. edit
% This function creates reference function from the handle function 
% specification and saves it to the GUI data.
%
%  INPUTS
%   fig: GUI figure, figure [1 x n]
%
%  SYNTAX
%
%  readModelFromHandle(fig)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

h = getappdata(fig, 'handles');

nSamples = str2num(h.editHandleFNS.String); %#ok<*ST2NM>
startF = str2num(h.editHandleFStart.String);
stopF = str2num(h.editHandleFEnd.String);
validateattributes(nSamples, {'double'},{'>=', 3, 'size', [1, 1]})
validateattributes(startF, {'double'},{'>=', 0, 'size', [1, 1]})
validateattributes(stopF, {'double'},{'>', startF, 'size', [1, 1]})

if strcmp('lin', h.popupHandleFreq.String{h.popupHandleFreq.Value})
   vals.frequency = linspace(startF, stopF, nSamples);
else
   vals.frequency = logspace(startF, stopF, nSamples);
end
% create handle
try
   funHandle = str2func(h.editHandleFun.String);
   vals.funRef = funHandle(vals.frequency);
catch
   error('You have to specify a handle function.')
end

setappdata(fig, 'values', vals)
updatePlot(fig)
end
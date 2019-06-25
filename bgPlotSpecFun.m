function bgPlotSpecFun(hObject, eventData)
%% bgPlotSpecFun switch the type of plot
% This function switches type of plot: 'abs', 'real', 'imag' and updates 
% the plot.
%
%  INPUTS
%   hObject: buttongroup [1 x 1]
%   eventData: struct, not used
%
%  SYNTAX
%
%  bgPlotSpecFun(hObject, eventData)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

fig = hObject.Parent.Parent;
updatePlot(fig)
end
function loadFile(hObject, eventdata)
%% loadFile load file with ref. fun data
% This function loads data from specified file: *.txt, *.xls, or *.xlsx, and
% updates the function plot.
%
%  INPUTS
%   hObject: pushbutton [1 x 1]
%   eventData: struct, not used
%
%  SYNTAX
%
%  loadFile(hObject, eventData)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

fig = hObject.Parent.Parent.Parent;
h = getappdata(fig, 'handles');
path = h.editPath.String;
[file, path] = uigetfile(...
   fullfile(path, '*.xls; *.xlsx; *.txt'), 'select file');
[~, ~, ext] = fileparts(file);
fileLoc = fullfile([path, file]);
switch ext
   case '.txt'
      data = loadTxt(fileLoc);
   case {'.xls', '.xlsx'}
      % 
      data = loadXls(fileLoc);
end
vals.frequency = data(:,1)';
vals.funRef = data(:, 2)' + 1j*data(:, 3)';
setappdata(fig, 'values', vals)
updatePlot(fig)
end
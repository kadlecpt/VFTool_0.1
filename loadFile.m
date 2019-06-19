function loadFile(hObject, eventdata)
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


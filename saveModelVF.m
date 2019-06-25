function saveModelVF(hObject, eventData)
%% saveModelVF write VF model and function to specified file
% This function creates the file (*.mat, *.xls, *.xlsx, *.txt) and writes the 
% VF model data including the function values in it.
%
%  INPUTS
%   hObject: pushbutton [1 x 1]
%   eventData: struct, not used
%
%  SYNTAX
%   saveModelVF(hObject)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

fig = hObject.Parent.Parent;
data = getappdata(fig, 'values');

if ~isempty(data)
   if isfield(data, 'model')
      model = data.model; %#ok<*NASGU>
      funVf = data.funVF;
      frequency = data.frequency;
      h = getappdata(fig, 'handles');
      fileName = h.saveEdit.String;
      if h.saveCheckMat.Value
         save(fileName, 'model', 'funVf', 'frequency');
      end
      
      if h.saveCheckTxt.Value
         fileID = fopen([fileName, '.txt'], 'w');
         fprintf(fileID,'d [-],   e [-]\n');
         fprintf(fileID, '%3.15e, %3.15e\n', [model.d, model.e]);
         fprintf(fileID,'Re(r) [-],   Im(r) [-],   Re(p) [-],   Im(p) [-]\n');
         fprintf(fileID, '%3.15e, %3.15e, %3.15e, %3.15e\n', ...
            [real(model.residues), imag(model.residues), ...
            real(model.poles), imag(model.poles)]');
         fprintf(fileID,'freq [Hz],   Re(funVF) [-],   Im(funVF) [-]\n');
         fprintf(fileID, '%3.15e, %3.15e, %3.15e\n', ...
            [data.frequency, real(data.funVF), imag(data.funVF)]);
         fclose(fileID);
      end
      
      if h.saveCheckXlsx.Value
         xlswrite(fileName, {'d [-]'}, 'A1:A1');
         xlswrite(fileName, model.d, 'A2:A2');
         xlswrite(fileName, {'e [-]'}, 'B1:B1');
         xlswrite(fileName, model.e, 'B2:B2');
         xlswrite(fileName, {'Re(r) [-]', 'Im(r) [-]', 'Re(p) [-]', ...
            'Im(p) [-]'}, 'A3:D3');
         nPoles = size(model.poles, 1);
         range = ['A4:D', num2str(3 + nPoles)];
         xlswrite(fileName, [real(model.residues), imag(model.residues), ...
            real(model.poles), imag(model.poles)], range);
         xlswrite(fileName, {'freq [Hz]', 'Re(funVF) [-]', 'Im(funVF) [-]'}, ...
            'E1:G1');
         nS = size(data.funVF, 2);
         range = ['E2:G', num2str(1 + nS)];
         xlswrite(fileName, ...
            [data.frequency.', real(data.funVF).', imag(data.funVF).'], range);
      end
   end
end
end
function tableCellEdit(hObject, cData)
%% tableCellEdit poles, residues table cell change
% This function updates the table if any table cell is changed: new coumn 
% is added when necessary, or complex conjugate pair is created automaically.
%
%  INPUTS
%   hObject: uitable [1 x 1]
%   cData: info about action (e.g. cell indices), struct [1 x 1]
%
%  SYNTAX
%   tableCellEdit(hObject, cData)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

data = hObject.Data;
nPoles = size(data, 2);

%% create complex conjugate pairing
rowInd = cData.Indices(1, 1);
colInd = cData.Indices(1, 2);
str = data{rowInd, colInd};
curEntry = str2num(str);
validateattributes(curEntry, {'double'},{'size', [1, 1]})
if rowInd == 1 || rowInd == 3
   if abs(imag(curEntry)) ~= 0
      isSign = regexp(str, '[+-]');
      isEqual = false;
      ind = 1;
      while ~isEqual
         newStr = str;
         if strcmp(str(isSign(ind)), '+')
            newStr(isSign(ind)) = '-';
         else
            newStr(isSign(ind)) = '+';
         end
         newEntry = str2num(newStr)'; %#ok<*ST2NM>
         if curEntry == newEntry %#ok<BDSCI>
            isEqual = true;
         end
         ind = ind + 1;
      end
      data{rowInd+1, colInd} = newStr; 
   end
end

%% change size
if colInd == nPoles
   data{1, colInd+1} = '';
   data{2, colInd+1} = '';
   data{3, colInd+1} = '';
   data{4, colInd+1} = '';
end
hObject.Data = data;
end
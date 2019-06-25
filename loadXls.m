function data = loadXls(fileLoc)
%% loadXls load xls file with ref. fun data
% This function loads data from specified file: *.xls, or *.xlsx.
%
%  INPUTS
%   fileLoc: the file path, char [1 x n]
%
%  OUTPUTS
%   data: col1 - frequency, col2 - Re(f), col3 - Im(f), double [nS x 3]
%
%  SYNTAX
%
%  data = loadXls(fileLoc)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

try
   [data, ~] = xlsread(fileLoc);
catch ex
   error(['Xls file has to contain only two columns of data ', ...
      'and no header lines.'])
end
end
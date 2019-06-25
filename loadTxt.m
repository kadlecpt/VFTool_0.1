function data = loadTxt(fileLoc)
%% loadTxt load txt file with ref. fun data
% This function loads data from specified file: *.txt.
%
%  INPUTS
%   fileLoc: the file path, char [1 x n]
%
%  OUTPUTS
%   data: col1 - frequency, col2 - Re(f), col3 - Im(f), double [nS x 3]
%
%  SYNTAX
%
%  data = loadTxt(fileLoc)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

try
   data = load(fileLoc, '-ascii');
catch ex
   error(['Txt file has to contain only three columns of data ', ...
      'and no header lines.'])
end
end
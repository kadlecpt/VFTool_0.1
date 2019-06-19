function data = loadXls(fileLoc)

try
   [data, ~] = xlsread(fileLoc);
catch ex
   error(['Xls file has to contain only two columns of data ', ...
      'and no header lines.'])
end
end


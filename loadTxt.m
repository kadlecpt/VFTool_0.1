function data = loadTxt(fileLoc)
try
   data = load(fileLoc, '-ascii');
%    formatSpec = '%f %f %f\n';
%    fid = fopen(fileLoc, 'r');
%    data2 = fscanf(fid, formatSpec, [Inf 3]);
%    fclose(fid);
catch ex
   error(['Txt file has to contain only two columns of data ', ...
      'and no header lines.'])
end
end


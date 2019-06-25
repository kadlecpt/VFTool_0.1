function model = readModelFromTable(fig)
%% readModelFromTable read fun. specification from VF model specification
% This function creates reference function from the table and edit boxes 
% containing the definition of the VF model.
%
%  INPUTS
%   fig: GUI figure, figure [1 x n]
%
%  OUTPUTS
%   model: VF model, struct
%        .poles: complex poles, double [nP x 1]
%        .residues: complex rsidues, double [nP x 1]
%        .d: VF coeff., double [1 x 1]
%        .d: VF coeff., double [1 x 1]
%
%  SYNTAX
%   model = readModelFromTable(fig)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

h = getappdata(fig, 'handles');
table = h.tablePolesResidues;
dEdit = h.editSpecD;
eEdit = h.editSpecE;
%% search for poles and residues from the uitable
data = table.Data;
nPMax = size(data, 2);
res = data(1:2, 1:end-1);
poles = data(3:4, 1:end-1);
model.residues = [];
model.poles = [];
for iPos = 1:2*(nPMax-1)
   if ~strcmp(res{iPos}, '')
      model.residues = [model.residues; str2num(res{iPos})]; %#ok<*ST2NM>
   end
   if ~strcmp(poles{iPos}, '')
      model.poles = [model.poles; str2num(poles{iPos})];
   end
end

%% create freq. samples and d, e, coeffs 
nSamples = str2num(h.editSpecFNS.String); %#ok<*ST2NM>
startF = str2num(h.editSpecFStart.String);
stopF = str2num(h.editSpecFEnd.String);
model.d = str2num(dEdit.String);
model.e = str2num(eEdit.String);
validateattributes(nSamples, {'double'},{'>=', 3, 'size', [1, 1]})
validateattributes(startF, {'double'},{'>=', 0, 'size', [1, 1]})
validateattributes(stopF, {'double'},{'>', startF, 'size', [1, 1]})
validateattributes(model.d, {'double'},{'size', [1, 1]})
validateattributes(model.e, {'double'},{'size', [1, 1]})

if strcmp('lin', h.popupSpecFreq.String{h.popupSpecFreq.Value})
   vals.frequency = linspace(startF, stopF, nSamples);
else
   vals.frequency = logspace(startF, stopF, nSamples);
end
%% function values and GUI data update
vals.funRef = reconstructFun(1j*2*pi*vals.frequency, model);
setappdata(fig, 'values', vals)
updatePlot(fig)
end
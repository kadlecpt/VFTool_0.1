function bgVFTypeSpecSelection(hObject, eventData)
%% bgVFTypeSpecSelection switch the type of Vector Fitting
% This function switches type of VF: 'automatic', and 'uder-defined'.
%
%  INPUTS
%   hObject: buttongroup [1 x 1]
%   eventData: struct, not used
%
%  SYNTAX
%
%  bgVFTypeSpecSelection(hObject, eventData)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

fig = hObject.Parent.Parent;
h = getappdata(fig, 'handles');
switch hObject.SelectedObject.String
   case 'Automatic VF'
      h.autoVFPanel.Visible = 'on';
      h.userVFPanel.Visible = 'off';
   case 'User-defined VF'
      h.autoVFPanel.Visible = 'off';
      h.userVFPanel.Visible = 'on';
end
end
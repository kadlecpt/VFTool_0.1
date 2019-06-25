function bgFunSpecSelection(hObject, eventData)
%% bgFunSpecSelection switch panel for reference function definition
% This function switches panel for specification of reference function 
% definition: load from file, define by handle function, or by the VF model.
%
%  INPUTS
%   hObject: buttongroup [1 x 1]
%   eventData: struct, not used
%
%  SYNTAX
%
%  bgFunSpecSelection(hObject, eventData)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

fig = hObject.Parent.Parent;
h = getappdata(fig, 'handles');
switch hObject.SelectedObject.String
   case 'Specify p, r, d, e'
      h.specPanel.Visible = 'on';
      h.loadPanel.Visible = 'off';
      h.handlePanel.Visible = 'off';
      
      readModelFromTable(fig);
   case 'Load from file'
      h.loadPanel.Visible = 'on';
      h.specPanel.Visible = 'off';
      h.handlePanel.Visible = 'off';
      
   case 'Handle function'
      h.handlePanel.Visible = 'on';
      h.specPanel.Visible = 'off';
      h.loadPanel.Visible = 'off';
      
      readModelFromHandle(fig);
end
end
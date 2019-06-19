function bgFunSpecSelection(hObject, eventData)

fig = hObject.Parent.Parent;
h = getappdata(fig, 'handles');
switch hObject.SelectedObject.String
   case 'Specify p, r, d, e'
      h.specPanel.Visible = 'on';
      h.loadPanel.Visible = 'off';
   case 'Load from file'
      h.loadPanel.Visible = 'on';
      h.specPanel.Visible = 'off';
end
end


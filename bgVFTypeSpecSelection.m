function bgVFTypeSpecSelection(hObject, eventData)

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
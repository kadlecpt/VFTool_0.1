function updateHandleFun(hObject, eventData)
%% updateHandleFun pushbuttona callback to update ref. fun 
% This function updates the reference function defined by handle when editing 
% by user is completed.
%
%  INPUTS
%   hObject: pushbutton [1 x 1]
%   eventData: struct - not used
%
%  SYNTAX
%   updateHandleFun(hObject)
%
% © 2019, Petr Kadlec, BUT, kadlecp@feec.vutbr.cz

fig = hObject.Parent.Parent.Parent;
readModelFromHandle(fig);
end
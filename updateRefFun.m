function updateRefFun(hObject, eventData)
%% updateRefFun pushbuttona callback to update ref. fun 
% This function updates the reference function defined by VF model.
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
[~] = readModelFromTable(fig);
end
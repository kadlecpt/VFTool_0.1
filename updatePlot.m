function updatePlot(fig)
h = getappdata(fig, 'handles');
data = getappdata(fig, 'values');
switch h.bgPlotSpec.SelectedObject.String
   case 'Abs'
      hFun = @(x) abs(x);
   case 'Real'
      hFun = @(x) real(x);
   case 'Imag'
      hFun = @(x) imag(x);
end
if isfield(data, 'funRef')
   plot(h.axes, data.frequency, hFun(data.funRef), 'b-', ...
      'LineWidth', 2);
   h.legend = legend('ref fun');
   h.axes.NextPlot = 'add';
end
if isfield(data, 'funVF')
   plot(h.axes, data.frequency, hFun(data.funVF), 'r--o', ...
      'LineWidth', 2);
   h.legend = legend('ref fun', 'VF fun');
   h.textResNPoles.String = ...
      ['# poles N = ', sprintf('%d', size(data.model.poles, 1))];
end

if h.buttLogX.Value
   h.axes.XScale = 'log';
else
   h.axes.XScale = 'linear';
end

if h.buttLogY.Value
   h.axes.YScale = 'log';
else
   h.axes.YScale = 'linear';
end

h.axes.NextPlot = 'replacechildren';

if isfield(data, 'rmse')
   h.textResRmse.String = ['rmse = ', sprintf('%1.3e', data.rmse)];
   h.textResRmse.Enable = 'on';
   if  data.rmse <= str2num(h.autoEditRmse.String) %#ok<*ST2NM>
      % OK
      h.textResRmse.BackgroundColor = [0.57, 1, 0.6];
   else
      % not OK
      h.textResRmse.BackgroundColor = [1, 0.75, 0.7];
   end
   h.textResRmse.Enable = 'off';
end

end


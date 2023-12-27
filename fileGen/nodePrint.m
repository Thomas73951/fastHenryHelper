
function file = nodePrint(file, NMin, NMax, x, y, z)
  % turn set of x,y values into fasthenry nodes
  % takes fixed Z value for coil (flat in z axis)
  for i = NMin:NMax
    fprintf(file, ['N', num2str(i), ' x = ', num2str(x(i+1-NMin)), ' y = ' num2str(y(i+1-NMin)), ' z = ' num2str(z), '\n']);
  endfor
endfunction


function file = nodePrint(file, NMin, NMax, x, y, z)
  % turn set of x,y values into fasthenry nodes (starting with node #NMin and ending with node #NMax)
  % TODO: mismatch between NMin, NMax & size of x, y not tested for
  % ... using fixed z value.
  % file: .inp file for text to be written to
  % NMin: starting node (first object of file starts with N1)
  % NMax: ending node
  % x, y: vectors of points
  % z: single value, set for all. (coil is then flat in z axis)

  for i = NMin:NMax
    % n.b. iterator ^ is like this for node number but needs offsetting for x,y,z indices
    fprintf(file, ['N', num2str(i), ' x = ', num2str(x(i+1-NMin)), ' y = ' num2str(y(i+1-NMin)), ' z = ' num2str(z(i+1-NMin)), '\n']);
  endfor
endfunction

% function file nodePrint created by Thomas Sharratt Copyright (C) 2024
% <Created for Octave on Arch Linux & Windows>

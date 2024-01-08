
function file = EPrint(file, NMin, NMax, traceWidth, externalName)
  % connect nodes with E statments in series from node #NMin to node #NMax
  % & add port connections of node #NMin and node #NMax
  % file: .inp file for text to be written to
  % NMin: starting node (first object of file starts with N1)
  % NMax: ending node
  % traceWidth: width of each line drawn (one value)
  % externalName: desired name of the port in .external statement

  for i = NMin:NMax-1
    fprintf(file, ['E', num2str(i), ' N', num2str(i), ' N', num2str(i+1), ' w = ', num2str(traceWidth), '\n']);
  endfor

  fprintf(file, ['.external N', num2str(NMin), ' N', num2str(NMax), ' ', externalName, '\n']);
endfunction

% function file EPrint created by Thomas Sharratt Copyright (C) 2024
% <Created for Octave on Arch Linux & Windows>

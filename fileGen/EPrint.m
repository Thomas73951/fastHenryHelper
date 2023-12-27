
function file = EPrint(file, NMin, NMax, traceWidth, externalName)
  % connect nodes with E statments & add port connections
  for i = NMin:NMax-1
    fprintf(file, ['E', num2str(i), ' N', num2str(i), ' N', num2str(i+1), ' w = ', num2str(traceWidth), '\n']);
  endfor

  fprintf(file, ['.external N', num2str(NMin), ' N', num2str(NMax), ' ', externalName, '\n']);
endfunction

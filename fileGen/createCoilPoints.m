
function [x,y] = createCoilPoints(s, id, turns, offset)
  % offset as array [offsetX, offsetY]
  x = [];
  y = [];

  for i = 0:turns % does turns + 1 worth then trims.
    x = [x, -i*s, -i*s, id + i*s, id + i*s];
  endfor

  y = x(2:end); % same as x but shifted by one val
  x = x(1:end-1); % trim x to have same # of vals as y

  x = x(1:end-2); % remove last two points for complete turns
  y = y(1:end-2);

  x = x + (offset(1) - id/2); % offset for ID, puts 0,0 in centre of ID.
  y = y + (offset(2) - id/2);
endfunction


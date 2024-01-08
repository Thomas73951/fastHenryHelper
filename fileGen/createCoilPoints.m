
function [x,y, z] = createCoilPoints(s, id, turns, offset, thickness)
  % creates array of points, one for each node in a square coil with:
  % s: spacing between each trace centre (gap between traces = spacing - traceWidth)
  % id: inner diameter, square centre area with side length of id
  % turns: number of complete turns
  % offset: middle of coil at (0,0) by default,
  % give as array [offsetX, offsetY, offsetZ]
  % to move the centre change x & y, to move the height of the coil, change z
  % z added for bringing centre port of coil to border for both ports in same place
  % thickness - z offset of returning ^ (taken as is, give negative for "behind") TODO: IMPLEMENT
  % n.b. unitless, depends on default set in .inp file frontmatter (usually mm)

  x = [];
  y = [];
  z = [];

  for i = 0:turns % does turns + 1 worth then trims.
    x = [x, -i*s, -i*s, id + i*s, id + i*s];
  endfor

  y = x(2:end); % same as x but shifted by one val
  x = x(1:end-1); % trim x to have same # of vals as y

  x = x(1:end-2); % remove last two points for complete turns
  y = y(1:end-2);

  x = x + (offset(1) - id/2); % offset for ID, puts 0,0 in centre of ID.
  y = y + (offset(2) - id/2);

  z = offset(3) * ones(size(x));  % TODO: TEMP creates as constant value of offsetZ
endfunction

% function file createCoilPoints created by Thomas Sharratt Copyright (C) 2024
% <Created for Octave on Arch Linux & Windows>

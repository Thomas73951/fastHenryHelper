
function [x,y, z] = createCoilPoints(s, id, turns, offset, thickness, portSpacing)
  % creates array of points, one for each node in a square coil with:
  % s: spacing between each trace centre (gap between traces = spacing - traceWidth)
  % id: inner diameter, square centre area with side length of id
  % turns: number of complete turns
  % offset: middle of coil at (0,0) by default,
  % give as array [offsetX, offsetY, offsetZ]
  % to move the centre change x & y, to move the height of the coil, change z
  % z added for bringing centre port of coil to border for both ports in same place
  % thickness: z offset of returning ^ (taken as is, give negative for "behind")
  % portSpacing: gap between the two ports on the outside of the coil
  % n.b. unitless, depends on default set in .inp file frontmatter (usually mm)

  if (portSpacing > id)
    error("COIL GEOMETRY ERROR. Port spacing > inner diameter. Traces collide.")
  endif

  x = [];

  for i = 0:turns % does turns + 1 worth then trims.
    x = [x, -i*s, -i*s, id + i*s, id + i*s]; % append new set of four points
  endfor

  y = x(2:end); % same as x but shifted by one val
  x = x(1:end-1); % trim x to have same # of vals as y

  x = x(1:end-2); % remove last two points for complete turns
  y = y(1:end-2);

  % create z array of same size as x (& y)
  z = offset(3) * ones(size(x));

  % Bring inner port to outside edge (done pre-offset), 3 new lines
  % starts from new first node A on outside edge of coil:
  % A: line in y - outside to centre, z = thickness,
  % B: line in z - thickness to offsetZ
  % C: line in x - middle(ish) of id to bottom left corner
  % D is then existing first node of original array.
  xInnerPort = id/2 - portSpacing/2; % becomes port on the left
  x = [xInnerPort,           xInnerPort,          xInnerPort, x];
  y = [min(y),               0,                   0         , y];
  z = [offset(3) + thickness,  offset(3) + thickness, offset(3)   , z];

  % DEAL WITH OFFSET
  % coil starts with 0,0,offsetZ at bottom left corner of ID area
  x = x + (offset(1) - id/2); % offset for ID, puts 0,0 in centre of ID.
  y = y + (offset(2) - id/2);

  % modify last node to make last line shorter (ports at the bottom middle)
  x(end) = offset(1) + portSpacing/2;

endfunction

% function file createCoilPoints created by Thomas Sharratt Copyright (C) 2024
% <Created for Octave on Arch Linux & Windows>

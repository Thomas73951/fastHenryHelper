
function saveImages()
  % saves all open figures to images/ directory with timestamp and figure number
  figHandles = get(groot, 'Children');
  for i = 1:size(figHandles,1)
    imfile = ['images/',datestr(clock, 'yy-mm-dd HH-MM-SS'),' Fig', num2str(figHandles(i,:)), '.png'];
    saveas(figHandles(i,:),imfile)
  endfor
endfunction

% function file saveImages created by Thomas Sharratt Copyright (C) 2023
% <Created for Octave on Arch Linux>

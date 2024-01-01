
function saveImages()
  % saves all open figures to images/ directory with timestamp and figure number
  if (!exist('images/')) % creates directory if doesn't exist
    disp("'images' directory doesn't exist, creating...")
    mkdir("images/");
  endif

  figHandles = get(groot, 'Children');
  currTime = datestr(clock, 'yy-mm-dd HH-MM-SS');
  for i = 1:size(figHandles,1)
    imfile = ['images/', currTime,' Fig', num2str(figHandles(i,:)), '.png'];
    saveas(figHandles(i,:),imfile)
  endfor
endfunction

% function file saveImages created by Thomas Sharratt Copyright (C) 2024
% <Created for Octave on Arch Linux>

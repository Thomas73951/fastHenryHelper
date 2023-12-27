clear
close all;

% square side in mm
l = 20; 


file_name = 'fasthenry_matlab.inp';
file = fopen(file_name,'wt');

fprintf(file, '* matlab-generated fasthenry file \n');
fprintf(file, '.units mm \n');
fprintf(file, '.default z = 0 sigma = 5.8e4 \n');
fprintf(file, 'N1  x = 0  y = 0 \n');


% the next three lines contain the square side
fprintf(file, ['N2  x = ', num2str(l),' y = 0 \n']);
fprintf(file, ['N3  x = ', num2str(l),' y = ' num2str(l),' \n']);
fprintf(file, ['N4  x = 0 y = ' num2str(l),' \n']);

fprintf(file, 'N5  x = 0  y = 1 \n');
fprintf(file, 'E1 N1 N2 w = 0.5 h = 0.035 \n');
fprintf(file, 'E2 N2 N3 w = 0.5 h = 0.035 \n');
fprintf(file, 'E3 N3 N4 w = 0.5 h = 0.035 \n');
fprintf(file, 'E4 N4 N5 w = 0.5 h = 0.035 \n');

fprintf(file, '.external N1 N5 \n');
fprintf(file, '.freq fmin = 1e4 fmax  = 1e7 ndec = 1 \n');
fprintf(file, '.end \n');

fclose(file)


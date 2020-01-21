%% Script to deconvolute the test spectra from PCCDB database
%% and compare with the DSSP secondary structures
%% Written by Pengzhi Zhang
%% Cheung group

% Specify the folder where the files live.
clear;
myFolder = './CD';

% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.cd');
theFiles = dir(filePattern);

allSS=zeros(length(theFiles),10);

for k = 1 : length(theFiles)
  baseCDFileName = theFiles(k).name;
  temp = split(baseCDFileName, '.');
  temp{2}='dssp';
  basedsspFileName = join(temp,'.');
  basedsspFileName = basedsspFileName{1};
  fullCDFileName = fullfile(myFolder, baseCDFileName);
  fulldsspFileName = fullfile(myFolder, basedsspFileName);
  %fprintf(1, 'Now reading %s\n', fullCDFileName);
  
  ss = deconvolution(load(fullCDFileName));
  
  % Read DSSP data for reference.
  fileID = fopen(fulldsspFileName);
  dssp = textscan(fileID, '%s %f');
  fclose(fileID);
  dssp = reshape(dssp{2},[1,4]);
  rms_ss = rms(dssp - ss(1:4));
  ss(6) = rms_ss;
  allSS(k,:) = [ss, dssp];
end

fprintf(1, 'A total of %d spectra data are read.\n', k); 
disp('mean and std of RMSD (secondary structures):');
disp(mean(abs(allSS(:,1)-allSS(:,7))));
disp(std(abs(allSS(:,1)-allSS(:,7))));

disp(mean(abs(allSS(:,2)-allSS(:,8))));
disp(std(abs(allSS(:,2)-allSS(:,8))));

disp(mean(abs(allSS(:,3)-allSS(:,9))));
disp(std(abs(allSS(:,3)-allSS(:,9))));

disp(mean(abs(allSS(:,4)-allSS(:,10))));
disp(std(abs(allSS(:,4)-allSS(:,10))));

disp(mean(allSS(:,6)));
disp(std(allSS(:,6)));

disp('mean and std of RMSD (CD spectra):');
disp('mean and std of RMSD (secondary structures):');
disp(mean(abs(allSS(:,5))));
disp(std(abs(allSS(:,5))));

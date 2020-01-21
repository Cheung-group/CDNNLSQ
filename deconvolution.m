function [fit_stat]=deconvolution(cd_spectra)
%%Written by Jacob Ezerski 
%%Cheung Group, University of Houston, TX
%%Version 1.0 Release -- 12/11/19

sdp48cd=importdata('./reference_database/sdp48_cd',' '); %%Imports 48x51 matrix
sdp48ss=importdata('./reference_dataebase/sdp48_ss',' '); %%imports 48x6 matrix
sdp48cd=sdp48cd'; %%transpose -- 
sdp48ss=sdp48ss';
range=[240:-1:190]; %%CD range for db, goes from high to low wavelength
%%make the input data a column vector and check that its 51 points
exp_cd=cd_spectra;
if(size(cd_spectra,1)~=51)
    exp_cd=cd_spectra';
end

if(size(exp_cd,1)~=51)
    disp('Error input spectra. Make sure to use input data with 51 points from 240-190nm')
    return
end

sol = lsqnonneg(sdp48cd,exp_cd); %solution to matrix
appx_spectra=sdp48cd*sol;
%plot(range,appx_spectra,':r', range,exp_cd,'b', 'LineWidth', 2);
%title('Deconvolution results')
%legend('Appx spectra','exp spectra')
%%scale solution and produce SS fractions
ss_fracts=sdp48ss*sol; %solve for ss
ss_fracts=ss_fracts./(sum(ss_fracts)); %scaling
four_code=zeros(4,1);
four_code(1)=sum(ss_fracts(1:2));
four_code(2)=sum(ss_fracts(3:4));
four_code(3)=ss_fracts(5);
four_code(4)=ss_fracts(6);
%disp('SS fractions: helix, beta, turn, unordered')
%disp(four_code')
ss=four_code;
rmsd=sqrt(sum((appx_spectra-exp_cd).^2)/51);
%disp('RMSD=')
%disp(rmsd)
fit_stat=[ss',rmsd];    
end

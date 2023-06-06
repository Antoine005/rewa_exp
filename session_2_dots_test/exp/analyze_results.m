function []=analyze_results(subID)
%
% Generate decreasing reward schedule. In this version, just the slope
% (normalized) of the decrease. You will need norm_slope when you create
% input file for the reward session.
%
% You need to see the SAT of the subject first. This is imporant for
% adjusting the values in pC_benchMark. Basically, you want to pick the
% values within the range with the sharpest change in performance.
%
% ------------------------ History ------------------------------
% SWU.2013.06.12.
% - change sv to 1.
% - funcForm: functional form of the SAT function.
% - norm_slope: normalized slope.
% - finalist: a matrix containing information about how good the schedules
% are.

% YHL.2012.
% 2014.02.14
% - add penalty and the loss = gain at different time

% CCT 2014.03.18
% modified "getMoneyParams_pain.m"


% This is to get mean RT data and minimal RT in order to perform SAT
% analysis.
if ismac
    inputfile = ['inputs/Test_' subID '_SAT_Color'];
elseif ispc
    inputfile = ['inputs/Test_' subID '_SAT_Color'];
end
load(inputfile);

[total_pHat,total_mu_rt,total_pHat2,total_mu_rt2] =analyze_sat_coherence(subID);
M = [total_pHat,total_mu_rt,total_pHat2,total_mu_rt2];
% disp(rt_mat_SAT)

%% save to file.

filename=['data/results/results_' subID ];

ID=subID;
save(filename,'ID','total_pHat','total_mu_rt','total_pHat2','total_mu_rt2');
FileData = load(['data/results/results_' subID '.mat']);
csvwrite(['data/results/results_' subID '.csv'], M)

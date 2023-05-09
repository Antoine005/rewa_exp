function Read_me_Session1_pretest
%
% <Session_1_dots_pretest>
% 
% -------------------------
% How to run the experiment
% -------------------------
% 
% -Create inputs
%  1.create inputs by using "inputs/createInputs_SAT_Color_v2.m"
%  2.createInputs_SAT_Color_v2(subID,pretest)
% 
% -Execute experiment
%  3.execute run_SAT_ColorPenalty(subID,blockNo,pretest)
% 
% ** if you want to run for Training session, pretest =1
% 
% trials = 36 trials X 9 blocks
% 
% 
% --------------------
% Preliminary analysis
% --------------------
% 
% -determine coherence level of stimulus
% 1. run analyze_SAT_Color_pretest
% 2. check under which Coherence level, subjects' performace close to SAT pattern.
% (Accuracy increase as more time is using to make judgement)
% 
% 
% 
% --------------------
% Experiment variables
% --------------------
% 
% "inputs" folder : parameters
% "data"   folder : recoding data
% 
% In the input folder, each mat file is used for each subject's inputs.
% Each mat file is 9*1 structure array and each row is used for each block.
% ------------------------------------------------------------------------
% ----------------------- Introduction for variables ---------------------
%
% nTrialsPB         : number of tiral per block
% timeLimit         : duration for showing sampled-dots and making response (s)  
% redDomi           : the dominated color is red or not (1 = red dominated)
% sampleRate        : the frequency of showing sampled dots (Hz) (20Hz = 50ms/dots)
% redRatio          : ratio = red : green (each block used different ratio)
% apXYD             : the size of aperture (degree) 
% trial_redDomi     : the dominated color is red or not (1 = red dominated)for 36 trials.
% trial_timeLimit   : the duration for showing dots and making response for 36 trials.
% trial_redLeft     : the location of two color options (1 = red located on left) for 36 trials.
% Pair_TimeDomiShif : how to pair Time and Dominated color and location of options
% trial_redRatio    : supposed red is dominated color, ratio = red : green, for 36 trials
% trial_samples     : trials*dots = 36*70, because maximun dots is 70 dots (3.5s * 20Hz), for 36 trials.
% 1 = red, 0 = green, -1 = no sampling
% realRED           : red:green, computed from sampling  
% trial_x_shift     : defined the coordinate for dots (x-axis)
% trial_y_shift     : defined the coordinate for dots (y-axis)
%
% ------------------------------------------------------------------------
% ----------------------- Introduction for outcome -----------------------
%
% Column 1       2          3           4     5   6        7        8          9       
%     blockNo, trialNo, buttonPress, chooseR, RT, win, total_sum, correct, chooseLeft
function [rt_mat] = analyze_SAT_Color_pretest(subID,startBlock)
% --------------------------
%        Introduction
% --------------------------
% -GOAL: determine coherence level of stimulus
% 1. run analyze_SAT_Color_pretest
% 2. check under which Coherence level, subjects' performace close to SAT pattern.
%    (Accuracy increase as more time is using to make judgement)
%
% -Setting for executing function
% 1. subID: type one of subID in following list.
%     List of Subjects:
%      CJW, CJL, CHW, CHL, YYY, YYD, YHW, WJC, SPL, PCH, MHL, LYC, KLH, ...
%      HKH, CYC, CLW, HJC, MPH, SYF, TTC, TTY
% 2. startBlock: start from which block. If you set up with 5, it will run
%    5 to 9 block.
% EX: analyze_SAT_Color_pretest('TTY',1)
%      -> analyze subject TTY's data from 1 to 9 block.
%
% -Structure of experiment
% In this session, each block used one coherence level, the order is [0.6
% 0.57 0.54 0.6 0.57 0.54 0.6 0.57 0.54]. Therefore, total is 9 blocks.
%



%% load input file
inputfile = ['../exp/inputs/Pretest_' subID '_SAT_Color'];
load(inputfile);
datafile  = ['../exp/data/Pretest_' subID '_SAT_Color.txt'];
data      = load(datafile); % load text file into workspace and named data

%% setting to analysis
timeLimit = inputs(1).timeLimit;   % possible time limits
cohSet    = [0.6 0.57 0.54];       % possible coherence levels (3 levels in this experiment).
n_coh     = length(cohSet);        % # of coherence used to generate a empty matrix for calculate reaction time under each coherence level
n_time    = length(timeLimit);     % # of time constrains used to generate a empty matrix for calculate reaction time under each coherence level
sum_rt    = zeros(n_coh,n_time);   % empty matrix for accumulating RT
n_trials  = sum_rt;                % empty matrix for accumulating # of trials under each coherence level
n_correct = sum_rt;                % empty matrix for accumulating # of correct under each coherence level
nTrials   = size(data,1);          % # of trials in total with missing data
max_time  = max(inputs(1).trial_timeLimit); % maximum time in experiment setting (i.e. 4.2s, even in session1 max_time is 3.5s)
min_RT    = max_time;              % To find out the minimum RT, we set the max_time as begining, and modified it trial by trial.

%% start to accumulate correct answer and total RT
for i=1:nTrials;
    blockNo = data(i,1);
    trialNo = data(i,2);
    
    if blockNo>=startBlock
        % If the subject did not make a response, the 8th column would be -1,
        % and we need to exclude them!
        if data(i,8)~=-1
            
            % replace the min_RT, if crt is smaller than min_RT
            crt=data(i,5);    % reaction time in current trial
            if crt < min_RT   
                min_RT = crt; 
            end
            
            % check the place that data in current trial belong to.
            time_current = inputs(blockNo).trial_timeLimit(trialNo); % time constrain in current trial
            indx_time    = find(timeLimit==time_current);           
            coh_current  = inputs(blockNo).redRatio;
            indx_coh     = find(cohSet==coh_current);
            
            % accumulate RT for different coherence level
            sum_rt(indx_coh,indx_time)  = sum_rt(indx_coh,indx_time)+crt;
            
            % accumulate # of trials
            n_trials(indx_coh,indx_time)= n_trials(indx_coh,indx_time)+1;
      
            % accumulate # of correct trials
            switch data(i,8)
                case 1
                correct=1;
                case 0
                correct=0;
            end
            n_correct(indx_coh,indx_time)= n_correct(indx_coh,indx_time)+correct;
            
        end
    end
end


mu_rt = sum_rt./n_trials;       % mean RT (for each coherence level and time constrain)
pHat  = n_correct./n_trials;    % probability of correct (for each coherence level and time constrain)
disp(class(pHat))
rt_mat= [sum_rt;n_correct;n_trials];
% row 1: sum of RT
% row 2: total number of correct trials
% row 3: total number of valid trials


%% seperately plot the result for different coherence level 
% title(['Pretest ' subID]);
% hold on;
%window_1= msgbox(sprintf(' %f \n',pHat));
DL=mean(pHat);
disp(pHat)
x=["1.5s" "2.0s" "2.5s"];
y=["60:40" "57:43" "54:46"];
disp(DL)

window_2= msgbox(sprintf('%s = %5.3f\n',[x;DL]),'TimeLimits','help');
DR=mean(pHat,2);
disp(DR)
window_3= msgbox(sprintf('%s = %5.3f\n',[y;reshape(DR.',1,[])]),"DotRatio",'help');
%for i=1:n_coh
    %subplot(1,n_coh,i);
    %axis([0 max_time+0.2 0.5 1]); hold on
    %plot(mu_rt(i,:),pHat(i,:),'.','markersize',20);
    %hold on;
   % plot(mu_rt(i,:),pHat(i,:));axis([0 max_time+0.2 0.5 1]); hold on
  %  title(['coh=' num2str(cohSet(i))]);
 %   axis square
%end
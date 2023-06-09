function [rt_mat,min_RT,max_time] = analyze_SAT_Color_whole(subID,session)
%
% 2013.06.13. SWW. 
%
% 2012.12.28.SWW.Output minimum RT (min_RT). min_RT would be the
% upper bound for the rising parameter (delta) in the SAT function.
%
% analyze SAT session.
%
% YHL. 2011
% CCT 2014.03.18 modified "analyze_SAT_mix_whole_color.m"

if nargin<3
    plot_yes=0;
end

% load input file
switch session
    case 1   % 1 = SAT session;
    inputfile = ['../../../session_2_dots_test/analysis/inputs/Test_' subID '_SAT_Color'];
    datafile  = ['../../../session_2_dots_test/analysis/data/Test_' subID '_SAT_Color.txt'];
    case 2   % 2 = Reward session
    inputfile = ['../inputs/Reward_' subID '_SAT'];
    datafile  = ['../data/Reward_' subID '_SAT_Color.txt'];
end

load(inputfile);
% load output file
%  - data = [blockNo trialNo buttonPress chooseUp RT win block_money]
data = load(datafile);


timeLimit = inputs(1).timeLimit;   % possible time limits
cohSet =inputs(1).redRatio/100;    % possible coherence levels (just 1 in this experiment).

nTrials = size(data,1)

sum_rt=zeros(length(cohSet),length(timeLimit));
n_trials = sum_rt;
n_correct= sum_rt;

% max_time=max(inputs(1).trial_timeLimit);
max_time = 4.2;
min_RT   = max_time;
count_valid=0;

for i=1:nTrials;
    blockNo=data(i,1);
    trialNo=data(i,2);


    % if the subject did not make a response, the 8th column would be -1.
    if data(i,8)~=-1
 
        crt=data(i,5);  %current RT
        if crt<min_RT
            min_RT=crt; % to find the minmal RT
        end
        
        count_valid=count_valid+1;
        rt_vect(count_valid)=crt;
        
        time_current= inputs(blockNo).trial_timeLimit(trialNo); % time constrain in current trial
        indx_time   = find(timeLimit==time_current);
        coh_current = inputs(blockNo).trial_redRatio(trialNo);
        
        indx_coh    = 1;  % only one coherence level
        
        sum_rt(indx_coh,indx_time)  = sum_rt(indx_coh,indx_time)+crt;
        
        n_trials(indx_coh,indx_time)= n_trials(indx_coh,indx_time)+1;
       
        
        
        if data(i,8)==1
            correct=1;
        elseif data(i,8)==0
            correct=0;
        end
        
        n_correct(indx_coh,indx_time)=n_correct(indx_coh,indx_time)+correct;
    end
end



mu_rt = sum_rt./n_trials;   % mean RT
pHat = n_correct./n_trials;    % probability of correct

rt_mat = [sum_rt(1,:);n_correct(1,:);n_trials(1,:)];
% row 1: sum of RT
% row 2: total number of correct trials
% row 3: total number of valid trials

if plot_yes
    figure(3);hold on
    plot(mu_rt(1,:),pHat(1,:),'.','markersize',50);
    hold on;
    xlabel('reaction time')
    ylabel('probability of correct')
    title(subID)
    axis square;
    
    figure(4);hold on
    hist(rt_vect,50);
    title('RT distribution');
end
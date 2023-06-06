function [total_pHat,total_mu_rt,total_pHat2,total_mu_rt2] = analyze_sat_coherence(subID)
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
if ismac
    inputfile = ['inputs/Test_' subID '_SAT_Color'];
    datafile = ['data/Test_' subID '_SAT_Color.txt'];
    datafile2 = ['data/Test_' subID '_SAT_Color2.txt'];
elseif ispc
    inputfile = ['inputs/Test_' subID '_SAT_Color'];
    datafile = ['data/Test_' subID '_SAT_Color.txt'];
    datafile2 = ['data/Test_' subID '_SAT_Color2.txt'];
end

load(inputfile);
% load output file
data = load(datafile);
data2 = load(datafile2);
% data = [blockNo trialNo buttonPress chooseUp RT win block_money]

timeLimit = inputs(1).timeLimit;   % possible time limits
cohSet =inputs(1).redRatio/100;              % possible coherence levels (just 1 in this experiment).
disp(cohSet)
nTrials = size(data,1)
sum_rt=zeros(length(cohSet),length(timeLimit));
% n_trials=sum_rt;
n_trials=sum_rt;
n_correct=sum_rt;
sum_rt2=zeros(length(cohSet),length(timeLimit));
n_trials2=sum_rt2;
n_correct2=sum_rt2;

max_time=max(inputs(1).trial_timeLimit);
% total_score = inputs(240).accumulated_points;
min_RT=max_time;
count_valid=0;

for i=1:nTrials;
    
 if mod(i,2) == 1; %choose date coherence level [60:40]
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
        
        time_current = inputs(blockNo).trial_timeLimit(trialNo);
        indx_time = find(timeLimit==time_current);
        coh_current =inputs(blockNo).trial_redRatio(trialNo);
%         if coh_current == cohSet
            indx_coh=1;
% %         indx_coh = find(cohSet==coh_current);
%         elseif coh_current~= cohSet
%             indx_coh=2;
%         end
        sum_rt(indx_coh,indx_time)=sum_rt(indx_coh,indx_time)+crt;
        
        n_trials(indx_coh,indx_time)=n_trials(indx_coh,indx_time)+1;
       
        
        
        if data(i,8)==1
            correct=1;
        elseif data(i,8)==0
            correct=0;
        end
        
        n_correct(indx_coh,indx_time)=n_correct(indx_coh,indx_time)+correct;
%         end
    end
    
elseif mod(i,2) == 0; %choose date coherence level [55:45]
 blockNo=data(i,1);     
 trialNo=data(i,2); 
    
 
    if data(i,8)~=-1
 
        crt=data(i,5);  %current RT
        if crt<min_RT
            min_RT=crt; % to find the minmal RT
        end
        
        count_valid=count_valid+1;
        rt_vect2(count_valid)=crt;
        
        time_current = inputs(blockNo).trial_timeLimit(trialNo);
        indx_time = find(timeLimit==time_current);
        coh_current =inputs(blockNo).trial_redRatio(trialNo);
%         if coh_current == cohSet
            indx_coh=1;
% %         indx_coh = find(cohSet==coh_current);
%         elseif coh_current~= cohSet
%             indx_coh=2;
%         end
        sum_rt2(indx_coh,indx_time)=sum_rt2(indx_coh,indx_time)+crt;
        
        n_trials2(indx_coh,indx_time)=n_trials2(indx_coh,indx_time)+1;
       
        
        
        if data(i,8)==1
            correct=1;
        elseif data(i,8)==0
            correct=0;
        end
        
        n_correct2(indx_coh,indx_time)=n_correct2(indx_coh,indx_time)+correct;    
end

end
end

mu_rt = sum_rt./n_trials;   % mean RT
pHat = n_correct./n_trials;    % probability of correct

rt_mat = [sum_rt(1,:);n_correct(1,:);n_trials(1,:)];

total_pHat = mean(mean(pHat));
total_mu_rt = mean(mean(mu_rt));

rt_mat2 = [sum_rt2(1,:);n_correct2(1,:);n_trials2(1,:)];

% row 1: sum of RT
% row 2: total number of correct trials
% row 3: total number of valid trials
% label_pHat = [];
% label_mu_rt = [];
% x="";
% y="";
% window_2= msgbox(sprintf('%5.1f = %5.3f\n',[x;total_pHat]),'ProbabilityCorrect task 2','help');
% window_3= msgbox(sprintf('%5.1f = %5.3f\n',[y;total_mu_rt]),'Mean RT task 2','help');
% window_4= msgbox(sprintf(' %f \n',mu_rt),'Mean RT','help');

% Second Task
for i=1:nTrials;
    
 if mod(i,2) == 1; %choose date coherence level [60:40]
    blockNo=data2(i,1);
    trialNo=data2(i,2);
    
    
    
    

    % if the subject did not make a response, the 8th column would be -1.
    if data2(i,8)~=-1
 
        crt=data2(i,5);  %current RT
        if crt<min_RT
            min_RT=crt; % to find the minmal RT
        end
        
        count_valid=count_valid+1;
        rt_vect(count_valid)=crt;
        
        time_current = inputs(blockNo).trial_timeLimit(trialNo);
        indx_time = find(timeLimit==time_current);
        coh_current =inputs(blockNo).trial_redRatio(trialNo);
%         if coh_current == cohSet
            indx_coh=1;
% %         indx_coh = find(cohSet==coh_current);
%         elseif coh_current~= cohSet
%             indx_coh=2;
%         end
        sum_rt(indx_coh,indx_time)=sum_rt(indx_coh,indx_time)+crt;
        
        n_trials(indx_coh,indx_time)=n_trials(indx_coh,indx_time)+1;
       
        
        
        if data2(i,8)==1
            correct=1;
        elseif data2(i,8)==0
            correct=0;
        end
        
        n_correct(indx_coh,indx_time)=n_correct(indx_coh,indx_time)+correct;
%         end
    end
    
elseif mod(i,2) == 0; %choose date coherence level [55:45]
 blockNo=data2(i,1);     
 trialNo=data2(i,2); 
    
 
    if data2(i,8)~=-1
 
        crt=data2(i,5);  %current RT
        if crt<min_RT
            min_RT=crt; % to find the minmal RT
        end
        
        count_valid=count_valid+1;
        rt_vect2(count_valid)=crt;
        
        time_current = inputs(blockNo).trial_timeLimit(trialNo);
        indx_time = find(timeLimit==time_current);
        coh_current =inputs(blockNo).trial_redRatio(trialNo);
%         if coh_current == cohSet
            indx_coh=1;
% %         indx_coh = find(cohSet==coh_current);
%         elseif coh_current~= cohSet
%             indx_coh=2;
%         end
        sum_rt2(indx_coh,indx_time)=sum_rt2(indx_coh,indx_time)+crt;
        
        n_trials2(indx_coh,indx_time)=n_trials2(indx_coh,indx_time)+1;
       
        
        
        if data2(i,8)==1
            correct=1;
        elseif data2(i,8)==0
            correct=0;
        end
        
        n_correct2(indx_coh,indx_time)=n_correct2(indx_coh,indx_time)+correct;    
end

end
end

rt_mat = [sum_rt(1,:);n_correct(1,:);n_trials(1,:)];

mu_rt2 = sum_rt./n_trials;   % mean RT
pHat2 = n_correct./n_trials;    % probability of correct
% score_dvd_total = 

rt_mat2 = [sum_rt2(1,:);n_correct2(1,:);n_trials2(1,:)];

% row 1: sum of RT
% row 2: total number of correct trials
% row 3: total number of valid trials
% label_pHat = ['sum_of_RT' 'correct_trials' 'valid_trials'];
% label_mu_rt = [];
total_pHat2 = mean(mean(pHat2));
total_mu_rt2 = mean(mean(mu_rt2));
% x="";
% y="";
% window_2= msgbox(sprintf('%5.1f = %5.3f\n',[x;total_score]),'ProbabilityCorrect task 2','help');
% window_3= msgbox(sprintf('%5.1f = %5.3f\n',[y;total_mu_rt2]),'Mean RT task 2','help');
% window_4= msgbox(sprintf(' %f \n',mu_rt),'Mean RT','help');

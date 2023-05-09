function run_myRDM_SAT_Color_money_penalty(subID,blockNo)

% Run tradeoff experiment.
% SWW.2013.
% CCT 2014.03.20

global red yellow gap white inputs screenInfo rightKey leftKey xCtr yCtr width_fix buttonPress fixation_but

HideCursor
% Removes the blue screen flash and minimize extraneous warnings.
Screen('Preference', 'VisualDebugLevel', 3);
Screen('Preference', 'SuppressAllWarnings', 1);
tic;
%%%%--------------------------------------------------------------------
%% setting parameters for screen and colors
% Open a onscreen window.
white = [255 255 255];
yellow = [255 255 0];
red = [255 0 0];
screenInfo = my_openExperiment(32,50,0);
textSize=24;Screen(screenInfo.curWindow,'TextSize',textSize);
lineHeight=1.5*textSize;
textFont='Arial';Screen(screenInfo.curWindow,'TextFont',textFont);
xCtr=screenInfo.screenRect(3)/2;
yCtr=screenInfo.screenRect(4)/2;
width_fix=16;
fixation_but=0.5;

% Time setting
t_fix_begin=1;
t_feedback=0.75;
t_fix_end=1;
gap = 50;

% answer setting
rightKey='j';
leftKey='f';

% reward line parameters %%%
barSize=800;
xLeft = xCtr-barSize/2;
yBar = yCtr+50;
barHeight=20;
maxSum=2000; % Set maximum sum (greater than this sum, the reward line gets reset)
pixPerDollar=barSize/maxSum;
grid_int=200;
dollarGrid=0:grid_int:maxSum;
barSizePerDollarInPix=barSize/maxSum;
dollarGridInPix=dollarGrid.*barSizePerDollarInPix;

%%%%--------------------------------------------------------------------
%%%% setting input and output direction

% This would load dotInfo and inputs, 2 structural arrays from inputfile.

inputfile=['inputs/Reward_' subID '_SAT.mat'];
% Open up results file for writing subjects' behavioral results to file.
resultsfile=['data/Reward_' subID '_SAT_Color.txt'];
fid=fopen(resultsfile,'a');

load(inputfile);
nTrialsPB=inputs(blockNo).nTrialsPB;
slack = Screen('GetFlipInterval',screenInfo.curWindow)/2;

t_moneyOnset=inputs(blockNo).t_moneyOnset;
max_sv=max(inputs(1).sv);

% Wait for backtick signal to initiate the experiment. The MR console will send backtick signal once
% the scanning starts.
centerText(screenInfo.curWindow,['Block ' num2str(blockNo)],xCtr,yCtr,white)
centerText(screenInfo.curWindow,'Press 9 to begin',xCtr,yCtr+50,white)
Screen('Flip',screenInfo.curWindow);

while 1
    [tik,secs,keyCode]=KbCheck;
    if tik
        if strcmp(KbName(keyCode),'9(')||strcmp(KbName(keyCode),'9')
            break
        end
        while KbCheck;end
    end
end

% load output file. because want to get total_sum
% outputdir = [pwd '/data/'];
datafile = resultsfile;
data = load(datafile);
nPrevTrials=size(data,1);
if blockNo==1
    total_sum=0;
else
    total_sum= data(nPrevTrials,7);
end
rewLineTotal=mod(total_sum,maxSum);

%%%%--------------------------------------------------------------------
%%%% experiment start

for trialNo=1:nTrialsPB

    sv = inputs(blockNo).startValue(trialNo);
    slope=-sv/inputs(blockNo).trial_timeLimit(trialNo);
    
    Screen('Flip',screenInfo.curWindow);
    
    % draw yello fixation to alert subjects
    Start=mat2str(inputs(blockNo).startValue(trialNo));
    Screen(screenInfo.curWindow,'DrawLine',yellow,xCtr,yCtr-width_fix/2,xCtr,yCtr+width_fix/2,2);
    Screen(screenInfo.curWindow,'DrawLine',yellow,xCtr+width_fix/2,yCtr,xCtr-width_fix/2,yCtr,2);
    centerText(screenInfo.curWindow,[Start ' points'] ,xCtr,yCtr-50,yellow)
    
    t_fixStart=Screen(screenInfo.curWindow,'Flip');
    Screen(screenInfo.curWindow,'Flip',t_fixStart+t_fix_begin-slack);
     
    %%%%--------------------------------------------------------------------
    %%%% Show RDM stimulus and get response. !!!
    
    [chooseLeft,RT,choice] = sampling_SAT_Color_money_penalty(blockNo,trialNo,sv,fixation_but,max_sv);
    % if subject choose Left, chooseLeft is 1, in contrast, chooseLeft =0 means
    % his/her answer is Left.
    
    %%%%--------------------------------------------------------------------
    
    %% judgement  --- Determine if subjects made the correct response
    win=-1;
    
    % To know the subjects' answer.
    redLeft=inputs(blockNo).trial_redLeft(trialNo,1) ;
    if chooseLeft ~=-1
        if chooseLeft == redLeft
            chooseR=1;
        elseif chooseLeft ~= redLeft
            chooseR=0;
        end
    else
        chooseR=-1;
    end
    
    % To know the real answer.(Display feedback on winning.)
    if inputs(blockNo).trial_redDomi(trialNo,1) == 1
        correctIsR = 1;
    else
        correctIsR = 0;
    end
    
    % Whether he make response in this trial
    if chooseR~=-1
        % RT should less than maxTime
        curTime=(inputs(blockNo).trial_timeLimit(trialNo,1));
        if RT<=curTime+fixation_but
            % Compare real answer with subject's answer
            if chooseR == correctIsR
                if RT<=t_moneyOnset
                    win=sv;
                    correct=1;
                else
                    win=round(sv + slope*(RT-t_moneyOnset));
                    if win <0
                        win=0;
                    end
                    correct=1;
                end
                centerText(screenInfo.curWindow,['Correct: Get ' num2str(win) '  points!'],xCtr,yCtr,yellow)
            else
                win=-round(sv + slope*(RT-t_moneyOnset));
                if win > 0
                    win =0;
                end
                centerText(screenInfo.curWindow,['Wrong: Loss ' num2str(-win) '  points!'],xCtr,yCtr,white)
                correct=0;
            end
        else
            win=0;
            centerText(screenInfo.curWindow,['Too slow: Loss ' num2str(-win) '  points!'],xCtr,yCtr,white)
            correct=-1;
        end
    elseif chooseR==-1
        win=0;
        centerText(screenInfo.curWindow,['Too slow: Loss ' num2str(-win) '  points!'],xCtr,yCtr,white)
        correct=-1;
    end
    
    %% Display reward line.
    % accumulated points subjects got from the start of the experiment.
    total_sum=total_sum+win;
    % make the points become to reward line.
    % -if points more than 2000 points, the rewLineTotal will accumulate
    % point from zero, and subjects can get $40 us bonus.
    rewLineTotal=rewLineTotal+win;
    if rewLineTotal>maxSum
        rewLineTotal=rewLineTotal-maxSum;
        centerText(screenInfo.curWindow,'Congratulations!! $40 just deposited to your account',xCtr,yCtr-yCtr/2,yellow)
    end
    
    rewLineTotalInPix=round(rewLineTotal*pixPerDollar);
    if rewLineTotalInPix <0
        rewLineTotalInPix=0;
    end
    Screen('FillRect',screenInfo.curWindow,yellow,[xLeft yBar xLeft+rewLineTotalInPix yBar+barHeight]);
    
    % Draw dollar grid line and mark dollar in number on screen
    for grid=1:length(dollarGrid)
        centerText(screenInfo.curWindow,num2str(dollarGrid(grid)),xLeft+dollarGridInPix(grid),yBar+barHeight+20,white)
        Screen('DrawLine',screenInfo.curWindow,white, xLeft+dollarGridInPix(grid), yBar+barHeight, xLeft+dollarGridInPix(grid) ,yBar+barHeight-10, 1);
    end
    
    t_feedbackStart2=Screen(screenInfo.curWindow,'Flip');
    Screen(screenInfo.curWindow,'Flip',t_feedbackStart2+t_feedback-slack,1);
    
    % Draw the fixation let subject take rest
    t_end = t_fix_end;
    Screen(screenInfo.curWindow,'DrawLine',white,xCtr,yCtr-width_fix/2,xCtr,yCtr+width_fix/2,2);
    Screen(screenInfo.curWindow,'DrawLine',white,xCtr+width_fix/2,yCtr,xCtr-width_fix/2,yCtr,2);
    
    t_trial_end=Screen(screenInfo.curWindow,'Flip');
    Screen(screenInfo.curWindow,'Flip',t_trial_end+t_end-slack,1);
    
    % write results to file
    fprintf(fid,'%i\t %i\t %i\t %i\t %.4f\t %i\t %i\t %i\t %i\n',...
        blockNo,trialNo,buttonPress,chooseR,RT,win,total_sum,correct,chooseLeft);
end
%% check time in each block
TIme_you_spent_in_this_block=toc
Screen('CloseAll');
ShowCursor;

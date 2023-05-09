function inputs = createInputs_SAT_Color_money_v2(subID,t_riseFromChance,dec_slope)
%
%
% Sequential sampling task.
% SAT session.
%
% M2L_ratio (More to Less ratio). If M2L_ratio=6:4, then you need to enter [6 4]. you could
% also enter [0.6 0.4], or [60 40] because we are going to normalize them
% to probability anyway. Keep in mind that More can be either red or green.
%
%
%
% SWW.2013.
% CCT. 2013.01.03 for pilot (used version3, the evidence would remain on
% the screen
% CCT. 2014.02.14
% - use version 4
% - set t_riseFromChance as delay time for decreasing money


rseed = sum(100*clock);
rand('state',rseed);

sampleRate = 20; % in hertz. (how many samples to show per second)
nPointsAtOnce=sampleRate;

M2L_ratio=input('Pleas tell me the Ratio of red dots (ex~[60 40]) :');

inputfile = ['Reward_' subID '_SAT.mat'];

if exist(inputfile,'file')
    error('input file with this subject ID already exists')
end

%% parameters setting
nTrialsPerTime = 3; % the number of repeating condition in a block
nBlocks = 10;
M2L_ratio=repmat(M2L_ratio,nBlocks);
start_point=50:50:100;
% start_point=20:20:120;
n_start=length(start_point);
n_dec_slope=length(dec_slope);
count=0;
timeLimit=zeros(n_dec_slope,1);

%% time setting
for startNo=1:n_start
    for slopeNo=1:n_dec_slope
        count=count+1;
        slope=start_point(startNo)*dec_slope(slopeNo);
        time2zero=t_riseFromChance+(-start_point(startNo)/slope);
        
        % IMPORTANT:
        % - time2zero here means how long it takes from the time the money
        % start decreasing to the time it decreases to 0. This is computed
        % based on starting value and the decreasing slope.
        % - time2zero here added delay time for reward decreasing, so when
        % you run the experiment, don't forget make time circle disappear
        % wtih delay time!
        % -scheduleInfo= [start_point time2zero slope dec_slope]
        scheduleInfo(count,:)=[start_point(startNo) time2zero slope dec_slope(slopeNo)];
        timeLimit(slopeNo,1)=time2zero;
    end
end

% Dominanted Color. (1 = Red ; 0 = Green)
redDomi = [1 0]';
% The loaction of red choice .(1 = Left choice is Red ; 0 = Right choice is Red )
redLeft = [1 0]';
% number of timeLimit
n_timeLimit = length(timeLimit);
n_color = length(redDomi);
n_shift = length(redLeft);
% n trials per block
nTrialsPB = 36;
nTrialsPerSv=nTrialsPB/n_start;
nRepTimePerSv=nTrialsPerSv/n_timeLimit;
% n dominated color per time limit
nRepColorDomi = nTrialsPB/n_color;
% n red choice located on left per block
nRedLeftPB=nTrialsPB/n_shift;

%% create a row of parameter
vect_sv=sort(repmat(start_point',nTrialsPerSv,1));
vect_timeLimit = repmat(timeLimit,nRepTimePerSv*n_start,1);
vect_redDomi = repmat(redDomi,nRepColorDomi,1);
vect_redLeft= sort(repmat(redLeft,nRedLeftPB,1));
nSamplesMax = round(max(scheduleInfo(:,2))*sampleRate);
vect_samples = zeros(1,nSamplesMax);

for i=1:nBlocks
    inputs(i,1).t_moneyOnset=t_riseFromChance;
    inputs(i).nTrialsPB = nTrialsPB;
    inputs(i).timeLimit = timeLimit;
    inputs(i).redDomi = redDomi;
    inputs(i).sampleRate = sampleRate;
    inputs(i).redRatio = M2L_ratio(i,1);
    inputs(i,1).sv=start_point;
    
    %% size of aperture
    %according to Newsome, 1988. He puts the Random-dots in a circular
    %aperture (10¢X). so we use half of 10¢X to estimate diameter
    distance=60; % 60 cm from screen to eyes
    ap_diameter=tan(5*pi/180)*10*distance;
    inputs(i).apXYD = [0 0 ap_diameter];
    
    
    % want to randomize time limit
    randOrder = randperm(nTrialsPB);
    randColor= randperm(nTrialsPB);
    trial_sv=vect_sv(randOrder,1);
    randVect_timeLimit = vect_timeLimit(randOrder);
    % randomly shift red_choice
    randVect_redLeft = vect_redLeft(randColor,:);
    % want to randomize color dominance.
    randVect_redDomi = vect_redDomi(randColor,:);
    
    
%     sample_number=1:n_timeLimit*n_start;
%     sample_vector=repmat(sample_number',nTrialsPerTime,1);
%     rand_number=sample_vector(randperm(nTrialsPB));
    inputs(i).dec_slope=dec_slope;
    for j=1:nTrialsPB
        inputs(i).trial_redDomi(j,1) = randVect_redDomi(j);
        inputs(i).trial_timeLimit(j,1) = randVect_timeLimit(j);
        inputs(i).trial_redLeft(j,1) = randVect_redLeft(j);
        inputs(i).startValue(j,1) = trial_sv(j);
        % start drawing samples from the distribution.
        redCut = M2L_ratio(i,1)/sum(M2L_ratio(i,1:2));
        if inputs(i).trial_redDomi(j,1)==1
            inputs(i).trial_redRatio(j,1)=redCut;
        elseif inputs(i).trial_redDomi(j,1)==0
            inputs(i).trial_redRatio(j,1)=1-redCut;
        end
        
        nSamplesThisTrial = fix(inputs(i).trial_timeLimit(j,1)*sampleRate);
        sampleIsRed = rand(1,nSamplesThisTrial)<inputs(i).trial_redRatio(j,1);
        vect_samples(1:nSamplesThisTrial)=sampleIsRed;
        vect_samples(nSamplesThisTrial+1:nSamplesMax)=-1;
        inputs(i).trial_samples(j,:)=vect_samples;
        inputs(i).realRED(j,1)=sum(vect_samples(1:nSamplesThisTrial))/nSamplesThisTrial;
        
        %%    X and Y axis
        x_grid = -ap_diameter:5:ap_diameter;
        n_x = length(x_grid);
        y_grid = -ap_diameter:5:ap_diameter;
        n_y = length(y_grid);
        x_possible = reshape(repmat(x_grid,n_y,1),1,n_x*n_y);
        y_possible = repmat(y_grid,1,n_x);
        x_final = zeros(1,nSamplesThisTrial);
        y_final = zeros(1,nSamplesThisTrial);
        n_possible = length(x_possible);
        rand_indx_points = zeros(1,nSamplesThisTrial);
        rand_indx_points(1:nPointsAtOnce)=randsample(n_possible,nPointsAtOnce);
        
        for sampNo=1:nPointsAtOnce
            x_final(sampNo)=x_possible(rand_indx_points(sampNo));
            y_final(sampNo)=y_possible(rand_indx_points(sampNo));
        end
        % -to avoid dots ovelapping
        % -if dots overlapped, we can not promise each second has 20 dots on
        % the screen
        for sampleNo=nPointsAtOnce+1:nSamplesThisTrial
            while 1
                rand_indx_points_curr = randsample(n_possible,1);
                sum_same = sum(rand_indx_points_curr == rand_indx_points(sampleNo-1:-1:sampleNo-nPointsAtOnce+1));
                if sum_same==0
                    rand_indx_points(sampleNo)=rand_indx_points_curr;
                    x_final(sampleNo)=x_possible(rand_indx_points(sampleNo));
                    y_final(sampleNo)=y_possible(rand_indx_points(sampleNo));
                    break
                end
            end
        end
        
        
        randSample_radius_x=x_final;
        randSample_radius_y=y_final;
        vect_radius_x=randSample_radius_x;
        vect_radius_y=randSample_radius_y;
        
        vect_radius_x(nSamplesThisTrial+1:nSamplesMax)=-1;
        vect_radius_y(nSamplesThisTrial+1:nSamplesMax)=-1;
        
        inputs(i).trial_x_shift(j,:) = round(vect_radius_x);
        inputs(i).trial_y_shift(j,:) = round(vect_radius_y);
        
       
        %         trial_slope=scheduleInfo(what_order,3);
        %         trial_normSlope=scheduleInfo(what_order,4);
        
        %         inputs(i,1).slope(j,1)=trial_slope;
        %         inputs(i,1).norm_slope(j,1)=trial_normSlope;
    end
    %% To figure out whether the pairs of parameters are psudorandomly assigned in the task
    [c ind]=sort(inputs(i).startValue);
    show_Pair_TimeDomiShif=[inputs(i).trial_redDomi(ind) inputs(i).trial_timeLimit(ind) inputs(i).trial_redLeft(ind) inputs(i).startValue(ind)];
    inputs(i).Pair_TimeDomiShif=show_Pair_TimeDomiShif;
end

inputs(3).Pair_TimeDomiShif
save(inputfile,'inputs');



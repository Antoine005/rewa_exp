function mean_of_deviation = analyze_deviationRT_optimal_actual(subID)

fileSchedule = fullfile('reward_schedule', sprintf('rewSchedule_%s_panelty.mat', subID));
fileData = fullfile('data', sprintf('Reward_%s_SAT_Color.txt', subID));
fileInput = fullfile( 'inputs', sprintf('Reward_%s_SAT.mat', subID));

load(fileSchedule);
data = load(fileData);
load(fileInput);

nBlock = 10;
nTrial = 36;

allTimeLimit = [];
allRT_actual = zeros(nBlock*nTrial, 1);
allChoice = zeros(nBlock*nTrial, 1);
n = 0;
for b = 1:nBlock
    
    [timeLimit, index, type] = unique(inputs(b).trial_timeLimit);
    allTimeLimit = [allTimeLimit; type];
    
    for t = 1:nTrial
        n = n + 1;        
        idx = ((data(:,1)==b)&(data(:,2)==t));
        allRT_actual(n, 1) = data(idx, 5);
        allChoice(n, 1) = data(idx, 8);
    end
    
end
allRT_optimal = finalist(allTimeLimit, 3);
idx_valid = (allChoice~=-1);
t_valid = find(idx_valid);

deviation = allRT_actual - allRT_optimal;

allData(:,1) = allRT_actual(idx_valid);
allData(:,2) = allRT_optimal(idx_valid);
allData(:,3) = deviation(idx_valid);

% plot(t_valid, deviation, 'bo');


%% Categoried by reward schedule
optimalT_order = unique(allRT_optimal);
count = zeros(1,6);
for optT = 1:6
    for i = 1:length(allData(:,1))
        if allData(i,2) == optimalT_order(optT)
            count(optT) = count(optT) + 1;
            sepData(count(optT),optT) = allData(i,3);
        end
    end
end
mean_of_deviation = mean(sepData);
        
% hold on;
% plot(t_valid, deviation, 'r');
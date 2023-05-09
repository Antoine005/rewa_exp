<Session_2_dots_test>

-------------------------
How to run the experiment
-------------------------

-Create inputs
 1.create inputs by using "inputs/createInputs_SAT_Color_v2.m"
 2.createInputs_SAT_Color_v2(subID,pretest)

-Execute experiment
 3.execute run_SAT_ColorPenalty(subID,blockNo,pretest)

** if you want to run for test session, pretest =0

trials = 36 trials X 10 blocks




--------------------
Preliminary analysis
--------------------

-estimate SAT function and produce reward schedule for later sessions
1. go to folder "analysis
2. First time you run "getMoneyParams_Colorpain_lottery(subID,funcForm,max_probC)", please set funcForm =1 and max_probC = 1
3. open the mat file "rewSchedule_subID_panelty"
4. Second time you run it, funcForm = 1; max_probC = the last number in pC_afo_t
5. Then, produce reward schedule for lottery session. run "getMoneyParams_Colorpain_lottery(subID,funcForm,max_probC)", please set funcForm =1 and max_probC = max_probC = the last number in pC_afo_t




--------------------
Experiment variables
--------------------

"inputs" folder : parameters
"data"   folder : recoding data

In the input folder, each mat file is used for each subject's inputs.
Each mat file is 10*1 structure array and each row is used for each block.

---------- Introduction for inputs variables ----------

nTrialsPB         : number of tiral per block
timeLimit         : duration for showing sampled-dots and time limitation for making response (s)  
redDomi           : the dominated color is red or not (1 = red dominated)
sampleRate        : the frequency of showing sampled dots (Hz) (20Hz = 50ms/dots)
redRatio          : ratio = red : green (each block used different ratio)
apXYD             : the size of aperture (degree) 
trial_redDomi     : the dominated color is red or not (1 = red dominated) for each trials.
trial_timeLimit   : the duration for showing dots and time limitation for making response for each trials.
trial_redLeft     : the location of two color options (1 = red located on left) for each trials.
Pair_TimeDomiShif : all used combination of "trial_timeLimit", "trial_redDomi", "trial_redLeft"
trial_redRatio    : ideal_red_dot_number/ideal_all_dot_number, for each trials
trial_samples     : 36 trials * 70 dots color (maximun dots is 70 dots (3.5s * 20Hz)), 1 = red, 0 = green, -1 = no sampling
realRED           : sampling_red_dot_number/sampling_all_dot_number, computed from sampling, for each trials
trial_x_shift     : defined the coordinate for dots (x-axis)
trial_y_shift     : defined the coordinate for dots (y-axis)

---------- Introduction for output data ----------

1,       2,       3,           4,            5,  6,               7,                  8,       9       
blockNo, trialNo, buttonPress, choosing_Red, RT, feedback_points, accumulated_points, correct, choosing_Left

blockNo            : current block number
trialNo            : current trial number under current block
buttonPress        : whether button is pressed, 1 for button pressed, 0 for button not pressed. (bug: not reflecting real button pressing)
choosing_Red       : 1 for choosing red dot; 0 for choosing green dot; -1 for no response
RT                 : reaction time of subjects' judgement
feedback_points    : win points for correct judgement, loss points for wrong judgement
accumulated_points : cumulated points until current trials
correct            : 1 for correct answer; 0 for wrong answer; -1 for no response
choosing_left      : 1 for choosing left option; 0 for choosing right option; -1 for no response















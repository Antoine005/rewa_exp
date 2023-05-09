function dotInfo = my_createDotInfo
% dotInfo = createDotInfo(inputtype)
% creates the default dotInfo structure. inputtype is 1 for using keyboard,
% 2 for using touchscreen/mouse
% saves the structure in the file dotInfoMatrix or returns it

% created June 2006 MKMK

mfilename

%dotInfo.cohSet = [0.256, 0.512];
%dotInfo.cohSet = [0, 0.032, 0.064, 0.128, 0.256, 0.512];
dotInfo.cohSet = [0.128];
% left and right are the only directions that make sense for keypress
% experiment at the moment.
% For the keypress experiment, the first number will be associated with the
% left arrow, the second with the right arrow. (0 degrees is to the right)

% direction set containing all possible directions 
dotInfo.dirSet = [45];
%dotInfo.dirSet = [90, 270];

% to have more than one set of dots, all of these must have information for
% more than one set of dots: aperture, speed, coh, direction, maxDotTime
dotInfo.numDotField = 1;
dotInfo.apXYD = [0 50 50];  % aperture. third element is diameter of the aperture
dotInfo.speed = 50; % in what unit?
dotInfo.coh = dotInfo.cohSet(ceil(rand*length(dotInfo.cohSet)))*1000;   % Randomly pick one coherence level from dotInfo.cohSet
dotInfo.dir = dotInfo.dirSet(ceil(rand*length(dotInfo.dirSet)));    % randomly pick one direction from dotInfo.dirSet
dotInfo.maxDotTime = 2; %how long the RDM would appear in a trial.
dotInfo.dotColor = [255 255 255]; % white dots default
dotInfo.dotSize = 2;    % dot size in pixels
dotInfo.maxDotsPerFrame = 150;   % by trial and error.  Depends on graphics card
% Use test_dots7_noRex to find out when we miss frames.
% The dots routine tries to maintain a constant dot density, regardless of
% aperture size.  However, it respects MaxDotsPerFrame as an upper bound.
% The value of 53 was established for a 7100 with native graphics card.

save my_keyDotInfoMatrix dotInfo


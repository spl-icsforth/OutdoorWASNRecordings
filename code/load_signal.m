function [in, sourceXYs,DOAs, sensorXYs] = load_signal(Speakers,Locations)
% Loads the signals of specific speakers at specific locations. 
% e.g., load_signal(1,5) loads the signal of speaker S01 at location L05.
% For multiple sources, variables Speakers and Locations can be vectors
% indicating the active speakers at the corresponding locations. The
% signals are then added to emulate multiple source scenarios. 
% e.g., load([4 5],[1 2]) loads a signal with two active sources: speaker
% S04 at location L01 and speaker S05 at location L02. 
% 
% Output:
%       in: A 4 x 1 cell array where each element is the 8-channel recording from each microphone array (A01, ... , A04)
%       sourceXYs: The true source locations. Each row contains the x and y coordinates of an active source 
%                  (the sources are located at the locations specified in variable  Locations)
%       DOAs:      The true DOAs of the sources.  The element at (i,j) specifies the DOA of the source j 
%                  (whose location is specified in variable Locations) with respect to microphone array i
%       sensorXYs: Microphone array locations. Each row contains the x and
%                   y coordinates of the microphone arrays A01 to A04
%All locations are measured in cm and all angles are measured in degrees. 

nSpeakers = length(Speakers);
nArrays = 4;

sigs = cell(nSpeakers,1);
Len = zeros(nSpeakers,nArrays);

for iSpeaker=1:length(Speakers)
    for iArray = 1:nArrays 
        sigs{iSpeaker}{iArray} = audioread(['../audio/A0' int2str(iArray) filesep 'L0' int2str(Locations(iSpeaker)) '_S0' int2str(Speakers(iSpeaker)) '.wav']);
        Len(iSpeaker,iArray) = length(sigs{iSpeaker}{iArray});        
    end
end

minLen = min(min(Len));

in{1} = sigs{1}{1}(1:minLen,:);
in{2} = sigs{1}{2}(1:minLen,:);
in{3} = sigs{1}{3}(1:minLen,:);
in{4} = sigs{1}{4}(1:minLen,:);

for iSpeaker=2:nSpeakers
    for iArray = 1:nArrays
        in{iArray} = in{iArray} + sigs{iSpeaker}{iArray}(1:minLen,:);
    end
end

sourceXYs = [50 50;
    100 150;
    200 200
    150 250
    200 100
    300 150
    200 350];

sensorXYs = [200 0 ; 400 200; 200 400; 0 200];
for i=1:size(sourceXYs,1)
    for j=1:size(sensorXYs,1)
        angles(i,j) = GenTrueDOAsForSourcePosition(sourceXYs(i,:),sensorXYs(j,:));
    end
end

sourceXYs = sourceXYs(Locations,:);
DOAs = angles(Locations,:).';

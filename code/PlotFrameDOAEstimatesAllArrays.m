function PlotFrameDOAEstimatesAllArrays(DOAEstimates, NumSourcesEstimates, DOAs)
%Plots the DOA estimates for each source and each array along with the ground truth DOA
%estimates. The estimates of each array are plotted using different colors, where the solid lines correspond 
%to the true DOA estimates and the x's correspond to the estimated DOAs at
%each time frame. 
%Input:
%   DOAEstimates: 4 x 1 cell array where each element (one for each array) is a cell array
%   containing the DOA estimates for each time frame
%   NumSourcesEstimates: 4 x1 cell array where each element (one for each
%   array) is a array with the estimated number of active sources for each
%   time frame. 
%   DOAs: The true sources' DOAs. Each column contains the DOAs of a source
%   with respect to each microphone array. 

figure;
hold on;
nArrays = size(DOAEstimates,1);
Nsteps = length(DOAEstimates{1});
Colors = {'b' 'r' 'g' 'black', 'm','c'};
for istep=1:Nsteps
    for ar = 1:nArrays
        plot(repmat(istep,size(DOAEstimates{ar}{istep}(1:NumSourcesEstimates{ar}(istep)))), DOAEstimates{ar}{istep}(1:NumSourcesEstimates{ar}(istep)),'x','Color',Colors{ar});
    end
end

DOAs = DOAs';
for iSource = 1:size(DOAs,1)
    for ar=1:nArrays
        l = line([1 Nsteps],[DOAs(iSource,ar) DOAs(iSource,ar)]);
        set(l,'Color',Colors{ar});
    end
end

ylim([0 360]);
ylabel('DOA (degree)');
xlabel('Frame index');


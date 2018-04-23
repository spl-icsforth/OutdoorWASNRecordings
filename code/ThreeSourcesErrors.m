function  [RMSE_per_location,OverallRMSE] = ThreeSourcesErrors(toload)
%Calculates the RMSE for each location combination and the overall RMSE for the
%three sources case.
%Input:
%   toload: the folder with the .mat files of the results of the three sources case

locations = combnk(1:7,3);
num_locations = size(locations,1);

ErrorAll = []; %error of all location combinations, all speakers, all time frames. To be used to calculate the overall RMSE 
cnt2 = 1;

RMSE_per_location = zeros(num_locations,1);  %the RMSE for each location combination taking into account all speakers and all time frames 

for l = 1:num_locations
    
    loc = locations(l,:);
    
    cnt = 1;
     Error = []; %error of all time-frames at a specific location combination. To be used to calculate the RMSE for each location pair
    
    load([toload filesep 'L_' int2str(loc(1)) '_' int2str(loc(2)) '_' int2str(loc(3)) '.mat'],'EstLocations','sourceXYs');
    
    for istep=1:length(EstLocations)
        estimatesXYs = EstLocations{istep};
        if size(estimatesXYs,1) == 3  %three sourcs are estimated
            Error(istep) = getErrorThreeByThreeEstimates(sourceXYs,estimatesXYs);
            ErrorAll(cnt2) = Error(cnt);
        elseif size(estimatesXYs,1) == 2 %two sources are estimated
            Error(istep) = getErrorTwoOutOfThreeEstimates(sourceXYs,estimatesXYs);
            ErrorAll(cnt2) = Error(cnt);
        elseif size(estimatesXYs,1) == 1 %one source is estimated
            Error(istep) = getErrorOneOutOfThreeEstimates(sourceXYs,estimatesXYs);
            ErrorAll(cnt2) = Error(cnt);
        else
            Error(istep) = NaN;
            ErrorAll(cnt2) = NaN;
        end

        cnt = cnt + 1;
        cnt2 = cnt2 + 1;

    end

    RMSE_per_location(l) = sqrt(nanmean(Error));
    
end

OverallRMSE = sqrt(nanmean(ErrorAll));

end
function err = getErrorOneOutOfThreeEstimates(sourceXYs,estimatesXYs)

assert(size(estimatesXYs,1) == 1);

LocationEstimates = repmat(estimatesXYs,3,1);

err = getErrorThreeByThreeEstimates(sourceXYs,LocationEstimates);
end

function err = getErrorTwoOutOfThreeEstimates(sourceXYs, estimatesXYs)

assert(size(estimatesXYs,1) == 2);

LocationEstimates1 = [estimatesXYs ; estimatesXYs(1,:)];
LocationEstimates2 = [estimatesXYs ; estimatesXYs(2,:)];

err1 = getErrorThreeByThreeEstimates(sourceXYs,LocationEstimates1);
err2 = getErrorThreeByThreeEstimates(sourceXYs,LocationEstimates2);

err = min([err1 err2]);
end


function err = getErrorThreeByThreeEstimates(sourceXYs,estimatesXYs)

uniqueEstimates = estimatesXYs; 
numEstimates = size(uniqueEstimates,1);

assert(numEstimates == 3);

combs = npermutek(1:numEstimates,3);

idx = [];
for i=1:size(combs,1)
    if length(unique(combs(i,:))) == 3
        idx = [idx i];
    end
end

combs = combs(idx,:);

TrueLoc1 = sourceXYs(1,:);
TrueLoc2 = sourceXYs(2,:);
TrueLoc3 = sourceXYs(3,:);

error = zeros(size(combs,1),1);
for i=1:size(combs,1)
    error(i) = norm(TrueLoc1 - uniqueEstimates (combs(i,1),:)).^2+ ...%
        norm(TrueLoc2 - uniqueEstimates(combs(i,2),:)).^2+ ... %
        norm(TrueLoc3 - uniqueEstimates(combs(i,3),:)).^2;  %
    
    error(i) = error(i)/3;
end
err = min(error);
end


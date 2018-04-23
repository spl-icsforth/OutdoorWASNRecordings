function  [RMSE_per_location,OverallRMSE] = TwoSourcesErrors(toload)
%Calculates the RMSE for each location pair and the overall RMSE for the
%two sources case. 
%Input:    
%   toload: the folder with the .mat files of the results of the two sources case 

locations = combnk(1:7,2);
num_locations = size(locations,1);

ErrorAll = []; %error of all location pairs, all speakers, all time frames. To be used to calculate the overall RMSE 
cnt2 = 1;

RMSE_per_location = zeros(num_locations,1);  %the RMSE for each location pair taking into account all speakers and all time frames 
for l = 1:num_locations %for each location pair
    
    loc = locations(l,:);
    
    cnt = 1; 
    Error = []; %error of all time-frames at a specific location pair. To be used to calculate the RMSE for each location pair
    
    load([toload filesep 'L_' int2str(loc(1)) '_' int2str(loc(2)) '.mat'],'EstLocations','sourceXYs');
    
    for istep=1:length(EstLocations)
        if ~isempty(EstLocations{istep}) %some location estimates maybe be empty because the DOAs were out of range
            Error(cnt) = getErrorTwoByTwoEstimates(sourceXYs,EstLocations{istep});
            ErrorAll(cnt2) = Error(cnt);
        else
            Error(cnt) = nan;
            ErrorAll(cnt2) = nan;
        end
        cnt = cnt + 1;
        cnt2 = cnt2 + 1;
    end
   
    RMSE_per_location(l) = sqrt(nanmean(Error)); 
end

OverallRMSE = sqrt(nanmean(ErrorAll));

end


function err = getErrorTwoByTwoEstimates(sourceXYs,estimatesXYs)
TrueLoc1 = sourceXYs(1,:);
TrueLoc2 = sourceXYs(2,:);

EstLoc1 = estimatesXYs(1,:);
EstLoc2 = estimatesXYs(2,:);

error1 = norm( TrueLoc1 - EstLoc1).^2 + norm(TrueLoc2 - EstLoc2).^2;
error2 = norm( TrueLoc1 - EstLoc2).^2 + norm(TrueLoc2 - EstLoc1).^2;

error1 = error1/2;
error2 = error2/2;

err = min([error1 error2]);

end

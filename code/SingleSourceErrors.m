function [RMSE_per_location,OverallRMSE] = SingleSourceErrors(toload)
%Calculates the RMSE for each location and the overall RMSE for the single
%source case. 
%Input:    
%   toload: the folder with the .mat files of the results of the single source case 


ErrorAll = []; %error of all locations, all speakers, all time frames. To be used to calculate the overall RMSE 
cnt2 = 1;

RMSE_per_location = zeros(7,1);  %the RMSE for each location taking into account all speakers and all time frames 
for loc = 1:7  %for all locations 
    
    cnt = 1;
    Error = []; %error of all speakers, all time-frames at a specific location. To be used to calculate the RMSE for each location
    for spk = 1:5  %for all speakers
        
        if spk == 2  && loc==1, continue; end %speaker S02 not available for location L1
        if spk == 1  && loc==2, continue; end %speaker S01 not available for location L2
        
        load([toload filesep 'L0' int2str(loc) '_S0' int2str(spk) '.mat'],'EstLocations','sourceXYs');
        
        for istep=1:length(EstLocations)
            if ~isempty(EstLocations{istep}) %the locations estimates of the first frames are empty due to DOA initialization time  
                Error(cnt) = norm( EstLocations{istep} - sourceXYs).^2;   
                ErrorAll(cnt2) = Error(cnt);
            else
                Error(cnt) = nan;
                ErrorAll(cnt2) = nan;
            end
            cnt = cnt + 1;
            cnt2 = cnt2 + 1;
        end
        
    end
    
    RMSE_per_location(loc) = sqrt(nanmean(Error));
    
end

OverallRMSE = sqrt(nanmean(ErrorAll));

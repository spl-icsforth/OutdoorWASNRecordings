function trueDOAs = GenTrueDOAsForSourcePosition(sourceXYs,sensorXYs)
%Calculate the DOAs of the sources in sourceXYs with respect to the
%microphone arrays in sensorXYs.
%Input:     
%       sourceXYs: The sources locations. Each row contains the x and y
%                  coordinates of a source
%       sensorXYs: Microphone array locations. Each row contains the x and
%                  y coordinates of a microphone array 
%Output:
%       trueDOAs: DOAs of the sources. Each row contains the DOAs of a
%                 source with respect to the microphone arrays 


M = size(sensorXYs,1); %number of mic arrays
P = size(sourceXYs,1); %number of sources

trueDOAs = zeros(P,M);

X = 1;
Y = 2;

for i=1:P
    for j=1:M
        an = rad2deg(atan2(sourceXYs(i,Y) - sensorXYs(j,Y), sourceXYs(i,X) - sensorXYs(j,X)));
        if an<0
            an = an + 360;
        end
        trueDOAs(i,j) = an;
    end
end

end
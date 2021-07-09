%%
% HCCMiner.
% Copyright (C) 2021 U. Klinge, A. Dievernich, J. Stegmaier
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the Liceense at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
% Please refer to the documentation for more information about the software
% as well as for installation instructions.
%
% If you use this application for your work, please cite the repository and one
% of the following publications:
%
% TBA
%
%%

function [] = callback_hccminer_fuse_tile_projects(inputFolder, outputFileName, overviewMask)

%% parse the input folder
inputFiles = dir([inputFolder '*.csv']);
classIdIndex = 13;

%% toggle debug figures
debugFigures = false;
if (debugFigures == true)
    figure(3); clf;
    imagesc(overviewMask); hold on;
end

%% determine the number of data points
disp('Determining number of data points ...');
numDataPoints = 0;
numTiles = length(inputFiles);
tileFeatures = cell(numTiles, 1);

for i=1:numTiles
    tileFeatures{i} = dlmread([inputFolder inputFiles(i).name], ';', 1, 0);
    numDataPoints = numDataPoints + size(tileFeatures{i}, 1);
end
numFeatures = size(tileFeatures{1},2)+1;

%% initialize d_org
d_org = zeros(numDataPoints, numFeatures);

%% initialize global displacement and matchin parameters
globalDisplacement = [0, 0];
performTopAlignment = false;
nnMaxRatio = 0.1;
maxShift = 10; %% the basic maximum shift used for tile displacement search. If no suitable transformation is found factors of 1:5 are also tried iteratively.
minPoints = 20; %% the minimum number of points in an overlap region to avoid degenerate cases where only one point overlaps.
    
%% successively add all csv files
disp('Fusing tile projects ...');
currentIndex = 1;
numDataPoints = 0;
for i=1:length(inputFiles)
    
    %% set the current tile displacement to zero
    minDisplacement = [0, 0];
    
    %% load the current csv file and adjust the indices to match the global array position
    currentTileFeatures = tileFeatures{i};
    currentTileFeatures = currentTileFeatures(currentTileFeatures(:,1) > 0, :);
    currentTileFeatures(:,1) = currentIndex:(currentIndex+size(currentTileFeatures, 1)-1);
    if (isempty(currentTileFeatures))
        continue;
    end
    
    %% apply previous global transformation to the current tile
    currentTileFeatures(:,3) = currentTileFeatures(:,3) - globalDisplacement(1);
    currentTileFeatures(:,4) = currentTileFeatures(:,4) - globalDisplacement(2);
    
    %% convert the tile indices to grid positions 
    positionGridPrev = callback_hccminer_get_position_from_index(i-1, overviewMask);
    positionGridCurr = callback_hccminer_get_position_from_index(i, overviewMask);
    positionAboveIndex = callback_hccminer_get_index_from_position(positionGridCurr - [1,0], overviewMask);
    positionGridAbove = callback_hccminer_get_position_from_index(positionAboveIndex, overviewMask);
    
    positionDist = inf;
    if (~isempty(positionGridPrev))
        
        %% compute the size of the jump to the next tile and only align immediate neighbors
        positionDiff = (positionGridCurr - positionGridPrev);
        positionDist = norm(positionDiff);
        
        %% identify the current center element for vertical alignment
        currentLine = positionGridCurr(1);
        lineIndices = find(overviewMask(currentLine, :) > 0);
        centerElement = lineIndices(round(length(lineIndices)/2));
        if (i > 1 && positionGridCurr(2) == centerElement)
            performTopAlignment = true;
        else
            performTopAlignment = false;
        end
        
        %% plot progress on the mask image
        if (debugFigures == true)
            figure(3);
            plot(positionGridPrev(2), positionGridPrev(1), '.r');
            plot(positionGridCurr(2), positionGridCurr(1), 'og');

            if (~isempty(positionGridAbove))
                plot(positionGridAbove(2), positionGridAbove(1), '*b');
            end
            
            if (positionDiff(1) >= 1)
                disp('Top-bottom transition detected');
            elseif (positionDiff(2) >= 1)
                disp('Left-right transition detected');
            elseif (positionDiff(2) <= -1)
                disp('right-left transition detected');
            end
        end
    end
    
    %%%%%%%%%%% PERFORM ALIGNMENT %%%%%%%%%%%
    if (i > 1 && positionDist <= 1)
        
        %% find the indices of the previous tile
        previousIndices = d_org(1:(currentIndex-1), end) == i-1;
        
        %% find the alignment of the current and the previous
        alignmentPositionsPrevious = d_org(previousIndices, 3:4);
        if (~isempty(alignmentPositionsPrevious))
            
            %% successively increase search radius and stop as soon as a suitable transformation is found
            for j=1:3
                [minDisplacement, minDistance] = find_alignment(alignmentPositionsPrevious, currentTileFeatures(:,3:4), maxShift*j, minPoints);
                if (minDistance < nnMaxRatio)
                   break; 
                end                
            end
            
            %% if even the maximum search range did not find a suitable displacement, better do nothing...
            if (minDistance > nnMaxRatio)
                disp('Likely misalignment found!!');
                minDisplacement = [0, 0];
            end
            
            %% plot current alignment if enabled
            if (debugFigures == true)
                figure(2); clf; hold on;
                plot(alignmentPositionsPrevious(:,1) - minDisplacement(1), alignmentPositionsPrevious(:,2) - minDisplacement(2), 'or');
                plot(currentTileFeatures(:,3), currentTileFeatures(:,4), '.g');
                set(gca, 'YDir', 'reverse');
                title([num2str(minDisplacement) ', length = ' num2str(norm(minDisplacement)) ', nnRatio = ' num2str(minDistance)]);
            end
        end
        
        %% update the global alignment and all previous positions to match the current tile
        globalDisplacement = globalDisplacement - minDisplacement;
        d_org(1:(currentIndex-1), 3) = d_org(1:(currentIndex-1), 3) - minDisplacement(1);
        d_org(1:(currentIndex-1), 4) = d_org(1:(currentIndex-1), 4) - minDisplacement(2);
        
        %% perform a vertical correction for each line using the central tile (which is more likely to contain useful structures)
        if (~isempty(positionAboveIndex) && performTopAlignment == true)
            
            %% find the indices of the tile above the current one
            topIndices = d_org(1:(currentIndex-1), end) == positionAboveIndex;
            
            %% find the alignment of the current and the previous
            alignmentPositionsTop = d_org(topIndices, 3:4);
            if (~isempty(alignmentPositionsTop))

                %% successively increase search radius and stop as soon as a suitable transformation is found
                for j=1:5            
                    [minDisplacement, minDistance] = find_alignment(alignmentPositionsTop, currentTileFeatures(:,3:4), maxShift*j, minPoints);
                    if (minDistance < nnMaxRatio)
                        break;
                    end
                end

                %% if even the maximum search range did not find a suitable displacement, better do nothing...
                if (minDistance > nnMaxRatio)
                    disp('Likely misalignment found!!');
                    minDisplacement = [0, 0];
                else
                    performTopAlignment = false;
                end
                
                %% plot current alignment if enabled
                if (debugFigures == true)
                    plot(alignmentPositionsTop(:,1) - minDisplacement(1), alignmentPositionsTop(:,2) - minDisplacement(2), 'ob');
                    plot(currentTileFeatures(:,3), currentTileFeatures(:,4), '.g');
                    set(gca, 'YDir', 'reverse');
                    title([num2str(minDisplacement) ', length = ' num2str(norm(minDisplacement)) ', nnRatio = ' num2str(minDistance)]);
                end
                
                %% find out which previous tiles to update!
                currentLine = positionGridCurr(1);
                for j=i:-1:1
                   [positionGridTemp] = callback_hccminer_get_position_from_index(j, overviewMask);
                   
                   if (currentLine > positionGridTemp(1))
                        %% globalDisplacement = globalDisplacement - minDisplacement; %% ????
                        validIndices = d_org(1:(currentIndex-1), end) <= j;
                        d_org(validIndices, 3) = d_org(validIndices, 3) - minDisplacement(1);
                        d_org(validIndices, 4) = d_org(validIndices, 4) - minDisplacement(2);
                        break;
                   end                   
                end
            end
        end
    end
    
    %% increment number of data points
    numDataPoints = numDataPoints + size(currentTileFeatures, 1);
    
    %% add current detections to d_org
    d_org(currentIndex:(currentIndex+size(currentTileFeatures)-1),1:(numFeatures-1)) = currentTileFeatures;
    d_org(currentIndex:(currentIndex+size(currentTileFeatures)-1),numFeatures) = i;
    currentIndex = currentIndex + size(currentTileFeatures, 1);
    
    %% plot complete point cloud if enabled
    if (debugFigures == true)
        figure(4); clf;
        scatter(d_org(1:currentIndex, 3), d_org(1:currentIndex, 4), 5, d_org(1:currentIndex, end), 'filled');
        set(gca, 'YDir', 'reverse'); axis equal;
    end

    %% display status
    disp(['Finished processing ' num2str(i) ' / ' num2str(length(inputFiles)) ' tiles ...']);
end

%% get the variable names
fileID = fopen([inputFolder inputFiles(1).name]);
specifierLine = fgetl(fileID);
specifiers = strsplit(specifierLine, ';');
dorgbez = char(specifiers);
for i=1:size(dorgbez, 1)
    dorgbez(i,:) = strrep(dorgbez(i,:), '_', '-');
end
dorgbez = char(dorgbez, 'TileIndex');

%% get rid of temporary d_org entries
d_org = d_org(1:numDataPoints, :);

%% initialize the code variables
code = ones(numDataPoints, 1);
code_alle = ones(numDataPoints, 2);
code_alle(:,2) = d_org(1:numDataPoints, classIdIndex) + 1;
bez_code = char('All', 'Normal vs. Tumor');

%% initialize the output variable names
zgf_y_bez = struct();
zgf_y_bez(1,1).name = 'All';
zgf_y_bez(2,1).name = 'Normal';
zgf_y_bez(2,2).name = 'Tumor';

%% save the project
save(outputFileName, 'd_org', 'code', 'code_alle', 'dorgbez', 'bez_code', 'zgf_y_bez', '-v7.3', '-nocompression');

% %% directly load the generated project
% result = questdlg('Directly load generated project?', 'Load project?');
% if (strcmp(result, 'Yes'))
%     next_function_parameter = outputFileName;
%     ldprj_g;
% end
end

%% function to compute a good alignment between two point clouds
function [minDisplacement, minDistance, nnRatio] = find_alignment(fixedPositions, movingPositions, maxShift, minPoints)
    
    %% initialize temporary variables
    minDisplacement = [0, 0];
    minDistance = inf;
   
    %% perform exhaustive search of the best translation            
    for j=-maxShift:1:maxShift
        for k=-maxShift:1:maxShift

            %% temporarily shift the current positions
            currentPositions = [movingPositions(:,1)+j, movingPositions(:,2)+k];

            %% find the minimum and maximum positions
            minX = min(currentPositions(:,1));
            minY = min(currentPositions(:,2));
            maxX = max(currentPositions(:,1));
            maxY = max(currentPositions(:,2));

            %% determine overlapping detections
            validPositions = fixedPositions(:,1) > minX & fixedPositions(:,1) < maxX & fixedPositions(:,2) > minY & fixedPositions(:,2) < maxY;

            %% skip if not enough points are contained in the overlapping region
            if (sum(validPositions) < minPoints)
                continue;
            end
            
            %% only use the overlapping positions for distance computations
            existingPositions = fixedPositions(validPositions,:);

            %% find the two nearest neighbors for each point
            [~, nnDistances] = knnsearch(currentPositions, existingPositions, 'K', 2);
            
            %% compute the nearest neighbor ratio and update the optimum if better than before
            nnRatio = nnDistances(:,1) ./ nnDistances(:,2);
            if (median(nnRatio) < minDistance)
                minDistance = median(nnRatio);
                minDisplacement = [j, k];
            end
        end
    end
end
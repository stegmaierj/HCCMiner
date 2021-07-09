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

function [] = callback_hccminer_extract_tile_features(inputFolder, outputFolder, overviewMask)

    %% input filters
    klingeProject = false;
    if (klingeProject == false)
        inputFilter{1} = '43HE';
        inputFilter{2} = '46HE';
        inputFilter{3} = '47Cy';
        inputFilter{4} = '50Cy';
        inputFilter{5} = '96HE';    %% DAPI channel
        inputFilter{6} = 'Cy7E';
    else
        inputFilter{1} = '46HE';
        inputFilter{2} = '47Cy';
        inputFilter{3} = '50Cy';
        inputFilter{4} = '64HE';
        inputFilter{5} = '96HE';    %% DAPI channel
        inputFilter{6} = 'Cy7E';
    end
    
    
    dapiChannelIndex = 5;
    numChannels = length(inputFilter);
    featureNames = 'id;area;xpos;ypos;circularity;eccentricity;equivDiameter;extent;minorAxisLength;majorAxisLength;perimeter;solidity;classId';
    for k=1:numChannels
        featureNames = [featureNames ';meanIntensity_' inputFilter{k} ';meanIntensity25PctMax_' inputFilter{k} ';maxIntensity_' inputFilter{k} ';stdIntensity_' inputFilter{k}]; %#ok<AGROW>
    end

    

    %% specify the input folder and enumerate files belonging to the DAPI channel
    tempOutputFolder = [outputFolder 'Processing\'];
    resultsFolder = [outputFolder 'Results\'];
    if (~exist(tempOutputFolder, 'dir')); mkdir(tempOutputFolder); end
    if (~exist(resultsFolder, 'dir')); mkdir(resultsFolder); end
    inputFiles = dir([inputFolder '*_' inputFilter{dapiChannelIndex} '.tif']);
    numTiles = length(inputFiles);

    %% loop through all regions and successively analyze all patches
    parfor i=1:numTiles
        
        %% perform classification based on the position of the tile on the annotation
        [positionGrid] = callback_hccminer_get_position_from_index(i, overviewMask);
        currentClass = overviewMask(positionGrid(1), positionGrid(2)); %% TODO: add possibility to mark tumor region on the input patch

        cropResolution = [1195, 892];
        rawImagePositionX = (positionGrid(2)-1)*cropResolution(1) + 1;
        rawImagePositionY = (positionGrid(1)-1)*cropResolution(2) + 1;
        
        tempInputFile = [tempOutputFolder 'tempInputImage_' sprintf('%04d', i) '.tif'];
        tempResultFile = [tempOutputFolder 'item_0007_TwangSegmentation' filesep 'tempInputImage_' sprintf('%04d', i) '_TwangSegmentation_Out1.tif'];
        
%         if (isfile(tempResultFile))
%             continue;
%         end

%         figure(1);
%         if (i==1)
%             clf;
%             imagesc(overviewMask); hold on;
%         end
%         if (currentClass == 0)
%             plot(positionMask(1), positionMask(2), '.g');
%         else
%             plot(positionMask(1), positionMask(2), '.r');
%         end

        %% read the input images
        rawImages = cell(numChannels,1);
        for k=1:numChannels
            rawImages{k} = imread([inputFolder strrep(inputFiles(i).name, inputFilter{dapiChannelIndex}, inputFilter{k})]); %#ok<PFBNS>

            if (k==dapiChannelIndex)
                imwrite(rawImages{k}, tempInputFile);
            end
        end

%         %% perform segmentation using the TWANG algorithm
%         %% perform instance segmentation using XPIWIT (seeded watershed)
%         if (ispc)
%             cd ThirdParty\XPIWIT\Windows\
%         elseif (ismac)
%             cd ThirdParty/XPIWIT/MacOSX/
%         elseif (isunix)
%             cd ThirdParty/XPIWIT/Ubuntu/
%         end

        %% specify the XPIWIT command
        XPIWITCommand = ['D:\Programming\XPIWIT\Bin\Release\XPIWIT.exe ' ...
            '--output "' tempOutputFolder '" ' ...
            '--input "0, ' tempInputFile ', 2, float" ' ...
            '--xml "D:\Programming\SciXMiner\application_specials\hccminer\XPIWITPipelines\NucleusSegmentationPipeline.xml" ' ...
            '--seed 0 --lockfile off --subfolder "filterid, filtername" --outputformat "imagename, filtername" --end'];

        %% replace slashes by backslashes for windows systems
        if (ispc == true)
            XPIWITCommand = strrep(XPIWITCommand, './XPIWIT.sh', 'XPIWIT.exe');
            XPIWITCommand = strrep(XPIWITCommand, '\', '/');
        end
        
        %segmentationImageFile = [tempOutputFolder 'item_0007_TwangSegmentation' filesep 'tempInputImage_' num2str(i) '_TwangSegmentation_Out1.tif'];
        if (~isfile(tempResultFile))
            system(XPIWITCommand);
        end
%         cd ../../../;
        segmentationImage = imread(tempResultFile);
        %segmentationImage = imread([tempOutputFolder 'item_0009_ParallelSeededWatershedSegmentation' filesep 'tempInputImage_' num2str(i) '_ParallelSeededWatershedSegmentation_Out1.tif']);

        %% extract regionprops for all channels
        regionProps = cell(numChannels,1);
        regionProps{dapiChannelIndex,1} = regionprops(segmentationImage, 'Area', 'BoundingBox', 'Centroid', 'Circularity', 'Eccentricity', 'EquivDiameter', 'Extent', 'MajorAxisLength', 'MinorAxisLength', 'Perimeter', 'Solidity', 'PixelIdxList');
        for k=1:numChannels
            for l=1:length(regionProps{dapiChannelIndex,1})
                currentPixelIdxList = regionProps{dapiChannelIndex,1}(l).PixelIdxList;
                regionProps{k,1}(l).MeanIntensity = mean(rawImages{k}(currentPixelIdxList));
                regionProps{k,1}(l).MaxIntensity = max(rawImages{k}(currentPixelIdxList));
                regionProps{k,1}(l).StdIntensity = std(single(rawImages{k}(currentPixelIdxList)));
                
                currentQuantile = quantile(rawImages{k}(currentPixelIdxList), 0.75);
                validPixels25PctMax = currentPixelIdxList(rawImages{k}(currentPixelIdxList) >= currentQuantile);
                regionProps{k,1}(l).MeanIntensity25PctMax = mean(rawImages{k}(validPixels25PctMax));
            end
        end

        %% assemble all region props to a single result matrix
        numFeatures = 37;
        numObjects = length(regionProps{dapiChannelIndex});
        currentResultMatrix = zeros(numObjects, numFeatures);
        for o=1:numObjects

            %% continue if present detection is empty
            if (regionProps{dapiChannelIndex}(o).Area <= 0)
                continue;
            end

            %% add shape related features
            currentResultMatrix(o, 1) = o;
            currentResultMatrix(o, 2) = regionProps{dapiChannelIndex,1}(o).Area;
            currentResultMatrix(o, 3) = regionProps{dapiChannelIndex,1}(o).Centroid(1) + rawImagePositionX;
            currentResultMatrix(o, 4) = regionProps{dapiChannelIndex,1}(o).Centroid(2) + rawImagePositionY;
            currentResultMatrix(o, 5) = regionProps{dapiChannelIndex,1}(o).Circularity;
            currentResultMatrix(o, 6) = regionProps{dapiChannelIndex,1}(o).Eccentricity;
            currentResultMatrix(o, 7) = regionProps{dapiChannelIndex,1}(o).EquivDiameter;
            currentResultMatrix(o, 8) = regionProps{dapiChannelIndex,1}(o).Extent;
            currentResultMatrix(o, 9) = regionProps{dapiChannelIndex,1}(o).MinorAxisLength;
            currentResultMatrix(o, 10) = regionProps{dapiChannelIndex,1}(o).MajorAxisLength;
            currentResultMatrix(o, 11) = regionProps{dapiChannelIndex,1}(o).Perimeter;
            currentResultMatrix(o, 12) = regionProps{dapiChannelIndex,1}(o).Solidity;
            currentResultMatrix(o, 13) = currentClass;

            %% add the intensity features
            featureIndex = 14;
            for k=1:numChannels
                currentResultMatrix(o, featureIndex) = regionProps{k,1}(o).MeanIntensity;
                currentResultMatrix(o, featureIndex + 1) = regionProps{k,1}(o).MeanIntensity25PctMax;
                currentResultMatrix(o, featureIndex + 2) = regionProps{k,1}(o).MaxIntensity;
                currentResultMatrix(o, featureIndex + 3) = regionProps{k,1}(o).StdIntensity;
                featureIndex = featureIndex + 4;
            end
        end

        %% write the current result file to disk
        outFileName = [resultsFolder strrep(inputFiles(i).name, [inputFilter{dapiChannelIndex} '.tif'], 'Features.csv')];
        dlmwrite(outFileName, currentResultMatrix, ';');
        prepend2file(featureNames, outFileName, true);
        
        delete(tempInputFile);
        delete(tempResultFile);

        %% show progress
        disp(['Finished processing ' num2str(i) ' / ' num2str(numTiles) ' tiles ...']);
    end
end
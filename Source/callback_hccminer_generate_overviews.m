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

%% add dependencies
addpath('ThirdParty/');

%% load the mask image and crop it tightly
maskImageRaw = rgb2gray(imread('C:\Users\stegmaier\Downloads\Test\HCC493.PNG'));
maskImage = bwfill(rgb2gray(imread('C:\Users\stegmaier\Downloads\Test\HCC493.PNG')) < 255, 'holes');
maskRegion = regionprops(maskImage, 'BoundingBox');
aabb = round(maskRegion.BoundingBox);
maskImage = maskImage((aabb(2):(aabb(2)+aabb(4))), (aabb(1):(aabb(1)+aabb(3))));
maskImageRaw = maskImageRaw((aabb(2):(aabb(2)+aabb(4))), (aabb(1):(aabb(1)+aabb(3))));
maskImageSize = size(maskImage);

figure(2); clf;
imagesc(maskImage); hold on;

%% input filters
inputFilter{1} = '46HE';
inputFilter{2} = '47Cy';
inputFilter{3} = '50Cy';
inputFilter{4} = '64HE';
inputFilter{5} = '96HE';    %% DAPI channel
inputFilter{6} = 'Cy7E';
dapiChannelIndex = 5;
numChannels = length(inputFilter);

%% specify experiment parameters (TODO: parse from meta data?)
imageScale = 0.1;
imageResolution = [1392, 1040];
cropResolution = [1195, 892];
gridSize = [52, 87];
imageOverlap = [208, 156];
stepSizeX = maskImageSize(2) / (gridSize(1));
stepSizeY = maskImageSize(1) / (gridSize(2));

%% specify the input folder and enumerate files belonging to the DAPI channel
inputFolder = 'V:\BiomedicalImageAnalysis\TissueClassification_KlingeUKA\HCC\HCC Multiplex cd3 cd4 cd8 pdl1 foxp3 set1\Images\Slide 1 HCC493 cd3+cd8+cd4+pdl1+Foxp3\Region 003\';
tempOutputFolder = 'C:\Users\stegmaier\Downloads\Processing2\';
resultsFolder = 'C:\Users\stegmaier\Downloads\Results\';
if (~exist(tempOutputFolder, 'dir')); mkdir(tempOutputFolder); end
if (~exist(resultsFolder, 'dir')); mkdir(resultsFolder); end
tempInputFile = [tempOutputFolder 'tempInputImage.tif'];
inputFiles = dir([inputFolder '*_' inputFilter{dapiChannelIndex} '.tif']);
numTiles = length(inputFiles);

%% initialize preview image
resultImage = zeros(cropResolution(2)*gridSize(2), cropResolution(1)*gridSize(1));
resultRegionProps = cell(numTiles, 1);

%% loop through all regions and successively analyze all patches
for i=1:numTiles
    
    [positionGrid, positionMask] = GetPositionFromIndex(i, maskImage, gridSize);
    
    rawImage = imread([inputFolder strrep(inputFiles(i).name, inputFilter{dapiChannelIndex}, inputFilter{dapiChannelIndex})]);
    imageSize = size(rawImage);
    
%     yoffSet = 0;
%     xoffSet = 0;
%     
%     if (positionGrid(1) > 1)
%         previousIndex = GetIndexFromPosition(positionGrid - [1, 0], maskImage, gridSize);
%         
%         if (~isempty(previousIndex))
%             previousImage = imread([inputFolder strrep(inputFiles(previousIndex).name, inputFilter{dapiChannelIndex}, inputFilter{dapiChannelIndex})]);
%             
%             ccresult = normxcorr2(rawImage, previousImage);
%             
%             [ypeak,xpeak] = find(ccresult==max(ccresult(:)));
%             yoffSet = ypeak-imageSize(1);
%             xoffSet = xpeak-imageSize(2);
%             
% %             figure(3);
% %             surf(ccresult);
%             
%             test = 1;
%         end
%     end
    
    rawImagePositionX = (positionGrid(2)-1)*cropResolution(1) + 1;
    rawImagePositionY = (positionGrid(1)-1)*cropResolution(2) + 1;
    rangeX = rawImagePositionX:(rawImagePositionX+imageSize(2)-1);
    rangeY = rawImagePositionY:(rawImagePositionY+imageSize(1)-1);

    resultImage(rangeY, rangeX) = rawImage;
    
    figure(2);
    plot(positionMask(1), positionMask(2), '.r');

    if (mod(i,100) == 0)
        figure(1); clf;
        stepSize = 10;
        imagesc(resultImage(1:stepSize:end, 1:stepSize:end)); axis equal;
    end
end
    
% 
%     figure(1); clf;
%     stepSize = 2;
%     imagesc(resultImage(1:stepSize:end, 1:stepSize:end)); axis equal;


    figure(1); clf;
    stepSize = 1;
    imagesc(resultImage(1:stepSize:end, 1:stepSize:end)); axis equal;

    test = 1;
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
addpath('ThirdParty\');

%% specify input and output directory
inputFile = 'D:\ScieboDrive\Projects\2021\RoethUKA_TissueClassification\Documents\Overview.xlsx';
outputRoot = 'I:\Projects\2021\TissueClassification_RoethUKA\';

%% read the input table
%% expected table format:
%% 1 tissue slide per row (if multiple parts are imaged on one slide, add separate lines for each one).
%% 11 columns are expected that contain the tissue type, data set name, data set code, grid layout ("R;C"), image size, overlap ("xO;yO"), pixel size, numer of FOVs, fill holes, input folder, overview image path
[NUM,TXT,RAW] = xlsread(inputFile);

%% specify indices within the excel file
tissueTypeIndex = 1;
dataSetNameIndex = 2;
dataSetCodeIndex = 3;
gridLayoutIndex = 4;
imageSizeIndex = 5;
overlapIndex = 6;
pixelSizeIndex = 7;
numberOfTilesIndex = 8;
fillHolesIndex = 9;
inputFolderIndex = 10;
overviewImageIndex = 11;

%% determine the number of data sets
numDataSets = size(TXT,1)-1;

%% process all data sets
for d=1:numDataSets
    
    %% index offset as the first line in the excel sheet contains the specifiers
    expIndex = d+1;
    
    %% extract the grid size
    gridString = strsplit(TXT{expIndex,gridLayoutIndex}, ';');
    gridSize = [str2double(gridString{1,2}), str2double(gridString{1,1})];
    
    %% assemble the experiment name
    experimentName = [TXT{expIndex,tissueTypeIndex} TXT{expIndex,dataSetNameIndex} '_' TXT{expIndex,dataSetCodeIndex}];
    
    %% fill holes in the mask (only required if foreground regions are erroneously set to background
    fillHoles = RAW{expIndex,fillHolesIndex} > 0;
    numFOVRegions = RAW{expIndex, numberOfTilesIndex};
    
    %% determine the input folder
    inputFolder = TXT{expIndex, inputFolderIndex};
    if (inputFolder(end) ~= filesep)
        inputFolder = [inputFolder filesep]; %#ok<AGROW>
    end
    
    %% specify the output folder
    currentOutputFolder = [outputRoot experimentName filesep];
    if (~exist(currentOutputFolder, 'dir'))
        mkdir(currentOutputFolder);
    end
    
    %% specify the mask files
    overviewImage = imread(TXT{expIndex, overviewImageIndex});
    overviewImageOutputFile = [currentOutputFolder experimentName '_Overview.png'];
    overviewMaskOutputFile = [currentOutputFolder experimentName '_OverviewMask.png'];
    
    %% binary overview mask and potentially fill holes
    if (~exist(overviewMaskOutputFile) || ~exist(overviewMaskOutputFile))
        [overviewImageCropped, overviewMaskCropped] = callback_hccminer_get_mask_images(overviewImage, fillHoles);
    else
        overviewImageCropped = imread(overviewImageOutputFile);
        overviewMaskCropped = imread(overviewMaskOutputFile);
    end
    
    %% downsample the mask to grid size
    overviewMaskResized = imresize(overviewMaskCropped, gridSize, 'nearest');
    
    %% perform consistency check of mask and number of FOVs
    if (sum(overviewMaskResized(:)) ~= numFOVRegions)
        disp(['Number of pixels ' num2str(sum(overviewMaskResized(:))) ' in the downscaled mask does not match the number of FOV regions ' num2str(numFOVRegions) ' !! Skipping!!!']);
        continueCorrection = true;
        while (sum(overviewMaskResized(:)) ~= numFOVRegions)
        
            disp(['Number of pixels ' num2str(sum(overviewMaskResized(:))) ' in the downscaled mask does not match the number of FOV regions ' num2str(numFOVRegions) ' !! Skipping!!!']);
            answer = questdlg('Continue labeling?', 'Labeling Decision', 'Yes','No', 'Yes');
            if (strcmp(answer, 'No'))
                break;
            end
            
            figure(1);
            subplot(1,3,1);
            imagesc(overviewImageCropped);

            subplot(1,3,2);
            imagesc(overviewMaskCropped);

            subplot(1,3,3);
            imagesc(overviewMaskResized);
            
            figure(2);
            imagesc(overviewMaskCropped);
            freehandHandler = imfreehand(); %#ok<IMFREEH>
            correctedMask = freehandHandler.createMask;
            overviewMaskCropped = max(overviewMaskCropped, correctedMask);
            delete(freehandHandler);
            
            %% downsample the mask to grid size
            overviewMaskResized = imresize(overviewMaskCropped, gridSize, 'nearest');
        end
    else
        imwrite(overviewImageCropped, overviewImageOutputFile);
        imwrite(overviewMaskCropped, overviewMaskOutputFile);
    end
    
    %% perform segmentation and import the resulting tiles including intensity information from all other channels
    callback_hccminer_extract_tile_features(inputFolder, currentOutputFolder, overviewMaskResized);
    callback_hccminer_fuse_tile_projects([currentOutputFolder 'Results' filesep], [currentOutputFolder experimentName '_Fused.prjz'], overviewMaskResized);
end
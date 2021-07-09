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

debugFigures = false;

%% setup parameters
positionFeatureIndices = [callback_hccminer_find_single_feature(dorgbez, 'xpos'), callback_hccminer_find_single_feature(dorgbez, 'ypos')];
selectedFeatures = parameter.gui.merkmale_und_klassen.ind_em;
autoFluorescenceSuppressionMethod = parameter.gui.hccminer.AutoFluorescenceCorrectionMethod;
autoFluorescenceSuppressionMultiplier = parameter.gui.hccminer.AutoFluorescenceCorrectionMultiplier;
numBins = parameter.gui.hccminer.NumHistogramBins;
quantileThreshold = parameter.gui.hccminer.QuantileThreshold;    
numExpressionClasses = parameter.gui.hccminer.NumExpressionClasses;

%% compute the neighbor indices
disp('Computing autofluorescence-corrected expression features ...');
validIndices = find(d_org(:,1) ~= 0);

%% compute the variance features
for f=generate_rowvector(selectedFeatures)
        
    %% add new entry to d_org   
    d_org(:,end+1) = 0; %#ok<SAGROW>
    newFeatureIndex = size(d_org,2);
    dorgbez = char(dorgbez, [kill_lz(dorgbez(f,:)) '-exp-woAF-AFMeth=' num2str(autoFluorescenceSuppressionMethod) '-AFMult=' num2str(autoFluorescenceSuppressionMultiplier)]);
    aktparawin;
    
    %% compute statistics for current feature using a Gaussian approximation
    autoFluorescenceThreshold = max(parameter.gui.hccminer.AutoFluorescenceCorrectionMinThreshold, callback_hccminer_compute_autofluorescence_threshold(d_org(:,f), d_org(:,3:4), autoFluorescenceSuppressionMethod, autoFluorescenceSuppressionMultiplier, numBins));
    
    %% determine the lower and upper quantiles for potential normalization. Default is quantileThreshold = 0
    lowerQuantile = quantile(d_org(:,f), quantileThreshold);
    upperQuantile = quantile(d_org(:,f), 1-quantileThreshold);
    
    %% identify intensity step for the different expression level intervals
    positiveExpressionWindowSize = (upperQuantile - autoFluorescenceThreshold) / numExpressionClasses;
    
    %% set background indices to zero
    backgroundIndices = d_org(:,f) <= autoFluorescenceThreshold;
    d_org(backgroundIndices, newFeatureIndex) = 0; %#ok<SAGROW>
    
    %% set expression label based on equidistant 
    for i=1:numExpressionClasses
        currentIndices = d_org(:,f) > (autoFluorescenceThreshold + (i-1)*positiveExpressionWindowSize) & d_org(:,f) <= (autoFluorescenceThreshold + i*positiveExpressionWindowSize);
        d_org(currentIndices, newFeatureIndex) = i;
    end
end

%% former version without the auto-fluorescence suppression
%     lowExpressionIndices = d_org(:,f) > (autoFluorescenceThreshold + 0*positiveExpressionWindowSize) & d_org(:,f) <= (autoFluorescenceThreshold + 1*positiveExpressionWindowSize);
%     mediumExpressionIndices = d_org(:,f) > (autoFluorescenceThreshold + 1*positiveExpressionWindowSize) & d_org(:,f) <= (autoFluorescenceThreshold + 2*positiveExpressionWindowSize);
%     highExpressionIndices = d_org(:,f) > (autoFluorescenceThreshold + 2*positiveExpressionWindowSize);
% 
%     d_org(backgroundIndices, newFeatureIndex) = 0; %#ok<SAGROW>
%     d_org(lowExpressionIndices, newFeatureIndex) = 1; %#ok<SAGROW>
%     d_org(mediumExpressionIndices, newFeatureIndex) = 2; %#ok<SAGROW>
%     d_org(highExpressionIndices, newFeatureIndex) = 3; %#ok<SAGROW>
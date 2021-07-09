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

%% setup parameters and initialize the keep indices
equivDiameterIndex = callback_hccminer_find_single_feature(dorgbez, 'equivDiameter');
positionFeatureIndices = [callback_hccminer_find_single_feature(dorgbez, 'xpos'), callback_hccminer_find_single_feature(dorgbez, 'ypos')];
numNeighbors = 5;
keepIndices = ones(size(d_org,1), 1);

%% create KD tree for faster neighbor lookup
validIndices = d_org(:,1) > 0;
currentKDTree = KDTreeSearcher(d_org(:,positionFeatureIndices));

%% search for the nearest neighbors
[nnIndices, nnDistances] = knnsearch(currentKDTree, d_org(:,positionFeatureIndices), 'K', numNeighbors);

%% determine detections that reside within the radius of the detected object
for i=1:size(d_org,1)
   
    %% check which of the nearest neighbors fulfill the match criterion
    currentRadius = 0.5 * d_org(i,equivDiameterIndex);
    matchingIndices = i;
    for j=2:numNeighbors
        
        if (nnDistances(i,j) <= currentRadius)
            matchingIndices = [matchingIndices; nnIndices(i,j)]; %#ok<AGROW>
        end        
    end
    
    %% sort matching indices and only keep smallest one by convention
    matchingIndicesSorted = sort(matchingIndices);
    
    %% set deletion indices for all but the smallest one
    keepIndices(matchingIndicesSorted(2:end)) = 0;
end

%% delete data points not selected
ind_auswahl = find(keepIndices <= 0);
eval(gaitfindobj_callback('MI_Loeschen_Datentupel'));

%% Select,  Edit,  All data points 
eval(gaitfindobj_callback('MI_Datenauswahl_Alle'));
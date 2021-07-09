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

%% setup parameters
radius = parameter.gui.hccminer.neighborhoodRadius;
positionFeatures = [callback_hccminer_find_single_feature(dorgbez, 'xpos'), callback_hccminer_find_single_feature(dorgbez, 'ypos')];

%% compute the neighbor indices
disp(['Computing neighbor indices within a radius of r=' num2str(radius) ' ...']);
validIndices = find(d_org(:,1) ~= 0);
positions = squeeze(d_org(validIndices, positionFeatures));

currentKDTree = KDTreeSearcher(positions);
idx = rangesearch(currentKDTree, positions, radius);

%% add new entry to d_org
d_org(:,end+1) = 0;
newFeatureIndex = size(d_org,2);
dorgbez = char(dorgbez(1:end,:), ['density-r=' num2str(radius)]);
aktparawin;

%% set the density based on the number of neighbors within the given radius
disp('Computing density ...');
for j=generate_rowvector(validIndices)
    d_org(j,newFeatureIndex) = length(idx{j});
end
disp('Done.');

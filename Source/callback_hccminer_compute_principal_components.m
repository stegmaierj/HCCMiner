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
selectedFeatures = parameter.gui.merkmale_und_klassen.ind_em;
        
%% compute the neighbor indices
disp('Computing principal components of selected features ...');
validIndices = find(sum(d_org(:,selectedFeatures), 2) > 0);

[COEFF, SCORE, LATENT] = pca(d_org(validIndices, selectedFeatures));

%% compute the variance features
for f=1:length(LATENT)
        
    %% add new entry to d_org   
    d_org(:,end+1) = 0; %#ok<SAGROW>
    newFeatureIndex = size(d_org,2);
    dorgbez = char(dorgbez, [kill_lz(dorgbez(selectedFeatures(f),:)) '-PC' num2str(f)]);
    aktparawin;
    
    d_org(validIndices, newFeatureIndex) = SCORE(:,f); %#ok<SAGROW>
end
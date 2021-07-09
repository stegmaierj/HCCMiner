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

%% determine the selected features
selectedFeature = parameter.gui.merkmale_und_klassen.ind_em;

%% compute 3-class expression
for i=1:length(selectedFeature)

    %% get the current feature id
    currentFeature = selectedFeature(i);
    
    %% determine the ranges used for classification into low, medium, high expression
    lowExpressionThreshold = quantile(d_org(:,currentFeature), 0.33);
    medExpressionThreshold = quantile(d_org(:,currentFeature), 0.66);
    
    %% classify the entries based on the thresholds
    lowIndices = d_org(:,currentFeature) <= lowExpressionThreshold;
    medIndices = d_org(:,currentFeature) <= lowExpressionThreshold;
    highIndices = d_org(:,currentFeature) > medExpressionThreshold;

    %% update d_org with the computed values
    d_org(:,end+1) = 0; %#ok<SAGROW>
    d_org(lowIndices,end) = 1; %#ok<SAGROW>
    d_org(medIndices,end) = 2; %#ok<SAGROW>
    d_org(highIndices,end) = 3; %#ok<SAGROW>
    dorgbez = char(dorgbez, [kill_lz(dorgbez(currentFeature,:)) '-3ClassExpression']);
end

%% update gui
aktparawin;
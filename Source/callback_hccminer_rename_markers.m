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

%% TODO: add possibility to specify markers in the GUI (e.g. Anjalis project has different markers than Prof. Klinge/Axels project).

originalTerms{1} = '46HE';
originalTerms{2} = '47Cy';
originalTerms{3} = '50Cy';
originalTerms{4} = '64HE';
originalTerms{5} = '96HE';
originalTerms{6} = 'Cy7E';

newTerms{1} = 'CD4';
newTerms{2} = 'CD3';
newTerms{3} = 'PDL1';
newTerms{4} = 'CD8';
newTerms{5} = 'DAPI';
newTerms{6} = 'FoxP3';

newDorgBez = [];

for i=1:size(dorgbez,1)
   
    currentSpecifier = kill_lz(dorgbez(i,:));
    
    for j=1:length(originalTerms)
        currentSpecifier = strrep(currentSpecifier, originalTerms{j}, newTerms{j});
    end
    
    if (~isempty(newDorgBez))
        newDorgBez = char(newDorgBez, currentSpecifier);
    else
        newDorgBez = char(currentSpecifier);
    end
end

dorgbez = newDorgBez;
aktparawin;
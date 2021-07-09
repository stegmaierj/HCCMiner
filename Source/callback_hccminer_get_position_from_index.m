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

function [positionGrid] = callback_hccminer_get_position_from_index(index, maskImage)

    gridSize = size(maskImage);
    positionGrid = [];

    %% loop through all regions and successively analyze all patches
    currentIndex = 0;
    for i=1:gridSize(1)
        for j=1:gridSize(2)
            
            %% only process valid locations
            if (mod(i-1,2) == 0)
                currentPosition = [i, j];
            else
                currentPosition = [i, gridSize(2) - j + 1];
            end
            
            if (maskImage(currentPosition(1), currentPosition(2)) > 0)
                currentIndex = currentIndex + 1;
                
                if (currentIndex == index)
                    positionGrid = currentPosition;
                    break;
                end
            end
            
            if (~isempty(positionGrid))
                break;
            end
        end
        
        if (~isempty(positionGrid))
            break;
        end
    end
end
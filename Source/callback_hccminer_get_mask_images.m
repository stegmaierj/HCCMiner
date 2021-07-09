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

function [overviewImageCropped, overviewMaskCropped] = callback_hccminer_get_mask_images(overviewImage, fillHoles)

    %% crop the mask image tightly
    if (size(overviewImage, 3) > 1)
        overviewImage = rgb2gray(overviewImage);
    end
    overviewImage = padarray(overviewImage, 20, 255);
        
    %% optionally fill holes if enabled
    if (fillHoles == true)
        overviewMask = bwfill(overviewImage < 255, 'holes');
    else
        overviewMask = overviewImage < 255;
    end
    
    overviewMask = imclose(overviewMask, strel('disk', 3));

    maskRegion = regionprops(overviewMask, 'BoundingBox');
    aabb = round(maskRegion(1).BoundingBox);
    overviewMaskCropped = overviewMask((aabb(2):(aabb(2)+aabb(4))), (aabb(1):(aabb(1)+aabb(3))));
    overviewImageCropped = overviewImage((aabb(2):(aabb(2)+aabb(4))), (aabb(1):(aabb(1)+aabb(3))));
end
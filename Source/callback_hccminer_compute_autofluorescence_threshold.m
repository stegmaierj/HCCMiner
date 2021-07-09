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

function autoFluorescenceThreshold = callback_hccminer_compute_autofluorescence_threshold(inputValues, positions, thresholdMethod, aftFactor, numBins)

    %% if enabled, debug figures will be plotted
    debugFigures = false;
    
    %% specify the valid indices and positions
    validIndices = inputValues > 0;
    validPositions = positions(validIndices, :);
    
    %% compute intensity statistics
    meanValue = mean(inputValues(validIndices));
    stdValue = std(inputValues(validIndices));
    autoFluorescenceThreshold = 0;
    
    %% mode 1 uses the mean intensity value and adds the n-fold std. dev. to it as a threshold. 
    if (thresholdMethod == 1)
        autoFluorescenceThreshold = (meanValue + aftFactor*stdValue);
 
    %% mode 2 computes the histogram mode (3 most prominent neighboring peaks) and multiplies the mode with the specified factor
    elseif (thresholdMethod == 2)
        fh = figure;
        h = histogram(inputValues(validIndices), 0:numBins);
               
        maxValue = 0;
        maxIndex = 2;
        for j=2:(numBins-1)

            currentValue = h.Values(j-1) + h.Values(j) + h.Values(j+1);
            if (currentValue > maxValue)
               maxValue = currentValue;
               maxIndex = j;
            end
        end
        
        autoFluorescenceThreshold = h.BinEdges(aftFactor*maxIndex);
        close(fh);
        
    %% mode 3 simply applies a specified threshold
    elseif (thresholdMethod == 3)
        autoFluorescenceThreshold = aftFactor;
    end
    
    %% plot debug figures
    if (debugFigures == true)
        figure;
        subplot(1,3,1);
        h = histogram(inputValues(validIndices), 0:numBins); hold on;
        plot([autoFluorescenceThreshold, autoFluorescenceThreshold], [0, max(h.Values)], 'LineWidth', 3);
        xlabel('Intensity Level');
        ylabel('Frequency');
        title(sprintf('AF Correction Method: %i, Multiplier: %.2f, AF-Threshold: %.2f', thresholdMethod, aftFactor, autoFluorescenceThreshold));
        
        subplot(1,3,2);
        scatter(validPositions(:,1), validPositions(:,2), 5, inputValues(validIndices), '.'); hold on;
        set(gca, 'YDir', 'reverse');
        colormap turbo;
        %colorbar;
        title(sprintf('Mean Intensity: %.2f, Std.Dev. Intensity: %.2f', meanValue, stdValue));
        
        subplot(1,3,3);
        mycolors = zeros(length(inputValues(validIndices)), 3);
        mycolors(inputValues(validIndices) > autoFluorescenceThreshold,2) = 1;
                
        scatter(validPositions(:,1), validPositions(:,2), 5, mycolors, '.'); hold on;
        
        fgIndices = inputValues(validIndices) > autoFluorescenceThreshold;
        scatter(validPositions(fgIndices,1), validPositions(fgIndices,2), 2, '.g');
        set(gca, 'YDir', 'reverse');
                
%         subplot(1,3,3);
%         fgIndices = inputValues(validIndices) > autoFluorescenceThreshold;
%         bgIndices = inputValues(validIndices) <= autoFluorescenceThreshold;
%         scatter(validPositions(bgIndices,1), validPositions(bgIndices,2), 5, '.k'); hold on;
%         scatter(validPositions(fgIndices,1), validPositions(fgIndices,2), 5, '.g');
%         set(gca, 'YDir', 'reverse');
%         legend('Background', 'Foreground');
    end
end
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

function [] = callback_hccminer_show_colored_superposition(d_org, dorgbez, parameter, normalizationMode, prefix, outputFolder)

    %% visualizationModes: 0 = heatmaps, 1 = box plots, 2 = histograms
    quantileThreshold = parameter.gui.hccminer.QuantileThreshold;
    stepSize = parameter.gui.hccminer.StepSize;
    fontSize = 10;

    selectedFeatures = parameter.gui.merkmale_und_klassen.ind_em;
    numSelectedFeatures = length(selectedFeatures);

    %% show hint if more than three features are selected
    if (length(numSelectedFeatures) > 3)
        disp('This visualization only supports 3 colors, showing all combinations of three unique features.');
    end

    %% identify the number of combinations
    numCombinations = nchoosek(numSelectedFeatures, 3);
    combinations = [];
    for i=1:numSelectedFeatures
        for j=1:numSelectedFeatures
            for k=1:numSelectedFeatures
                if (i ~= j && j ~= k && k ~= i)
                    combinations = [combinations; sort([i, j, k])]; %#ok<AGROW>
                end
            end
        end
    end
    combinations = unique(combinations, 'rows');

    %% only create new figure if no external plotting routine called the script
    if (parameter.gui.hccminer.CreateNewFigure == true)
        fh = figure; clf;
        colordef black; %#ok<COLORDEF>
        set(gcf, 'Units', 'normalize', 'OuterPosition', [0 0 1 1]);
        set(gcf, 'Color', 'k');
        [numRows, numColumns] = callback_hccminer_compute_subplot_layout(numCombinations);
    end

    %% plot all combinations
    for i=1:numCombinations

        %% only plot to subplot if no external plotting routine called the script
        if (parameter.gui.hccminer.CreateNewFigure == true)
            subplot(numRows, numColumns, i); hold on;
        end

        %% get current feature combination
        currentCombination = combinations(i,:);
        feature1 = selectedFeatures(currentCombination(1));
        feature2 = selectedFeatures(currentCombination(2));
        feature3 = selectedFeatures(currentCombination(3));

        %% identify the selected indices
        selectedIndices = 1:stepSize:size(d_org,1);
        colorChannel1 = d_org(selectedIndices, feature1);
        colorChannel2 = d_org(selectedIndices, feature2);
        colorChannel3 = d_org(selectedIndices, feature3);

        %% normalize values using quantile normalization
        if (normalizationMode == 1)
            colorChannel1 = (colorChannel1 - quantile(colorChannel1(:), quantileThreshold)) / (quantile(colorChannel1(:), 1-quantileThreshold) - quantile(colorChannel1(:), quantileThreshold));
            colorChannel2 = (colorChannel2 - quantile(colorChannel2(:), quantileThreshold)) / (quantile(colorChannel2(:), 1-quantileThreshold) - quantile(colorChannel2(:), quantileThreshold));
            colorChannel3 = (colorChannel3 - quantile(colorChannel3(:), quantileThreshold)) / (quantile(colorChannel3(:), 1-quantileThreshold) - quantile(colorChannel3(:), quantileThreshold));
        else
            colorChannel1 = colorChannel1 / (quantile(colorChannel1(:), 1-quantileThreshold));
            colorChannel2 = colorChannel2 / (quantile(colorChannel2(:), 1-quantileThreshold));
            colorChannel3 = colorChannel3 / (quantile(colorChannel3(:), 1-quantileThreshold));
        end
        colorChannel1(colorChannel1 > 1) = 1;
        colorChannel2(colorChannel2 > 1) = 1;
        colorChannel3(colorChannel3 > 1) = 1;
        colorInformation = [colorChannel1, colorChannel2, colorChannel3];

        %% compute split strings for the specifiers
        splitString1 = strsplit(kill_lz(dorgbez(feature1,:)), '-');
        splitString2 = strsplit(kill_lz(dorgbez(feature2,:)), '-');
        splitString3 = strsplit(kill_lz(dorgbez(feature3,:)), '-');

        currentTitle = [splitString1{1}];
        for j=3:length(splitString1)
            currentTitle = [currentTitle '-'];
            currentTitle = [splitString1{j}];
        end

        specifier1 = splitString1{min(length(splitString1), 2)};
        specifier2 = splitString2{min(length(splitString2), 2)};
        specifier3 = splitString3{min(length(splitString3), 2)};

        if (contains(kill_lz(dorgbez(feature1,:)), 'PC'))
            specifier1 = splitString1{min(length(splitString1), 7)};
            specifier2 = splitString2{min(length(splitString2), 7)};
            specifier3 = splitString3{min(length(splitString3), 7)};
        end

        %% display the legend
        h = zeros(4,1);
        h(1) = plot(0,0,'.r', 'DisplayName', specifier1);
        h(2) = plot(0,0,'.g', 'DisplayName', specifier2);
        h(3) = plot(0,0,'.b', 'DisplayName', specifier3);
        h(4) = scatter(d_org(selectedIndices,3), d_org(selectedIndices,4), 5, colorInformation, '.');
        legend(h(1:3), 'Location', 'northeast', 'FontSize', fontSize);
        axis equal;
        set(gca, 'YDir', 'reverse', 'FontSize', fontSize);
        xlabel('PositionX');
        ylabel('PositionY');
    end

    %% reset color mode of the figure
    colordef white; %#ok<COLORDEF>
       
    
    %% write result figure if output path is provided
    if (~isempty(outputFolder))
        if (numRows == 1 && numColumns == 1)
            imwrite(frame2im(getframe(gcf)), [outputFolder parameter.projekt.datei '_' specifier1 '_' specifier2 '_' specifier3 prefix '_3ColorSP.png']);
        else
            imwrite(frame2im(getframe(gcf)), [outputFolder parameter.projekt.datei prefix '_3ColorSP.png']);
        end
    end
end
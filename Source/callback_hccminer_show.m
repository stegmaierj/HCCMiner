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

function [] = callback_hccminer_show(d_org, dorgbez, code, zgf_y_bez, parameter, visualizationMode, prefix, outputFolder)

    if (~exist('outputFolder', 'var'))
        outputFolder = [];
    end

    %% visualizationModes: 0 = heatmaps, 1 = box plots, 2 = histograms
    quantileThreshold = parameter.gui.hccminer.QuantileThreshold;
    stepSize = parameter.gui.hccminer.StepSize;

    %% get auto fluorescence correction mode
    useQuantileNormalization = parameter.gui.hccminer.UseQuantileNormalizationForPlotting;
    if (useQuantileNormalization == false)
        quantileThreshold = 0.0;
    end
    numBins = parameter.gui.hccminer.NumHistogramBins;

    %% find the selected features
    selectedFeatures = parameter.gui.merkmale_und_klassen.ind_em;
    numSelectedFeatures = length(selectedFeatures);

    %% identify the optimum subplot layout
    [numRows, numColumns] = callback_hccminer_compute_subplot_layout(numSelectedFeatures);

    %% set visualization mode if not externally specified
    if (~exist('visualizationMode', 'var'))
        visualizationMode = 0;
    end

    %% only create figure if not in auto plotting mode
    if (parameter.gui.hccminer.CreateNewFigure == true)
        fh = figure; clf;
        set(gcf, 'Units', 'normalize', 'OuterPosition', [0 0 1 1]);
        
        if (visualizationMode == 0)
            set(gcf, 'Color', 'k');
            colordef black;
            colormap turbo;
        else
            set(gcf, 'Color', 'w');
            colordef white;
            colormap parula;
        end
    end

    %% identify labels for current output classes
    outputVariables = unique(code);
    outputLabels = [];
    for j=outputVariables'            
        if (~isempty(outputLabels))
            outputLabels = char(outputLabels, zgf_y_bez(parameter.gui.merkmale_und_klassen.ausgangsgroesse,j).name);
        else
            outputLabels = char(zgf_y_bez(parameter.gui.merkmale_und_klassen.ausgangsgroesse,j).name);
        end
    end

    %% display all selected features
    for i=1:numSelectedFeatures

        %% only select subplot if no external script is calling this function
        if (parameter.gui.hccminer.CreateNewFigure == true)
            figure(fh);
            subplot(numRows, numColumns, i);
        end

        %% get the selected feature and cell indices
        selectedFeature = selectedFeatures(i);
        suffix = '';
      
        %% perform quantile filtering to be less affected by outliers
        lowerQuantile = quantile(d_org(:,selectedFeature), quantileThreshold);
        upperQuantile = quantile(d_org(:,selectedFeature), 1-quantileThreshold);

        %% identify the normal and tumor indices
        validIndices = find(d_org(:,selectedFeature) >= lowerQuantile & d_org(:,selectedFeature) <= upperQuantile);

        %% plot scatter plot for visualization mode 0
        if (visualizationMode == 0)

            %% apply step selection to avoid displaying all cells if performance matters
            selectedIndices = validIndices(1:stepSize:end);

            %% show scatter plot
            scatter(d_org(selectedIndices,3), d_org(selectedIndices,4), 5, d_org(selectedIndices, selectedFeature), '.');
            axis equal;
            set(gca, 'YDir', 'reverse');

            title(kill_lz(dorgbez(selectedFeature,:)));
            xlabel('PositionX');
            ylabel('PositionY');
            colorbar;

        %% plot box plot for visualization mode 1
        elseif (visualizationMode == 1)

            %% plot the data in box plot format
            numGroups = length(unique(code));
            colorMap = lines(numGroups);
            groupColors = colorMap(1:numGroups, :);
            if (numGroups == 1)
                groupColors = [];
            end

            boxplot(d_org(:,selectedFeature), code, 'notch', 'on', 'BoxStyle', 'outline', 'Labels', outputLabels, 'ColorGroup', groupColors);
            box off;
            ylabel(kill_lz(dorgbez(selectedFeature,:)));
            
        %% plot histogram for visualization mode 2
        else

            %% plot dummy histogram to get the bin ranges on all cells
            h0 = histogram(d_org(validIndices, selectedFeature), numBins, 'Normalization', 'probability');
            binEdges = h0.BinEdges;
            %binWidth = h0.BinWidth;
            cla; hold on;

            %% plot individual histograms
            outputVariables = unique(code);
            for j=outputVariables'
                currentIndices = code == j & d_org(:,selectedFeature) >= lowerQuantile & d_org(:,selectedFeature) <= upperQuantile;
                
                %% plot the actual histograms for normal and tumor cells
                histogram(d_org(currentIndices, selectedFeature), binEdges, 'Normalization', 'probability');
            end

            legend(outputLabels);
            xlabel(kill_lz(dorgbez(selectedFeature,:)));
            ylabel('Frequency');
        end

        %% write result figure if output path is provided
        if (numColumns == 1 && numRows == 1 && ~isempty(outputFolder))
            imwrite(frame2im(getframe(gcf)), [outputFolder parameter.projekt.datei prefix '_' kill_lz(dorgbez(selectedFeature,:)) '.png']);
        end
    end
    
    %% write result figure if output path is provided
    if ((numColumns > 1 || numRows > 1) && ~isempty(outputFolder))
        imwrite(frame2im(getframe(gcf)), [outputFolder parameter.projekt.datei prefix '_Overview.png']);
    end
    
    colordef white;
end
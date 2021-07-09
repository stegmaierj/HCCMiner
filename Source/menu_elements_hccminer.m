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

function elements = menu_elements_hccminer(parameter)
% function elements = menu_elements_hccminer(parameter)
%
% 
% 
%  defines the menu items for the extension package hccminer
% 
%  Function menu_elements_hccminer is part of the extension package hccminer
%  Copyright (C) 200x  [hccminer Author Name]
%  This package was integrated in the MATLAB Toolbox Gait-CAD
%  Copyright (C) 2007  [Ralf Mikut, Tobias Loose, Ole Burmeister].
% 
%  This program is free software; you can redistribute it and/or modify,
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation; either version 2 of the License, or any later version.
% 
%  This program is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License along with this program;
%  if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
% 
% add the new entry at a new column of the handle list
%
% The function menu_elements_hccminer is part of the MATLAB toolbox SciXMiner. 
% Copyright (C) 2010  [Ralf Mikut, Tobias Loose, Ole Burmeister, Sebastian Braun, Andreas Bartschat, Johannes Stegmaier, Markus Reischl]


% Last file change: 15-Aug-2016 11:31:19
% 
% This program is free software; you can redistribute it and/or modify,
% it under the terms of the GNU General Public License as published by 
% the Free Software Foundation; either version 2 of the License, or any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along with this program;
% if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA.
% 
% You will find further information about SciXMiner in the manual or in the following conference paper:
% 
% 
% Please refer to this paper, if you use SciXMiner for your scientific work.

newcolumn = parameter.allgemein.uihd_column;
mc = 1;

%main element in the menu
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
%the tag must be unique
elements(mc).tag = 'MI_hccminer';
%name in the menu
elements(mc).name = 'HCCMiner';
%list of the functions in the menu, -1 is a separator
elements(mc).menu_items = {'MI_HCCMiner_Import', 'MI_HCCMiner_Show', 'MI_HCCMiner_Process'};
%is always enabled if a project exists
%further useful option: elements(mc).freischalt = {'1'}; %is always enabled
elements(mc).freischalt = {'1'}; 

%%%%%%%% IMPORT %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Import';
elements(mc).tag = 'MI_HCCMiner_Import';
elements(mc).menu_items = {'MI_HCCMiner_External_Dependencies', 'MI_HCCMiner_Import_Project'};


%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Set External Dependencies';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_hccminer_set_external_dependencies;';
elements(mc).tag = 'MI_HCCMiner_External_Dependencies';
%is enabled if at least one time series exist
elements(mc).freischalt = {};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Import New Experiments';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_hccminer_batch_import_projects;';
elements(mc).tag = 'MI_HCCMiner_Import_Project';
%is enabled if at least one time series exist
elements(mc).freischalt = {};


%%%%%%%%%% SHOW %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Show';
elements(mc).tag = 'MI_HCCMiner_Show';
elements(mc).menu_items = {'MI_HCCMiner_ShowHeatMaps', 'MI_HCCMiner_ShowBoxPlots', 'MI_HCCMiner_ShowHistogramPlots', 'MI_HCCMiner_ShowColoredSuperposition'};


%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Heatmaps';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'visualizationMode = 0; callback_hccminer_show(d_org, dorgbez, code, zgf_y_bez, parameter, visualizationMode, []);';
elements(mc).tag = 'MI_HCCMiner_ShowHeatMaps';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};


%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Box Plots';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'visualizationMode = 1; callback_hccminer_show(d_org, dorgbez, code, zgf_y_bez, parameter, visualizationMode, []);';
elements(mc).tag = 'MI_HCCMiner_ShowBoxPlots';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Histogram Plots';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'visualizationMode = 2; callback_hccminer_show(d_org, dorgbez, code, zgf_y_bez, parameter, visualizationMode, []);';
elements(mc).tag = 'MI_HCCMiner_ShowHistogramPlots';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = '3-Color Superposition';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'normalizationMode = 1; callback_hccminer_show_colored_superposition(d_org, dorgbez, parameter, normalizationMode, [], []);';
elements(mc).tag = 'MI_HCCMiner_ShowColoredSuperposition';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};



%%%%%%% PROCESS %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Process';
elements(mc).tag = 'MI_HCCMiner_Process';
elements(mc).menu_items = {'MI_HCCMiner_ComputeDensity', 'MI_HCCMiner_ComputeNumActiveNeighbors', 'MI_HCCMiner_VarianceFeature', 'MI_HCCMiner_AFRExpressionFeature', 'MI_HCCMiner_PrincipalComponents', 'MI_HCCMiner_RenameMarkers'};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Compute Density Feature';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_hccminer_compute_density;';
elements(mc).tag = 'MI_HCCMiner_ComputeDensity';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};


%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Compute Num Active Neighbors';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_hccminer_compute_num_active_neighbors;';
elements(mc).tag = 'MI_HCCMiner_ComputeNumActiveNeighbors';
%is enabled if at least one single feature exist
elements(mc).freischalt = {};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Compute Variance Features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_hccminer_compute_variance_features;';
elements(mc).tag = 'MI_HCCMiner_VarianceFeature'; 
%is enabled if at least one single feature exist
elements(mc).freischalt = {};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Compute Cleaned Expression Features';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_hccminer_compute_cleaned_expression_features;';
elements(mc).tag = 'MI_HCCMiner_AFRExpressionFeature'; 
%is enabled if at least one single feature exist
elements(mc).freischalt = {};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Compute Principal Components';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_hccminer_compute_principal_components;';
elements(mc).tag = 'MI_HCCMiner_PrincipalComponents'; 
%is enabled if at least one single feature exist
elements(mc).freischalt = {};

%%%%%%%%%%%%%%%%%%%%%%%%
mc = mc+1;
elements(mc).uihd_code = [newcolumn mc];
elements(mc).handle = [];
elements(mc).name = 'Rename Markers';
elements(mc).delete_pointerstatus = 0;
elements(mc).callback = 'callback_hccminer_rename_markers;';
elements(mc).tag = 'MI_HCCMiner_RenameMarkers'; 
%is enabled if at least one single feature exist
elements(mc).freischalt = {};



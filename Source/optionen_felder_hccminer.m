  function felder = optionen_felder_hccminer
% function felder = optionen_felder_hccminer
%
% 
% 
%
% The function optionen_felder_hccminer is part of the MATLAB toolbox SciXMiner. 
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

fc = 1;
felder(fc).name = 'HCCMiner';
felder(fc).subfeld = [];
felder(fc).subfeldbedingung = [];
felder(fc).visible = [];
felder(fc).in_auswahl = 1;

% BEGIN: DO NOT CHANGE THIS%PART%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Element: Optionen  
felder(fc).visible(end+1).i_control_elements = 'CE_Auswahl_Optionen';
felder(fc).visible(end).pos = [300 510];
felder(fc).visible(end).bez_pos_rel = [-280 -3];
% END: DO NOT CHANGE THIS%PART%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_NeighborhoodRadius';
felder(fc).visible(end).pos = [300 480];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_NumHistogramBins';
felder(fc).visible(end).pos = [300 450];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_QuantileThreshold';
felder(fc).visible(end).pos = [300 420];
felder(fc).visible(end).bez_pos_rel = [-280 -3];


%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_StepSize';
felder(fc).visible(end).pos = [300 390];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_CreateNewFigure';
felder(fc).visible(end).pos = [550 390];
felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_UseQuantileNormalizationForPlotting';
felder(fc).visible(end).pos = [550 360];
felder(fc).visible(end).bez_pos_rel = [];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_AutoFluorescenceCorrectionMethod';
felder(fc).visible(end).pos = [300 360];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_AutoFluorescenceCorrectionMultiplier';
felder(fc).visible(end).pos = [300 330];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_AutoFluorescenceCorrectionMinThreshold';
felder(fc).visible(end).pos = [300 300];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

%%%%%%%%%%%%%%%%%%
% Element: Linke/Rechte Einzüge verwenden
felder(fc).visible(end+1).i_control_elements = 'CE_hccminer_NumExpressionClasses';
felder(fc).visible(end).pos = [300 270];
felder(fc).visible(end).bez_pos_rel = [-280 -3];

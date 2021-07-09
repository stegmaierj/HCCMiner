  function els = control_elements_hccminer(parameter)
% function els = control_elements_hccminer(parameter)
%
% 
% function els = control_elements_hccminer
% defines all control elements (checkboxes, listboxes, edit boxes for the package)
% the visualization is done later by optionen_felder_package
% 
% 
%
% The function control_elements_hccminer is part of the MATLAB toolbox SciXMiner. 
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

els = [];

%number of the handle - added as the last column for the handle matrix 
newcolumn = parameter.allgemein.uihd_column;


%%%%%%%%%%%%%%%%%%%%%%%
% hccminer for the second control element (here: a edit field for numbers)
ec = 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_NeighborhoodRadius';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Neighborhood Radius';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.neighborhoodRadius';
%default value at the start
els(ec).default = 300;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 1;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {1, Inf};
%help text in the context menu
els(ec).tooltext = 'Radius used for computing neighborhood-related measures like density and variance';
%callback for any action at the element, can be empty
%the function should be exist in the path of the hccminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% hccminer for the second control element (here: a edit field for numbers)
ec = ec + 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_NumHistogramBins';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Num Histogram Bins';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.NumHistogramBins';
%default value at the start
els(ec).default = 255;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 1;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {1, Inf};
%help text in the context menu
els(ec).tooltext = 'Number of bins used for histogram visualizations.';
%callback for any action at the element, can be empty
%the function should be exist in the path of the hccminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% hccminer for the second control element (here: a edit field for numbers)
ec = ec + 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_QuantileThreshold';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Quantile Threshold';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.QuantileThreshold';
%default value at the start
els(ec).default = 0.01;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 0;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {0, 1};
%help text in the context menu
els(ec).tooltext = 'Quantile to use for quantile-based outlier rejection.';
%callback for any action at the element, can be empty
%the function should be exist in the path of the hccminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;


% hccminer for the second control element (here: a edit field for numbers)
ec = ec + 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_StepSize';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Scatter Plot Step Size';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.StepSize';
%default value at the start
els(ec).default = 1;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 1;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {1, Inf};
%help text in the context menu
els(ec).tooltext = 'Step size used for plotting scatter plots. If > 1, only every N-th point is plotted. Use for more performant plotting.';
%callback for any action at the element, can be empty
%the function should be exist in the path of the hccminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;



%%%%%%%%%%%%%%%%%%%%%%%
% hccminer for the second control element (here: a edit field for numbers)
ec = ec + 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_AutoFluorescenceCorrectionMethod';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'AF Correction Method';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.AutoFluorescenceCorrectionMethod';
%default value at the start
els(ec).default = 2;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 1;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {0, 3};
%help text in the context menu
els(ec).tooltext = 'Method used for removing the autofluorescene. 0: Do nothing, 1: fit Gaussian distribution and use mean+2*std as threshold, 2: search histogram mode and mirror the left part for removal.';
%callback for any action at the element, can be empty
%the function should be exist in the path of the hccminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% hccminer for the second control element (here: a edit field for numbers)
ec = ec + 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_AutoFluorescenceCorrectionMultiplier';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'AF Correction Multiplier';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.AutoFluorescenceCorrectionMultiplier';
%default value at the start
els(ec).default = 2;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 0;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {0, inf};
%help text in the context menu
els(ec).tooltext = 'Multiplier for the std. dev. if Gaussian-correction is used, else multiplier for the histogram mode.';
%callback for any action at the element, can be empty
%the function should be exist in the path of the hccminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% hccminer for the second control element (here: a edit field for numbers)
ec = ec + 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_AutoFluorescenceCorrectionMinThreshold';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'AF Correction Min Threshold';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.AutoFluorescenceCorrectionMinThreshold';
%default value at the start
els(ec).default = 0;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 0;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {0, inf};
%help text in the context menu
els(ec).tooltext = 'Minimum threshold that is used if auto-threshold is below this value.';
%callback for any action at the element, can be empty
%the function should be exist in the path of the hccminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;

%%%%%%%%%%%%%%%%%%%%%%%
% hccminer for the second control element (here: a edit field for numbers)
ec = ec + 1; 

%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_NumExpressionClasses';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Num Expression Classes';
%example for a checkbox
els(ec).style = 'edit';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.NumExpressionClasses';
%default value at the start
els(ec).default = 1;
%defines if the values should be integer values (=1) or not
els(ec).ganzzahlig = 1;
%defines the possible values, Inf is also possible
els(ec).wertebereich = {0, inf};
%help text in the context menu
els(ec).tooltext = 'The number of expression classes used for separating the positive cells.';
%callback for any action at the element, can be empty
%the function should be exist in the path of the hccminer package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text
els(ec).bezeichner.uihd_code = [newcolumn+1 ec];
els(ec).bezeichner.handle = [];
%width of the explanation text for the element in points
els(ec).bezeichner.breite = 250;
%height of the explanation text for the element in points
els(ec).bezeichner.hoehe = 20;


%%%%%%%%%%%%%%%%%%%%%%%
% hccminer for the second control element (here: a checkbox)
ec = ec+1; 
%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_CreateNewFigure';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Create New Figure?';
%example for a checkbox
els(ec).style = 'checkbox';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.CreateNewFigure';
%default value at the start
els(ec).default = 1;
%help text in the context menu
els(ec).tooltext = 'Used only for automatic plot generation to avoid generating new figures.';
%callback for any action at the element, can be empty
%the function should be exist tn the path of the chromatindec package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text, not neceessary for
%checkboxes
els(ec).bezeichner = [];

%%%%%%%%%%%%%%%%%%%%%%%
% hccminer for the second control element (here: a checkbox)
ec = ec+1; 
%Tag for the handling of the elements, the name must be unique
els(ec).tag = 'CE_hccminer_UseQuantileNormalizationForPlotting';
%number of the handle - added as the last column for the handle matrix 
els(ec).uihd_code = [newcolumn ec]; 
els(ec).handle = [];
%name shown in the GUI
els(ec).name = 'Use Quantile Normalization for Plotting?';
%example for a checkbox
els(ec).style = 'checkbox';
%the variable can be use for the access to the element value
els(ec).variable = 'parameter.gui.hccminer.UseQuantileNormalizationForPlotting';
%default value at the start
els(ec).default = 0;
%help text in the context menu
els(ec).tooltext = 'If enabled, quantile-based correction is used for plotting.';
%callback for any action at the element, can be empty
%the function should be exist tn the path of the chromatindec package
els(ec).callback = '';
%width of the element in points
els(ec).breite = 200;
%hight of the element in points
els(ec).hoehe = 20;
%optional handle of an additional GUI element with an explanation text, not neceessary for
%checkboxes
els(ec).bezeichner = [];

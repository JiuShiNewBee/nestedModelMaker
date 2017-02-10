% User-defined functions:
%
%	- specifyParentModelAndDirectories.m
%	- specifyOpenBoundaries.m
%
% Add important paths to source code and user-defined functions.
disp(' ')
%
% ----------------------------------------------------------------------------- 
%%% Parameters.

% Define the names of both the parent model, and of child model to be built.
child.name = 'gulfStreamComparison';
parent.name = 'ASTE';

% Number of months
parent.model.nMonths = 12;			

% ----------------------------------------------------------------------------- 
%%% Automation.

% Initialize the script by copying code to active directory and moving there.
eval( '!cp ./src/*.m ./active/')
eval(['!cp ./models/' child.name '/*.m ./active/'])

% Add active directory to pathEnter active directory active directory to path
addpath('./active/')

% Enter parameters of the parent model.
[dirz, parent] = specifyParentModelAndDirectories(parent, child);

% Check to make sure all's ok.
checkDirectories(dirz)
% checkParentModel(parent) 				% This function must be written.
% checkOpenBoundaries(parent, obij) 	% This function must be written.

% Specify boundaries (should be automated).
parentObij = specifyOpenBoundaries(parent); parent.nOb = length(parentObij);

% Get grid info along boundary and then extract obcs from full 3d parent fields.
parentObij = getOpenBoundaryGrid(dirz.parent.grid, parent, parentObij);
parentObuv = getOpenBoundaryConditions(dirz, parent, child, parentObij);

% Check-point open boundary files.
save([dirz.child.obcs 'obij_parent.mat'], 'parentObij')
save([dirz.child.obcs 'obuv_parent.mat'], 'parentObuv')

% ----------------------------------------------------------------------------- 

% Hack the 'initial' child open boundaries together.
child.zoom = 4;
child.nOb = parent.nOb;

% Get boundary indices for child grid.
for iOb = 1:child.nOb
	childObij{iOb} = transcribeOpenBoundaryParentToChild(parentObij{iOb}, child.zoom);
end

% Plot.
for iOb = 1:parent.nOb

	[ii, jj] = getOpenBoundaryIndices(parentObij{iOb}, 'local', parent.offset);

	% Plot bathymetry on the LLC grid with open boundary marked.
	visualizeOpenBoundary(dirz, parentObij{iOb})

	% Make a quick movie
	quickOpenBoundaryMovie(parent, parentObuv{iOb}, parentObij{iOb})

end

% Copy user-defined functions into model directory when script is complete.
%eval(['!cp -r ' pwd '/user ' dirz.child.home])

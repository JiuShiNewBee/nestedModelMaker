function obij = parseOpenBoundaries(parent)

% Initialize.
obij = [];
iOb = 0;

% ii-boundaries or "east-west" boundaries first.
for face = 1:5
    for side = 1:2
        % If boundary is open, generate an open boundary condition.
        if strcmp(parent.bcs.ii{face}{side}, 'open')
        
            % We have a new open boundary.
            iOb = iOb+1;

            % Set the boundary
            obij{iOb}.face = face;

            % Determine whether boundary is north or south.
            if side == 1
                obij{iOb}.edge = 'east';
            elseif side == 2
                obij{iOb}.edge = 'west';
            end

            % Indices.
            obij{iOb}.jj = parent.jj(face, 1):parent.jj(face, 2);
            obij{iOb}.ii = parent.ii(face, side)*ones(size(obij{iOb}.jj));
        
            % Length of open boundary
            obij{iOb}.nn = length(obij{iOb}.ii);

        end
    end
end
            
% jj-boundaries or "north-south" next.
for face = 1:5
    for side = 1:2
        % If boundary is open, generate an open boundary condition.
        if strcmp(parent.bcs.jj{face}{side}, 'open')
        
            % We have a new open boundary.
            iOb = iOb+1;

            % Set the boundary
            obij{iOb}.face = face;

            % Determine whether boundary is north or south.
            if side == 1
                obij{iOb}.edge = 'south';
            elseif side == 2
                obij{iOb}.edge = 'north';
            end

            % Indices.
            obij{iOb}.ii = parent.ii(face, 1):parent.ii(face, 2);
            obij{iOb}.jj = parent.jj(face, side)*ones(size(obij{iOb}.ii));

            % Length of open boundary
            obij{iOb}.nn = length(obij{iOb}.ii);

        end
    end
end

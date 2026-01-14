function x_next = f_cv(x, dt)
% Constant-velocity motion model in 2D (discrete time).
%   State: x = [px; py; vx; vy]
%   Inputs:
%     x  (4x1) state at time k
%     dt (1x1) timestep [s]
%   Output:
%     x_next (4x1) state at time k+1

% Input checks
assert(isequal(size(x), [4 1]), 'x must be 4x1');
assert(isscalar(dt) && dt > 0, 'dt must be a positive scalar');

% Unpack state
px = x(1);
py = x(2);
vx = x(3);
vy = x(4);

% Constant-velocity propagation
px_next = px + vx * dt;
py_next = py + vy * dt;
vx_next = vx;
vy_next = vy;

% Repack state
x_next = [px_next; py_next; vx_next; vy_next];

end

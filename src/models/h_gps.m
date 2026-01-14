function y = h_gps(x)
%H_GPS GPS position measurement model.
%   State: x = [px; py; vx; vy]
%   Measurement: y = [px; py]

% TODO: assert x is 4x1
assert(isequal(size(x), [4 1]), 'x must be 4x1');

% TODO: extract px and py
px = x(1);
py = x(2);

% TODO: pack y as 2x1
y = [px; py];

end

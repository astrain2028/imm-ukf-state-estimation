%% Housekeeping
clc
clear

%% Ensure script executes from the repository root regardless of launch location.
% This is required to make relative paths (src/, data/, results/) reproducible
% across different machines and experiment runs.
fullFilePath = mfilename('fullpath');
folderPath   = fileparts(fullFilePath);
cd(folderPath)

pwd;
%% Reproducibility (RNG + run ID)
% RNG is fixed so that the sim results are consistent unless code changes

SEED = 1;
rng(SEED);           % deterministic noise/fault realizations

t = datetime('now'); % current timestamp
runID = datestr(t, 'yyyy-mm-dd_HHMMSS');  

% Results directories (created if they don't exist)
resultsDir = fullfile(pwd, 'results');
figDir     = fullfile(resultsDir, 'figures');
runDir     = fullfile(resultsDir, 'runs');

% Prepare output directories for this experiment run
mkdir(resultsDir);
mkdir(figDir);
mkdir(runDir);

%% System definition: 2D constant-velocity (CV) + GPS position measurements

% State: x = [px; py; vx; vy]
nx = 4;
ny = 2;

% Initial condition (column vector)
x0 = [ 0; 0; 1; 0];   %px0, py0, vx0, vy0

% Initial covariance
P0 = diag([1^2, 1^2, 5^2, 5^2]); % Position is uncertain by ~1 meter
                                 % Velocity is uncertain by ~5 meter

% Measurement noise (GPS)
sigma_gps = 2;
R = (sigma_gps^2) * eye(ny); % Where R is the measurement noise covariance matrix
                             % variance = sigma^2

% Process noise (placeholder)
% We will later replace this with a proper discretized covariance Q(dt, sigma_a).
sigma_a = 0.5;
Q = (sigma_a^2) * diag([0.01, 0.01, 1.0, 1.0]);  % Where Q is process noise variance

% Model function handles
f = @f_cv;     % dynamics: x_{k+1} = f(x_k, dt)
h = @h_gps;    % measurement: y_k = h(x_k)

% Sanity checks (dimensions)
assert(isequal(size(x0), [nx 1]), 'x0 must be nx-by-1');
assert(isequal(size(P0), [nx nx]), 'P0 must be nx-by-nx');
assert(isequal(size(Q),  [nx nx]), 'Q must be nx-by-nx');
assert(isequal(size(R),  [ny ny]), 'R must be ny-by-ny');

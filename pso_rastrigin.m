function [best_fitness_curve, average_fitness_curve, best_solution] = pso_rastrigin(population_size, max_iterations)

% PSO_RASTRIGIN  Particle Swarm Optimization for 2D Rastrigin Function.

if nargin < 1, population_size = 50; end
if nargin < 2, max_iterations = 100; end

% Problem bounds
lower_bound = -5.12;
upper_bound =  5.12;
dimension = 2;

% PSO parameters
inertia_weight          = 0.7;    
cognitive_coefficient   = 1.5;    
social_coefficient      = 1.5;    

% Initialize particle positions and velocities
particle_positions  = lower_bound + (upper_bound - lower_bound) .* rand(population_size, dimension);
particle_velocities = zeros(population_size, dimension);


% Evaluate initial fitness
fitness_values = rastrigin(particle_positions);

% Initialize personal best positions and fitness
personal_best_positions = particle_positions;
personal_best_fitness   = fitness_values;

% Initialize global best
[global_best_fitness, best_index] = min(fitness_values);
global_best_position = particle_positions(best_index, :);

% Convergence curves
best_fitness_curve    = zeros(max_iterations, 1);
average_fitness_curve = zeros(max_iterations, 1);

for iteration = 1:max_iterations
    for i = 1:population_size
        % Random coefficients
        random_personal = rand(1, dimension);
        random_global   = rand(1, dimension);
        
        % Velocity update
        particle_velocities(i, :) = ...
            inertia_weight * particle_velocities(i, :) ...
            + cognitive_coefficient * random_personal .* (personal_best_positions(i, :) - particle_positions(i, :)) ...
            + social_coefficient    * random_global   .* (global_best_position - particle_positions(i, :));

        % Position update
        particle_positions(i, :) = particle_positions(i, :) + particle_velocities(i, :);
        
        % Clamp positions within bounds
        particle_positions(i, :) = max(min(particle_positions(i, :), upper_bound), lower_bound);

        % Evaluate new fitness
        current_fitness = rastrigin(particle_positions(i, :));
        fitness_values(i) = current_fitness;

        % Update personal best
        if current_fitness < personal_best_fitness(i)
            personal_best_fitness(i)   = current_fitness;
            personal_best_positions(i, :) = particle_positions(i, :);
        end

        % Update global best
        if current_fitness < global_best_fitness
            global_best_fitness = current_fitness;
            global_best_position = particle_positions(i, :);
        end
    end

    % Record statistics for plotting
    best_fitness_curve(iteration)    = global_best_fitness;
    average_fitness_curve(iteration) = mean(fitness_values);
end

best_solution = global_best_position;
end

% Helper: Rastrigin function
function fitness = rastrigin(input_matrix)
    A = 10;
    x = input_matrix(:, 1);
    y = input_matrix(:, 2);
    fitness = A * 2 + x.^2 + y.^2 - A * (cos(2*pi*x) + cos(2*pi*y));
end

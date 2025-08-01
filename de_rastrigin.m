function [best_fitness_curve, average_fitness_curve, best_solution] = de_rastrigin(population_size, max_generations)

% DE_RASTRIGIN  Differential Evolution (DE/rand/1/bin) for 2D Rastrigin Function.

if nargin < 1, population_size = 50; end
if nargin < 2, max_generations = 100; end

% Problem bounds
lower_bound = -5.12;
upper_bound =  5.12;
dimension = 2;

% DE parameters
differential_weight = 0.8;       
crossover_probability = 0.9;     

% Initialize population
population = lower_bound + (upper_bound - lower_bound) .* rand(population_size, dimension);
fitness_values = rastrigin(population);

% Initialize curves
best_fitness_curve = zeros(max_generations, 1);
average_fitness_curve = zeros(max_generations, 1);

% Track global best solution
[global_best_fitness, best_index] = min(fitness_values);
global_best_solution = population(best_index, :);

for generation = 1:max_generations
    new_population = population;  

    for i = 1:population_size
        % Mutation: choose r1, r2, r3 distinct from i
        random_indices = randperm(population_size, 4);  % get 4 distinct indices 
        if any(random_indices(1:3) == i)
            index_to_replace = find(random_indices(1:3) == i);
            random_indices(index_to_replace) = random_indices(4);
        end
        index_r1 = random_indices(1);
        index_r2 = random_indices(2);
        index_r3 = random_indices(3);

        % Compute mutant vector
        mutant_vector = population(index_r1, :) + ...
                        differential_weight * (population(index_r2, :) - population(index_r3, :));
        mutant_vector = max(min(mutant_vector, upper_bound), lower_bound);  % clamp to bounds

        % Binomial Crossover
        trial_vector = population(i, :);
        guaranteed_index = randi(dimension);  % ensure at least one dimension from mutant

        for j = 1:dimension
            if rand() < crossover_probability || j == guaranteed_index
                trial_vector(j) = mutant_vector(j);
            end
        end

        % Selection
        trial_fitness = rastrigin(trial_vector);
        if trial_fitness <= fitness_values(i)
            new_population(i, :) = trial_vector;
            fitness_values(i) = trial_fitness;

            % Update global best
            if trial_fitness < global_best_fitness
                global_best_fitness = trial_fitness;
                global_best_solution = trial_vector;
            end
        end
    end

    % Update population for next generation
    population = new_population;

    % Record convergence statistics
    best_fitness_curve(generation) = global_best_fitness;
    average_fitness_curve(generation) = mean(fitness_values);
end

best_solution = global_best_solution;
end

% Helper: Rastrigin function
function fitness = rastrigin(input_matrix)
    A = 10;
    x = input_matrix(:, 1);
    y = input_matrix(:, 2);
    fitness = A * 2 + x.^2 + y.^2 - A * (cos(2 * pi * x) + cos(2 * pi * y));
end

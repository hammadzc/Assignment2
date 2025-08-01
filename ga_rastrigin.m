function [best_fitness_curve, average_fitness_curve, best_solution] = ga_rastrigin(population_size, max_generations)

% GA_RASTRIGIN  Genetic Algorithm optimization for 2D Rastrigin function.

if nargin < 1, population_size = 50; end
if nargin < 2, max_generations = 100; end

% Problem bounds
lower_bound = -5.12;
upper_bound =  5.12;
dimension = 2;  

% GA parameters
crossover_probability = 0.8;
mutation_probability  = 0.1;
mutation_std_dev = 1.0;  

% Initialize population and evaluate fitness
population = lower_bound + (upper_bound - lower_bound) .* rand(population_size, dimension);
fitness_values = rastrigin(population);

% Initialize record-keeping
best_fitness_curve     = zeros(max_generations, 1);
average_fitness_curve  = zeros(max_generations, 1);

% Track the global best solution found
[global_best_fitness, best_index] = min(fitness_values);
global_best_solution = population(best_index, :);

for generation = 1:max_generations
    % Selection and reproduction ---
    new_population = zeros(population_size, dimension);
    
    for i = 1:2:population_size  % iterate in pairs
        % Tournament selection for two parents
        % Parent 1
        candidate1_index = randi(population_size);
        candidate2_index = randi(population_size);
        if fitness_values(candidate1_index) < fitness_values(candidate2_index)
            parent1 = population(candidate1_index, :);
        else
            parent1 = population(candidate2_index, :);
        end
        
        % Parent 2
        candidate3_index = randi(population_size);
        candidate4_index = randi(population_size);
        if fitness_values(candidate3_index) < fitness_values(candidate4_index)
            parent2 = population(candidate3_index, :);
        else
            parent2 = population(candidate4_index, :);
        end

        % Crossover
        offspring1 = parent1;
        offspring2 = parent2;
        if rand() < crossover_probability
            crossover_mask = rand(1, dimension) < 0.5;
            offspring1(crossover_mask) = parent2(crossover_mask);
            offspring2(crossover_mask) = parent1(crossover_mask);
        end

        % Mutation (Gaussian)
        for d = 1:dimension
            if rand() < mutation_probability
                offspring1(d) = offspring1(d) + mutation_std_dev * randn();
            end
            if rand() < mutation_probability
                offspring2(d) = offspring2(d) + mutation_std_dev * randn();
            end
        end
        
        % Clamp mutated values to bounds
        offspring1 = max(min(offspring1, upper_bound), lower_bound);
        offspring2 = max(min(offspring2, upper_bound), lower_bound);

        % Add to new population
        new_population(i, :) = offspring1;
        if i + 1 <= population_size
            new_population(i + 1, :) = offspring2;
        end
    end

    % Replace old population
    population = new_population;
    fitness_values = rastrigin(population);

    % Update global best
    [current_best_fitness, best_index] = min(fitness_values);
    if current_best_fitness < global_best_fitness
        global_best_fitness = current_best_fitness;
        global_best_solution = population(best_index, :);
    end

    % Record convergence
    best_fitness_curve(generation) = global_best_fitness;
    average_fitness_curve(generation) = mean(fitness_values);
end

best_solution = global_best_solution;
end

% Helper: Rastrigin function evaluation
function fitness = rastrigin(input_matrix)
    % input_matrix is an N x 2 matrix of [x, y] rows.
    % Returns column vector of f(x,y) for each row.
    A = 10;
    x = input_matrix(:, 1);
    y = input_matrix(:, 2);
    fitness = A*2 + x.^2 + y.^2 - A * (cos(2*pi*x) + cos(2*pi*y));
end

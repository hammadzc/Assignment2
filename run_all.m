% Master script to run GA, DE, PSO on Rastrigin function and log results

% Set common parameters
population_size = 50;
maximum_generations = 100;
rng(0);  % Set random seed for reproducibility

% Run Genetic Algorithm (GA)
[ga_best_fitness_curve, ga_average_fitness_curve, ga_best_solution] = ga_rastrigin(population_size, maximum_generations);
disp('Genetic Algorithm (GA) Best Solution:');
disp(ga_best_solution);
disp(['Final Best Fitness = ', num2str(ga_best_fitness_curve(end))]);
data_ga = [(1:maximum_generations)', ga_best_fitness_curve, ga_average_fitness_curve];
writematrix(data_ga, 'ga_results.csv');

% Run Differential Evolution (DE)
rng(0);  % Reset seed 
[de_best_fitness_curve, de_average_fitness_curve, de_best_solution] = de_rastrigin(population_size, maximum_generations);
disp('Differential Evolution (DE) Best Solution:');
disp(de_best_solution);
disp(['Final Best Fitness = ', num2str(de_best_fitness_curve(end))]);
data_de = [(1:maximum_generations)', de_best_fitness_curve, de_average_fitness_curve];
writematrix(data_de, 'de_results.csv');

% Run Particle Swarm Optimization (PSO)
rng(0);  % Reset seed 
[pso_best_fitness_curve, pso_average_fitness_curve, pso_best_solution] = pso_rastrigin(population_size, maximum_generations);
disp('Particle Swarm Optimization (PSO) Best Solution:');
disp(pso_best_solution);
disp(['Final Best Fitness = ', num2str(pso_best_fitness_curve(end))]);
data_pso = [(1:maximum_generations)', pso_best_fitness_curve, pso_average_fitness_curve];
writematrix(data_pso, 'pso_results.csv');

% Plot convergence curves for each algorithm

% GA convergence plot
figure;
plot(1:maximum_generations, ga_best_fitness_curve, 'r-', ...
     1:maximum_generations, ga_average_fitness_curve, 'r--', 'LineWidth', 1.5);
xlabel('Generation');
ylabel('Fitness');
title('GA Convergence');
legend('Best Fitness', 'Average Fitness');
grid on;
saveas(gcf, 'ga_convergence.png');

% DE convergence plot
figure;
plot(1:maximum_generations, de_best_fitness_curve, 'b-', ...
     1:maximum_generations, de_average_fitness_curve, 'b--', 'LineWidth', 1.5);
xlabel('Generation');
ylabel('Fitness');
title('DE Convergence');
legend('Best Fitness', 'Average Fitness');
grid on;
saveas(gcf, 'de_convergence.png');

% PSO convergence plot
figure;
plot(1:maximum_generations, pso_best_fitness_curve, 'g-', ...
     1:maximum_generations, pso_average_fitness_curve, 'g--', 'LineWidth', 1.5);
xlabel('Iteration');
ylabel('Fitness');
title('PSO Convergence');
legend('Best Fitness', 'Average Fitness');
grid on;
saveas(gcf, 'pso_convergence.png');

% Comparison plot of best fitness for all algorithms
figure;
plot(1:maximum_generations, ga_best_fitness_curve, 'r-', ...
     1:maximum_generations, de_best_fitness_curve, 'b-', ...
     1:maximum_generations, pso_best_fitness_curve, 'g-', 'LineWidth', 1.5);
xlabel('Generation');
ylabel('Best Fitness');
title('Best Fitness Convergence: GA vs DE vs PSO');
legend('GA', 'DE', 'PSO');
grid on;
saveas(gcf, 'compare_convergence.png');

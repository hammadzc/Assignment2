function f = rastrigin(X)

% Rastrigin function for 2D input

    A = 10;
    f = A * size(X,2) + sum(X.^2 - A * cos(2 * pi * X), 2);
end

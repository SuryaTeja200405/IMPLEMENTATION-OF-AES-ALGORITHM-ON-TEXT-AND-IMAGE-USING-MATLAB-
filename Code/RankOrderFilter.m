function y = RankOrderFilter(x, N, p)
% ----------------------------------------------------------------------- %

[m n] = size(x);
y = zeros(m,n);

if rem(N,2) == 1
    k = (N-1)/2;
else
    k = N /2;
end

for i=1:n
    X = [x(1,i)*ones(k,1);x(:,i);x(end,i)*ones(k,1)];
     for j=1:m
         y(j,i) = percentile(X(j:j+N-1), p);
    end
end
% ----------------------------------------------------------------------- %
% Percentile calculated the k'th percentile of x. This function is similar 
% to, but generally much faster than MATLAB's prctile function.
function y = percentile(x, k)
x = sort(x);
n = size(x,1);

p = 1 + (n-1) * k / 100;

if p == fix(p)
    y = x(p);
else
    r1 = floor(p); r2 = r1+1;
    y = x(r1) + (x(r2)-x(r1)) * k / 100;
end
% ----------------------------------------------------------------------- %
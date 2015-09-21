function [fidx,val,max_ig] = dt_choose_feature_multi(X, Z, Xrange, colidx)

[N,K]=size(Z);
fidx=0;
H = multi_entropy(sum(Z)/sum(sum(Z)));
ig = zeros(numel(Xrange), 1);
split_vals = zeros(numel(Xrange), 1);
fprintf('Evaluating features on %d examples: ', numel(Z));
for i = colidx

    % Check for constant values.
    if numel(Xrange{i}) == 1
        ig(i) = 0; split_vals(i) = 0;
        continue;
    end
    
    % Compute up to 10 possible splits of the feature.
    r = linspace(double(Xrange{i}(1)), double(Xrange{i}(end)), min(10, numel(Xrange{i})));
    split_f = bsxfun(@le, X(:,i), r(1:end-1));
    
    % Compute conditional entropy of all possible splits.
    px = mean(split_f);
    
    for k = 1:size(split_f,2)
        y_given_x{k} = bsxfun(@and, Z, split_f(:,k));
        y_given_notx{k} = bsxfun(@and, Z, ~split_f(:,k));
    end
    cond_H=zeros(1,size(split_f,2));
    for k=1:size(split_f,2)
    cond_H(k) = px(k).*multi_entropy( sum(y_given_x{k})/sum(sum(y_given_x{k}))) + ...
        (1-px(k)).*multi_entropy(sum(y_given_notx{k})/sum(sum(y_given_notx{k})));
    end
    % Choose split with best IG, and record the value split on.
    [ig(i) best_split] = max(H-cond_H);
    split_vals(i) = r(best_split);
end

[max_ig fidx] = max(ig);
val = split_vals(fidx);

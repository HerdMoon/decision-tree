function root = build_dt(X, Y, depth_limit)

for i = 1:size(X, 2)
    Xrange{i} = unique(X(:,i));
end
orginal_value=[grpstats(zeros(1,size(Y,1)),Y,'numel')/size(Y,1) unique(Y)];
root = split_node_multi(X, Y, Xrange,orginal_value, 1:size(Xrange, 2), 0, depth_limit);

function [node] = split_node_multi(X, Y, Xrange, default_value, colidx, depth, depth_limit)
if depth == depth_limit || numel(unique(Y))==1 || numel(Y) <= 1 || numel(colidx) == 0
    node.terminal = true;
    node.fidx = [];
    node.fval = [];
    if numel(Y) == 0
        node.value = default_value;
    else
        node.value = [grpstats(zeros(1,size(Y,1)),Y,'numel')/size(Y,1) unique(Y)];
    end
    node.left = []; node.right = [];
    
    fprintf('depth %d [%d/%d]: Leaf node: = %s\n', depth, sum(Y==0), sum(Y==1), ...
        mat2str(node.value));
    return;
end

node.terminal = false;
N=length(Y);
Yrange=unique(Y);
Z=zeros(N,length(Yrange));

for k =1:length(Yrange)
    kidx=find(Y==Yrange(k));
    Z(kidx,k)=1;
end

% Choose a feature to split on using information gain.
[node.fidx node.fval max_ig] = dt_choose_feature_multi(X,Z, Xrange, colidx);

% Remove this feature from future consideration.
colidx(colidx==node.fidx) = [];

% Split the data based on this feature.
leftidx = find(X(:,node.fidx)<=node.fval);
rightidx = find(X(:,node.fidx)>node.fval);



% Store the value of this node in case we later wish to use this node as a
% terminal node (i.e. pruning.)
node.value = [grpstats(zeros(1,size(Y,1)),Y,'numel')/size(Y,1) unique(Y)];

fprintf('depth %d [%d]: Split on feature %d <= %.2f w/ IG = %.2g (L/R = %d/%d)\n', ...
    depth, numel(Y), node.fidx, node.fval, max_ig, numel(leftidx), numel(rightidx));

% Recursively generate left and right branches.

node.left = split_node_multi(X(leftidx, :), Y(leftidx), Xrange, node.value, colidx, depth+1, depth_limit);
node.right = split_node_multi(X(rightidx, :), Y(rightidx), Xrange, node.value, colidx, depth+1, depth_limit);

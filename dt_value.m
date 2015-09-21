function [p] = dt_value(t, x)

node = t; % Start at root
while ~node.terminal
    if x(node.fidx) <= node.fval
        node = node.left;
    else
        node = node.right;
    end
end
if size(node.value,1)==1
    p=node.value(1,2);
else
    [~, index]=max(node.value(:,1));   
    p=node.value(index,2);
end

[X Y] = get_digit_dataset(data, {'1','3','7'}, 'train');
[Xtest Ytest] = get_digit_dataset(data, {'1','3','7'}, 'test');
 train_err=zeros(1,6);
 test_err=zeros(1,6);
for n = 1:6
    dt = dt_train_multi(X, Y, n);
    Yhat = zeros(size(Y));
    for i = 1:size(X,1)
        Yhat(i) = dt_value(dt, X(i,:));
    end
    train_err(n)=mean(Yhat ~= Y);
    Yhat = zeros(size(Ytest));
    for i = 1:size(Xtest,1)
        Yhat(i) =  dt_value(dt, Xtest(i,:));
    end
    test_err(n)=mean(Yhat ~= Ytest);
end
figure(1)
plot(1:6,[train_err;test_err]);
xlabel('DT depth');
ylabel('Error');
title('DT w/train=1,3,7');
legend('train error','test error');
print(1,'plot_err.jpg','-djpeg');

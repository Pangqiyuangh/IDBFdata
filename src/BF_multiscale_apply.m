function y = BF_multiscale_apply(Factors, x)

if( size(x,2)==0 )
    return;
end

y = zeros(size(x));

for i=1:size(Factors,1)-1
    y = y + BF_apply(Factors{i,1},x(Factors{i,2},:));
end
y = y + Factors{end,1}*x(Factors{end,2},:);

end
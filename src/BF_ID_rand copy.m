function [T,idx,sk,rd] = BF_ID_rand(fun,x,k,rank,tol,r_or_c,opt)
% Compute ID approximation A(:,rd) ~ A(:,sk)*T. 
% A =fun(x,k)
% The precision is specified by tol and the rank is given by 'rank'; 
% r_or_c specify row ID or column ID
% opt - whether use adaptive rank or fix rank
%       if opt = 0, fix rank rk in the ID no matter what tol is
%       if opt = 1, use a rank less than or equal to rk trying to obtain an
%        accuracy as good as tol; may not be able to achieve tol if rk is
%        too small
%
% Copyright 2018 Haizhao Yang

if nargin < 7, opt = 1; end
if nargin < 6, r_or_c = 'c'; end % sk is column index

rr = 5*rank;
xlen = size(x,1);
klen = size(k,1);
switch r_or_c
    case 'c'
        if xlen*klen == 0
            sk = [];
            idx = [];
            rd = 1:klen;
            T = zeros(0,klen);
            return
        end
        
        if rr < xlen
            idxx = randperm(xlen);
        else
            idxx = 1:xlen;
        end
        px = x(idxx(1:min(xlen,rr)),:);
        
        Asub = fun(px,k);
        
        [~,R,E] = qr(Asub,0);
        if opt > 0
            if xlen*klen > 0
                rr = find( abs(diag(R)/R(1)) > tol, 1, 'last');
                rr = min(rank,rr);
            end
        else
            rr = rank;
        end
        idx = E(1:min(klen,rr));
        rd = E(min(klen,rr)+1:end);
        sk = k(idx,:);
        T = R(1:rr,1:rr)\R(1:rr,rr+1:end);
    case 'r'
        if xlen*klen == 0
            sk = [];
            idx = [];
            rd = 1:xlen;
            T = zeros(xlen,0);
            return
        end
        if rr < klen
            idxk = randperm(klen);
        else
            idxk = 1:klen;
        end
        pk = k(idxk(1:min(klen,rr)),:);
        
        Asub = fun(x,pk);
        
        [~,R,E] = qr(Asub',0);
        if opt > 0
            if xlen*klen > 0
                rr = find( abs(diag(R)/R(1)) > tol, 1, 'last');
                rr = min(rank,rr);
            end
        else
            rr = rank;
        end
        idx = E(1:min(xlen,rr));
        rd = E(min(xlen,rr)+1:end);
        sk = x(idx,:);
        T = R(1:rr,1:rr)\R(1:rr,rr+1:end);
end
end

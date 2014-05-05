function [ stand_mat ] = standardize_test( data_mat,mean_a,std_a)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    m = size(data_mat,1);
    mean_mat = ones(m,1)*mean_a;
    std_mat = ones(m,1)*std_a;
    stand_mat = (data_mat - mean_mat)./std_mat;
    const_i = find(std_a==0);
    for i = const_i
        stand_mat(:,i) = ones(m,1);
    end
end


function flag = get_matrix_correct_flag(alpha, alpha_dir, beta, beta_dir)
    % correct flag for alpha or beta is one
    c_alpha = 1; 
    c_beta = 1;
    if alpha == 1 && sum(alpha_dir) == 1
        c_alpha = -1;
    end
    if  beta == 1 && sum(beta_dir) == 1
        c_beta = -1;
    end
    flag = c_alpha*c_beta;
    flag = flag == -1;
end
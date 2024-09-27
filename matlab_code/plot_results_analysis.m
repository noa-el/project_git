function plot_results_analysis(matlab_output_file, analysis_output_file)
    % input: 
    % matlab_output_file: the matlab output file path
    % analysis_output_file: the analysis results file path
    % the function plots analysis results graphs 

    % check - relevant files exist
    if (isfile(analysis_output_file) & isfile(matlab_output_file))

        % load the matlab output file and analysis results
        load(matlab_output_file, "timesteps", "num_atoms", "box_bounds", "atom_data_tensor");
        load(analysis_output_file, "dt","square_diff_mean", "square_diff_std")

        % plot the <(Xt-X0^2)> as a function of t with errorbars
        figure(1)
        errorbar(dt,square_diff_mean,square_diff_std)
        xlabel('$\Delta t$', 'Interpreter', 'latex')
        ylabel('$\langle(x_t-x_0)^2\rangle$', 'Interpreter', 'latex')
        xlim([0 timesteps(end)+timesteps(2)])

        % plot the <(Xt-X0^2)> as a function of t in loglog scale
        figure(2)
        loglog(dt,square_diff_mean)
        xlabel('$\Delta t$', 'Interpreter', 'latex')
        ylabel('$\langle(x_t-x_0)^2\rangle$', 'Interpreter', 'latex')
    end
end


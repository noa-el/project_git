function analysis_output_file = results_analysis(matlab_output_file, output_dir, all_flag, hist_flag)
    % input:
    % matlab_output_file: path of simulation output matlab files
    % output_dir: output directory
    % all_flag: use all samples for calculation
    % hist_flag: plot histogram of one step distance
    
    % output:
    % analysis_output_file: analysis output file path

    % function calculates and saves <(Xt-X0^2)> and SEM
    % based on all relevant sampels for any particle if all_flag
    % else, based on a constant number of samples
    % plots histogram of one step distance if hist_flag

    % analysis output file path
    analysis_output_file = [output_dir '/analysis.mat'];
    % if the output file already exists, no need to run analysis again
    if (~isfile(analysis_output_file))
        load(matlab_output_file, "timesteps", "num_atoms", "box_bounds", "atom_data_tensor");
        % number of examples to take to shorten calculations (not relevant if all_flag == 1)
        num_examples = 5000;
        % extract atom locations from data and perform unwrap_trajectories
        atom_locations = unwrap_trajectories(atom_data_tensor(:,3:5,:), box_bounds);

        % if ~all_flag, long time differences do not have the needed number
        % of examples so axis is shorter
        if all_flag
            dt = timesteps(2:end);
        else
            dt = timesteps(2:end - num_examples - 1);
        end
    
        % initiate vector for <(Xt-X0^2)>
        square_diff_mean = zeros(1,length(dt));
        % initiate vector for SEM for errorbars
        square_diff_std = zeros(1,length(dt));
    
        for dt_ind = 1:length(dt)

            if all_flag
                % use all samples with same delta t 
                % for example - for delta t = 3 take
                % x(t=3) - x(t=0) ; x(t=4) - x(t=1) ; x(t=5) - x(t=2) etc
                square_diff = sum((atom_locations(:,:,dt_ind + 1:end) - atom_locations(:,:,1:end - dt_ind)).^2,2);
            else
                % take only num_examples first samples instead of all
                % to make calculation shorter and take same amount of
                % examples for all calculations
                square_diff = sum((atom_locations(:,:,dt_ind + 1:dt_ind + 1 + num_examples) - atom_locations(:,:,1:1 + num_examples)).^2,2);
            end
            square_diff_vec = square_diff(:);
            % one step analysis
            if dt_ind == 1 & hist_flag
                % plot histogram of one step distance
                figure(4);
                histogram(sqrt(square_diff_vec));
                xlabel('distance');
                ylabel('count');
                title(['first step distance histogram timestep ' num2str(dt(1))]);
            end
            % calculate <(Xt-X0^2)>
            square_diff_mean(dt_ind) = mean(square_diff_vec);
            % calculate SEM for errorbars
            square_diff_std(dt_ind) = std(square_diff_vec) / sqrt(length(square_diff_vec) - 1);
        end
        % save analysis results
        save(analysis_output_file, "dt","square_diff_mean", "square_diff_std")
    end
end


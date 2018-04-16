SLAM for Cyclopes: A MonoSLAM Tutorial

Main functions(located in src folder):

1.) run_monoslam(): Processes image frames and implement monoSLAM algorithm. Saves state and covariance history in file titled 'saved_run.mat'

2.) initialize(): Called by run_monoslam, initializes all state and environment parameters. Also determines what image directory is going to be processed for monoSLAM

3.) plot_trajectory_and_landmarks(mu_history): Needs to be called after run_monoslam(). Takes values in saved_run.mat and plots the trajectory of the camera for the previously processed data set.

4.) plot_num_landmarks(): Needs to be called after run_monoslam(). Takes values in saved_run.mat and plots the number of landmarks in the map for each time step.

5.) plot_image_and_features: Needs to be called after run_monoslam(). Takes values in saved_run.mat and plots the image frame with superimposed detected features.

Data sets(located in data folder)

1.) The first data set was generated to test a straight line path for the camera (rotation limited)

2.) The second data set was generated to test an upside-down U path for the camera (rotation limited)

Papers(located in paper folder)

Available here is Davison's original paper on MonoSLAM accompanied by a tutorial that is available in his website. Link to website is provided below;
 
http://www.doc.ic.ac.uk/~ajd/Scene/download.html

CREATE TABLE libraries(
library_id SERIAL PRIMARY KEY,
pose_optim_lib VARCHAR (30) NOT NULL,
lba_optim_lib VARCHAR (30) NOT NULL,
sim3_optim_lib VARCHAR (30) NOT NULL, graph_optim_lib VARCHAR (30) NOT NULL);


 CREATE TABLE methods(
method_id SERIAL PRIMARY KEY,
pose_optim_method VARCHAR (60) NOT NULL,
lba_optim_method VARCHAR (60) NOT NULL,
sim3_optim_method VARCHAR (60) NOT NULL, graph_optim_method VARCHAR (60) NOT NULL);

CREATE TABLE results(
result_id SERIAL PRIMARY KEY,
trajectory_path VARCHAR (255) NOT NULL,
tracking_time_average DOUBLE PRECISION NOT NULL,
tracking_time_median DOUBLE PRECISION NOT NULL);

CREATE TABLE advanced_ceres(
ceres_adv_id SERIAL PRIMARY KEY,
minimizer_type VARCHAR (50) NOT NULL,
trust_region_type VARCHAR (50),
dogleg_type VARCHAR (50),
initial_trust_region_radius DOUBLE PRECISION,
line_search_direction_type VARCHAR (50),
line_search_type VARCHAR(50),
nonlinear_conjugate_gradient_type VARCHAR(50),
gradient_tolerance DOUBLE PRECISION NOT NULL,
function_tolerance DOUBLE PRECISION NOT NULL,
linear_solver_type VARCHAR (50) NOT NULL,
max_num_iterations INTEGER NOT NULL,
minimizer_progress_to_stdout BOOLEAN NOT NULL,
num_threads INTEGER NOT NULL,
eta DOUBLE PRECISION NOT NULL,
max_solver_time_in_seconds DOUBLE PRECISION NOT NULL,
use_nonmonotonic_steps BOOLEAN NOT NULL);

INSERT INTO advanced_ceres (minimizer_type, trust_region_type, initial_trust_region_radius, gradient_tolerance, function_tolerance, linear_solver_type, max_num_iterations,
							minimizer_progress_to_stdout, num_threads, eta, max_solver_time_in_seconds, use_nonmonotonic_steps) VALUES ('TRUST_REGION', 'LEVENBERG_MARQUARDT', 1e4, 1e-16, 1e-16, 'SPARSE_SCHUR', 5, TRUE, 1, 1e-2, 1e32, TRUE) returning ceres_adv_id;

CREATE TABLE advanced_g2o(
g2o_adv_id SERIAL PRIMARY KEY,
method VARCHAR (50) NOT NULL);

INSERT INTO advanced_g2o (method) VALUES ('levenberg-marquardt');
INSERT INTO advanced_g2o (method) VALUES ('gauss-newton');
INSERT INTO advanced_g2o (method) VALUES ('dogleg');

CREATE TABLE advanced(
advanced_id SERIAL PRIMARY KEY,
pose_ceres INTEGER REFERENCES advanced_ceres,
pose_g2o INTEGER REFERENCES advanced_g2o,
lba_ceres INTEGER REFERENCES advanced_ceres,
lba_g2o INTEGER REFERENCES advanced_g2o,
sim3_ceres INTEGER REFERENCES advanced_ceres,
sim3_g2o INTEGER REFERENCES advanced_g2o,
graph_ceres INTEGER REFERENCES advanced_ceres,
graph_g2o INTEGER REFERENCES advanced_g2o);

CREATE TABLE experiments(
experiment_id SERIAL PRIMARY KEY,
dataset_name VARCHAR (60) NOT NULL,
libraries INTEGER REFERENCES libraries,
methods INTEGER REFERENCES methods,
advanced INTEGER REFERENCES advanced,
results INTEGER REFERENCES results ON DELETE CASCADE);

INSERT INTO libraries (pose_optim_lib, lba_optim_lib, sim3_optim_lib, graph_optim_lib) VALUES ('g2o', 'g2o', 'g2o', 'g2o'),
	('g2o', 'g2o', 'g2o', 'ceres'),
	('g2o', 'g2o', 'ceres', 'g2o'),
	('g2o', 'g2o', 'ceres', 'ceres'),
	('g2o', 'ceres', 'g2o', 'g2o'),
	('g2o', 'ceres', 'g2o', 'ceres'),
	('g2o', 'ceres', 'ceres', 'g2o'),
	('g2o', 'ceres', 'ceres', 'ceres'),
	('ceres', 'g2o', 'g2o', 'g2o'),
	('ceres', 'g2o', 'g2o', 'ceres'),
	('ceres', 'g2o', 'ceres', 'g2o'),
	('ceres', 'g2o', 'ceres', 'ceres'),
	('ceres', 'ceres', 'g2o', 'g2o'),
	('ceres', 'ceres', 'g2o', 'ceres'),
	('ceres', 'ceres', 'ceres', 'g2o'),
	('ceres', 'ceres', 'ceres', 'ceres');

INSERT INTO methods (pose_optim_method, lba_optim_method, sim3_optim_method, graph_optim_method) VALUES ('Levenberg-Marquardt', 'Levenberg-Marquardt', 'Levenberg-Marquardt', 'Levenberg-Marquardt'),
	('Levenberg-Marquardt', 'Levenberg-Marquardt', 'Levenberg-Marquardt', 'Gauss-Newton'),
	('Levenberg-Marquardt', 'Levenberg-Marquardt', 'Levenberg-Marquardt', 'Dogleg'),
	('Levenberg-Marquardt', 'Levenberg-Marquardt', 'Gauss-Newton', 'Levenberg-Marquardt'),
	('Levenberg-Marquardt', 'Levenberg-Marquardt', 'Gauss-Newton', 'Gauss-Newton'),
	('Levenberg-Marquardt', 'Levenberg-Marquardt', 'Gauss-Newton', 'Dogleg'),
	('Levenberg-Marquardt', 'Levenberg-Marquardt', 'Dogleg', 'Levenberg-Marquardt'),
	('Levenberg-Marquardt', 'Levenberg-Marquardt', 'Dogleg', 'Gauss-Newton'),
	('Levenberg-Marquardt', 'Levenberg-Marquardt', 'Dogleg', 'Dogleg'),
	('Levenberg-Marquardt', 'Gauss-Newton', 'Levenberg-Marquardt', 'Levenberg-Marquardt'),
	('Levenberg-Marquardt', 'Gauss-Newton', 'Levenberg-Marquardt', 'Gauss-Newton'),
	('Levenberg-Marquardt', 'Gauss-Newton', 'Levenberg-Marquardt', 'Dogleg'),
	('Levenberg-Marquardt', 'Gauss-Newton', 'Gauss-Newton', 'Levenberg-Marquardt'),
	('Levenberg-Marquardt', 'Gauss-Newton', 'Gauss-Newton', 'Gauss-Newton'),
	('Levenberg-Marquardt', 'Gauss-Newton', 'Gauss-Newton', 'Dogleg'),
	('Levenberg-Marquardt', 'Gauss-Newton', 'Dogleg', 'Levenberg-Marquardt'),
	('Levenberg-Marquardt', 'Gauss-Newton', 'Dogleg', 'Gauss-Newton'),
	('Levenberg-Marquardt', 'Gauss-Newton', 'Dogleg', 'Dogleg'),
	('Levenberg-Marquardt', 'Dogleg', 'Levenberg-Marquardt', 'Levenberg-Marquardt'),
	('Levenberg-Marquardt', 'Dogleg', 'Levenberg-Marquardt', 'Gauss-Newton'),
	('Levenberg-Marquardt', 'Dogleg', 'Levenberg-Marquardt', 'Dogleg'),
	('Levenberg-Marquardt', 'Dogleg', 'Gauss-Newton', 'Levenberg-Marquardt'),
	('Levenberg-Marquardt', 'Dogleg', 'Gauss-Newton', 'Gauss-Newton'),
	('Levenberg-Marquardt', 'Dogleg', 'Gauss-Newton', 'Dogleg'),
	('Levenberg-Marquardt', 'Dogleg', 'Dogleg', 'Levenberg-Marquardt'),
	('Levenberg-Marquardt', 'Dogleg', 'Dogleg', 'Gauss-Newton'),
	('Levenberg-Marquardt', 'Dogleg', 'Dogleg', 'Dogleg'),
	('Gauss-Newton', 'Levenberg-Marquardt', 'Levenberg-Marquardt', 'Levenberg-Marquardt'),
	('Gauss-Newton', 'Levenberg-Marquardt', 'Levenberg-Marquardt', 'Gauss-Newton'),
	('Gauss-Newton', 'Levenberg-Marquardt', 'Levenberg-Marquardt', 'Dogleg'),
	('Gauss-Newton', 'Levenberg-Marquardt', 'Gauss-Newton', 'Levenberg-Marquardt'),
	('Gauss-Newton', 'Levenberg-Marquardt', 'Gauss-Newton', 'Gauss-Newton'),
	('Gauss-Newton', 'Levenberg-Marquardt', 'Gauss-Newton', 'Dogleg'),
	('Gauss-Newton', 'Levenberg-Marquardt', 'Dogleg', 'Levenberg-Marquardt'),
	('Gauss-Newton', 'Levenberg-Marquardt', 'Dogleg', 'Gauss-Newton'),
	('Gauss-Newton', 'Levenberg-Marquardt', 'Dogleg', 'Dogleg'),
	('Gauss-Newton', 'Gauss-Newton', 'Levenberg-Marquardt', 'Levenberg-Marquardt'),
	('Gauss-Newton', 'Gauss-Newton', 'Levenberg-Marquardt', 'Gauss-Newton'),
	('Gauss-Newton', 'Gauss-Newton', 'Levenberg-Marquardt', 'Dogleg'),
	('Gauss-Newton', 'Gauss-Newton', 'Gauss-Newton', 'Levenberg-Marquardt'),
	('Gauss-Newton', 'Gauss-Newton', 'Gauss-Newton', 'Gauss-Newton'),
	('Gauss-Newton', 'Gauss-Newton', 'Gauss-Newton', 'Dogleg'),
	('Gauss-Newton', 'Gauss-Newton', 'Dogleg', 'Levenberg-Marquardt'),
	('Gauss-Newton', 'Gauss-Newton', 'Dogleg', 'Gauss-Newton'),
	('Gauss-Newton', 'Gauss-Newton', 'Dogleg', 'Dogleg'),
	('Gauss-Newton', 'Dogleg', 'Levenberg-Marquardt', 'Levenberg-Marquardt'),
	('Gauss-Newton', 'Dogleg', 'Levenberg-Marquardt', 'Gauss-Newton'),
	('Gauss-Newton', 'Dogleg', 'Levenberg-Marquardt', 'Dogleg'),
	('Gauss-Newton', 'Dogleg', 'Gauss-Newton', 'Levenberg-Marquardt'),
	('Gauss-Newton', 'Dogleg', 'Gauss-Newton', 'Gauss-Newton'),
	('Gauss-Newton', 'Dogleg', 'Gauss-Newton', 'Dogleg'),
	('Gauss-Newton', 'Dogleg', 'Dogleg', 'Levenberg-Marquardt'),
	('Gauss-Newton', 'Dogleg', 'Dogleg', 'Gauss-Newton'),
	('Gauss-Newton', 'Dogleg', 'Dogleg', 'Dogleg'),
	('Dogleg', 'Levenberg-Marquardt', 'Levenberg-Marquardt', 'Levenberg-Marquardt'),
	('Dogleg', 'Levenberg-Marquardt', 'Levenberg-Marquardt', 'Gauss-Newton'),
	('Dogleg', 'Levenberg-Marquardt', 'Levenberg-Marquardt', 'Dogleg'),
	('Dogleg', 'Levenberg-Marquardt', 'Gauss-Newton', 'Levenberg-Marquardt'),
	('Dogleg', 'Levenberg-Marquardt', 'Gauss-Newton', 'Gauss-Newton'),
	('Dogleg', 'Levenberg-Marquardt', 'Gauss-Newton', 'Dogleg'),
	('Dogleg', 'Levenberg-Marquardt', 'Dogleg', 'Levenberg-Marquardt'),
	('Dogleg', 'Levenberg-Marquardt', 'Dogleg', 'Gauss-Newton'),
	('Dogleg', 'Levenberg-Marquardt', 'Dogleg', 'Dogleg'),
	('Dogleg', 'Gauss-Newton', 'Levenberg-Marquardt', 'Levenberg-Marquardt'),
	('Dogleg', 'Gauss-Newton', 'Levenberg-Marquardt', 'Gauss-Newton'),
	('Dogleg', 'Gauss-Newton', 'Levenberg-Marquardt', 'Dogleg'),
	('Dogleg', 'Gauss-Newton', 'Gauss-Newton', 'Levenberg-Marquardt'),
	('Dogleg', 'Gauss-Newton', 'Gauss-Newton', 'Gauss-Newton'),
	('Dogleg', 'Gauss-Newton', 'Gauss-Newton', 'Dogleg'),
	('Dogleg', 'Gauss-Newton', 'Dogleg', 'Levenberg-Marquardt'),
	('Dogleg', 'Gauss-Newton', 'Dogleg', 'Gauss-Newton'),
	('Dogleg', 'Gauss-Newton', 'Dogleg', 'Dogleg'),
	('Dogleg', 'Dogleg', 'Levenberg-Marquardt', 'Levenberg-Marquardt'),
	('Dogleg', 'Dogleg', 'Levenberg-Marquardt', 'Gauss-Newton'),
	('Dogleg', 'Dogleg', 'Levenberg-Marquardt', 'Dogleg'),
	('Dogleg', 'Dogleg', 'Gauss-Newton', 'Levenberg-Marquardt'),
	('Dogleg', 'Dogleg', 'Gauss-Newton', 'Gauss-Newton'),
	('Dogleg', 'Dogleg', 'Gauss-Newton', 'Dogleg'),
	('Dogleg', 'Dogleg', 'Dogleg', 'Levenberg-Marquardt'),
	('Dogleg', 'Dogleg', 'Dogleg', 'Gauss-Newton'),
	('Dogleg', 'Dogleg', 'Dogleg', 'Dogleg');
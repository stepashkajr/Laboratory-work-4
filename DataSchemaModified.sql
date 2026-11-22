CREATE TABLE users (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
);

CREATE TABLE exercises (
    exercise_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    exercise_name TEXT NOT NULL,
    purpose TEXT NOT NULL,
    execution_order TEXT NOT NULL,
    CONSTRAINT exercises_name_check
    CHECK (exercise_name ~ '[^[:space:]]'),
    CONSTRAINT exercises_purpose_check
    CHECK (purpose ~ '[^[:space:]]'),
    CONSTRAINT exercises_order_check
    CHECK (LENGTH(TRIM(execution_order)) > 0)
);

CREATE TABLE exercise_selections (
    user_id BIGINT NOT NULL,
    exercise_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, exercise_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (exercise_id) REFERENCES exercises (exercise_id)
);

CREATE TABLE preparation_instructions (
    exercise_id BIGINT PRIMARY KEY,
    preparation_steps TEXT NOT NULL,
    FOREIGN KEY (exercise_id) REFERENCES exercises (exercise_id),
    CONSTRAINT preparation_steps_check
    CHECK (LENGTH(TRIM(preparation_steps)) > 0)
);

CREATE TABLE exercise_executions (
    execution_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL,
    exercise_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (exercise_id) REFERENCES exercises (exercise_id)
);

CREATE TABLE movement_measurements (
    measurement_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    execution_id BIGINT NOT NULL,
    time_mark NUMERIC NOT NULL,
    acceleration_x DOUBLE PRECISION NOT NULL,
    acceleration_y DOUBLE PRECISION NOT NULL,
    acceleration_z DOUBLE PRECISION NOT NULL,
    angular_velocity_x DOUBLE PRECISION NOT NULL,
    angular_velocity_y DOUBLE PRECISION NOT NULL,
    angular_velocity_z DOUBLE PRECISION NOT NULL,
    FOREIGN KEY (execution_id)
    REFERENCES exercise_executions (execution_id),
    CONSTRAINT measurement_time_check
    CHECK (time_mark >= 0)
);

CREATE TABLE gait_results (
    execution_id BIGINT PRIMARY KEY,
    cadence DOUBLE PRECISION NOT NULL,
    step_count INTEGER NOT NULL,
    movement_stability DOUBLE PRECISION NOT NULL,
    FOREIGN KEY (execution_id)
    REFERENCES exercise_executions (execution_id),
    CONSTRAINT cadence_check
    CHECK (cadence >= 0),
    CONSTRAINT step_count_check
    CHECK (step_count >= 0),
    CONSTRAINT movement_stability_check
    CHECK (movement_stability >= 0)
);

CREATE TABLE users ( -- опис користувачів
    user_id BIGINT -- ідентифікатор користувача
);

CREATE TABLE exercises ( -- опис вправ на відновлення ходи
    exercise_id BIGINT, -- ідентифікатор вправи
    name TEXT, -- назва вправи
    purpose TEXT, -- призначення вправи
    execution_order TEXT -- порядок виконання вправи
);

CREATE TABLE exercise_selections ( -- опис вибору вправ користувачами
    user_id BIGINT, -- ідентифікатор користувача
    exercise_id BIGINT -- ідентифікатор обраної вправи
);

CREATE TABLE preparation_instructions ( -- опис інструкцій з підготовки
    exercise_id BIGINT, -- ідентифікатор вправи
    preparation_steps TEXT -- послідовність підготовчих дій
);

CREATE TABLE exercise_executions ( -- опис виконань вправ
    execution_id BIGINT, -- ідентифікатор виконання вправи
    user_id BIGINT, -- ідентифікатор користувача
    exercise_id BIGINT -- ідентифікатор вправи
);

CREATE TABLE movement_measurements ( -- опис вимірювань руху
    measurement_id BIGINT, -- ідентифікатор вимірювання
    execution_id BIGINT, -- ідентифікатор виконання вправи
    time_mark NUMERIC, -- часова позначка вимірювання
    acceleration_x DOUBLE PRECISION, -- прискорення X, м/с²
    acceleration_y DOUBLE PRECISION, -- прискорення Y, м/с²
    acceleration_z DOUBLE PRECISION, -- прискорення Z, м/с²
    angular_velocity_x DOUBLE PRECISION, -- кутова швидкість X, рад/с
    angular_velocity_y DOUBLE PRECISION, -- кутова швидкість Y, рад/с
    angular_velocity_z DOUBLE PRECISION -- кутова швидкість Z, рад/с
);

CREATE TABLE gait_results ( -- опис результатів аналізу ходи
    execution_id BIGINT, -- ідентифікатор виконання вправи
    cadence DOUBLE PRECISION, -- темп ходи, кроків за хвилину
    step_count INTEGER, -- кількість кроків
    movement_stability DOUBLE PRECISION -- показник стабільності рухів, %
);

/* Команди обмеження цілісності даних */

-- Встановлення обмеження первинного ключа
ALTER TABLE users ADD CONSTRAINT users_pk
    PRIMARY KEY (user_id);

ALTER TABLE exercises ADD CONSTRAINT exercises_pk
    PRIMARY KEY (exercise_id);

ALTER TABLE exercise_selections ADD CONSTRAINT exercise_selections_pk
    PRIMARY KEY (user_id, exercise_id);

ALTER TABLE preparation_instructions ADD CONSTRAINT preparation_instructions_pk
    PRIMARY KEY (exercise_id);

ALTER TABLE exercise_executions ADD CONSTRAINT exercise_executions_pk
    PRIMARY KEY (execution_id);

ALTER TABLE movement_measurements ADD CONSTRAINT movement_measurements_pk
    PRIMARY KEY (measurement_id);

ALTER TABLE gait_results ADD CONSTRAINT gait_results_pk
    PRIMARY KEY (execution_id);

/*
Обмеження зовнішнього ключа
*/

ALTER TABLE exercise_selections ADD CONSTRAINT selections_user_fk
    FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE exercise_selections ADD CONSTRAINT selections_exercise_fk
    FOREIGN KEY (exercise_id) REFERENCES exercises (exercise_id);

ALTER TABLE preparation_instructions ADD CONSTRAINT instructions_exercise_fk
    FOREIGN KEY (exercise_id) REFERENCES exercises (exercise_id);

ALTER TABLE exercise_executions ADD CONSTRAINT executions_user_fk
    FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE exercise_executions ADD CONSTRAINT executions_exercise_fk
    FOREIGN KEY (exercise_id) REFERENCES exercises (exercise_id);

ALTER TABLE movement_measurements ADD CONSTRAINT measurements_execution_fk
    FOREIGN KEY (execution_id) REFERENCES exercise_executions (execution_id);

ALTER TABLE gait_results ADD CONSTRAINT results_execution_fk
    FOREIGN KEY (execution_id) REFERENCES exercise_executions (execution_id);

/*
Встановлення обов’язковості значень атрибутів
*/

ALTER TABLE exercises ALTER COLUMN name SET NOT NULL;
ALTER TABLE exercises ALTER COLUMN purpose SET NOT NULL;
ALTER TABLE exercises ALTER COLUMN execution_order SET NOT NULL;

ALTER TABLE preparation_instructions
    ALTER COLUMN preparation_steps SET NOT NULL;

ALTER TABLE exercise_executions ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE exercise_executions ALTER COLUMN exercise_id SET NOT NULL;

ALTER TABLE movement_measurements ALTER COLUMN execution_id SET NOT NULL;
ALTER TABLE movement_measurements ALTER COLUMN time_mark SET NOT NULL;
ALTER TABLE movement_measurements ALTER COLUMN acceleration_x SET NOT NULL;
ALTER TABLE movement_measurements ALTER COLUMN acceleration_y SET NOT NULL;
ALTER TABLE movement_measurements ALTER COLUMN acceleration_z SET NOT NULL;
ALTER TABLE movement_measurements ALTER COLUMN angular_velocity_x SET NOT NULL;
ALTER TABLE movement_measurements ALTER COLUMN angular_velocity_y SET NOT NULL;
ALTER TABLE movement_measurements ALTER COLUMN angular_velocity_z SET NOT NULL;

ALTER TABLE gait_results ALTER COLUMN cadence SET NOT NULL;
ALTER TABLE gait_results ALTER COLUMN step_count SET NOT NULL;
ALTER TABLE gait_results ALTER COLUMN movement_stability SET NOT NULL;

/*
Встановлення обмеження вмісту стовпця таблиці
*/

ALTER TABLE exercises ADD CONSTRAINT exercises_order_check
    CHECK (LENGTH(TRIM(execution_order)) > 0);

ALTER TABLE preparation_instructions ADD CONSTRAINT preparation_steps_check
    CHECK (LENGTH(TRIM(preparation_steps)) > 0);

ALTER TABLE movement_measurements ADD CONSTRAINT measurement_time_check
    CHECK (time_mark >= 0);

ALTER TABLE gait_results ADD CONSTRAINT cadence_check
    CHECK (cadence >= 0);

ALTER TABLE gait_results ADD CONSTRAINT step_count_check
    CHECK (step_count >= 0);

ALTER TABLE gait_results ADD CONSTRAINT movement_stability_check
    CHECK (movement_stability >= 0);

-- Встановлення обмеження вмісту стовпця таблиці регулярним виразом
ALTER TABLE exercises ADD CONSTRAINT exercises_name_template
    CHECK (name ~ '[^[:space:]]');

-- Встановлення обмеження вмісту стовпця таблиці регулярним виразом
ALTER TABLE exercises ADD CONSTRAINT exercises_purpose_template
    CHECK (purpose ~ '[^[:space:]]');
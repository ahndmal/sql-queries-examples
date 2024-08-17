
CREATE OR REPLACE FUNCTION record_if_grade_changed()
RETURNS trigger AS
$$
BEGIN
    IF NEW.grade <> OLD.grade THEN
    INSERT INTO grades_history (
        student_id,
        course_id,
        change_time,
        course,
        old_grade,
        new_grade)
    VALUES
        (OLD.student_id,
         OLD.course_id,
         now(),
         OLD.course,
         OLD.grade,
         NEW.grade);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER grades_update
  AFTER UPDATE
    ON grades
  FOR EACH ROW
  EXECUTE PROCEDURE record_if_grade_changed();


CREATE OR REPLACE FUNCTION classify_max_temp()
RETURNS trigger AS
$$
BEGIN
    CASE
        WHEN NEW.max_temp >= 90 THEN
        NEW.max_temp_group := 'Hot';
        WHEN NEW.max_temp BETWEEN 70 AND 89 THEN
        NEW.max_temp_group := 'Warm';
        WHEN NEW.max_temp BETWEEN 50 AND 69 THEN
        NEW.max_temp_group := 'Pleasant';
        WHEN NEW.max_temp BETWEEN 33 AND 49 THEN
        NEW.max_temp_group := 'Cold';
        WHEN NEW.max_temp BETWEEN 20 AND 32 THEN
        NEW.max_temp_group := 'Freezing';
        ELSE NEW.max_temp_group := 'Inhumane';
    END CASE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER temperature_insert
    BEFORE INSERT
    ON temperature_test
    FOR EACH ROW
    EXECUTE PROCEDURE classify_max_temp();


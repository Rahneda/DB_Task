-- task 1
CREATE VIEW sales_revenue_by_category_qtr AS
WITH current_quarter AS (
    SELECT EXTRACT(YEAR FROM CURRENT_DATE) AS year,
           CEIL(EXTRACT(MONTH FROM CURRENT_DATE) / 3.0) AS quarter
),
quarter_start_end AS (
    SELECT 
        year,
        quarter,
        (date_trunc('quarter', make_date(year::integer, ((quarter::integer-1) * 3 + 1)::integer, 1)))::date AS quarter_start,
        (date_trunc('quarter', make_date(year::integer, ((quarter::integer-1) * 3 + 1)::integer, 1)) + interval '3 month - 1 day')::date AS quarter_end
    FROM current_quarter
)
SELECT
    c.name AS category,
    SUM(p.amount) AS total_sales_revenue
FROM
    payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN quarter_start_end qse ON r.rental_date BETWEEN qse.quarter_start AND qse.quarter_end
GROUP BY c.name
HAVING SUM(p.amount) > 0;




-- task 2
CREATE OR REPLACE FUNCTION get_sales_revenue_by_category_qtr(quarter_text TEXT)
RETURNS TABLE(category TEXT, total_sales_revenue NUMERIC) AS $$
DECLARE
    quarter_start DATE;
    quarter_end DATE;
    quarter_year INT;
    quarter_num INT;
BEGIN
    -- Извлечение года и квартала из входного параметра
    quarter_year := (substring(quarter_text from 1 for 4))::INT;
    quarter_num := (substring(quarter_text from 6 for 1))::INT;

    -- Определение начала и конца квартала
    quarter_start := date_trunc('quarter', make_date(quarter_year, (quarter_num - 1) * 3 + 1, 1))::DATE;
    quarter_end := (quarter_start + INTERVAL '3 month - 1 day')::DATE;

    -- Возврат результатов
    RETURN QUERY
    SELECT
        c.name AS category,
        SUM(p.amount) AS total_sales_revenue
    FROM
        payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE r.rental_date BETWEEN quarter_start AND quarter_end
    GROUP BY c.name
    HAVING SUM(p.amount) > 0;
END;
$$ LANGUAGE plpgsql;




-- task 3
CREATE OR REPLACE FUNCTION new_movie(movie_title TEXT)
RETURNS VOID AS $$
DECLARE
    new_film_id INT;
    lang_id INT;
BEGIN
    -- Проверка наличия языка Klingon в таблице language
    SELECT language_id INTO lang_id
    FROM language
    WHERE name = 'Klingon';

    -- Если языка Klingon нет, добавляем его
    IF NOT FOUND THEN
        INSERT INTO language (name)
        VALUES ('Klingon')
        RETURNING language_id INTO lang_id;
    END IF;

    -- Генерация нового уникального film_id
    SELECT MAX(film_id) + 1 INTO new_film_id
    FROM film;

    -- Вставка нового фильма в таблицу film
    INSERT INTO film (film_id, title, rental_rate, rental_duration, replacement_cost, release_year, language_id)
    VALUES (new_film_id, movie_title, 4.99, 3, 19.99, EXTRACT(YEAR FROM CURRENT_DATE)::INT, lang_id);

    -- Вывод сообщения о добавлении нового фильма
    RAISE NOTICE 'Added new movie "%"', movie_title;
END;
$$ LANGUAGE plpgsql;



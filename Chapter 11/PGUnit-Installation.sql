-- reinstall.sql
-- \o '/dev/null'
-- \set QUIET on
-- \set ON_ERROR_ROLLBACK on
-- \set ON_ERROR_STOP on
SET CLIENT_MIN_MESSAGES = ERROR;
BEGIN;
-- \echo
-- \echo 'Reinstall..'
-- \echo
-- \echo 'Remove pgunit'
DROP SCHEMA IF EXISTS pgunit CASCADE;

-- install.sql
-- \o '/dev/null'
-- \set QUIET on
-- \set ON_ERROR_ROLLBACK on
-- \set ON_ERROR_STOP on

SET CLIENT_MIN_MESSAGES = ERROR;

BEGIN;

CREATE SCHEMA pgunit;

-- \echo
-- \echo 'Install pgunit'
-- \echo

-- \echo 'Creating assert_array_equals...'
-- install.sql -- assert_array_equals.sp.sql
CREATE OR REPLACE FUNCTION pgunit.assert_array_equals(
    IN _expected anyelement,
    IN _actual anyelement,
    IN _message varchar
) RETURNS void AS
$BODY$
BEGIN
    IF _expected IS NULL THEN
        RAISE EXCEPTION '#incorrect_expected_value NULL';
    END IF;
    IF NOT (_expected::varchar[] @> _actual::varchar[] AND _actual::varchar[] @> _expected::varchar[])
        OR _actual IS NULL
        OR (array_dims(_expected) <> array_dims(_actual))
    THEN
        RAISE EXCEPTION E'#assert_array_equals\n%\nExpected: %\nActual: %', _message, _expected, _actual;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating assert_equals...'
-- install.sql -- assert_equals.sp.sql
CREATE OR REPLACE FUNCTION pgunit.assert_equals(
    IN _expected anyelement,
    IN _actual anyelement,
    IN _message varchar
) RETURNS void AS
$BODY$
BEGIN
    IF _expected IS NULL THEN
        RAISE EXCEPTION '#incorrect_expected_value NULL';
    END IF;
    IF _expected IS DISTINCT FROM _actual THEN
        RAISE EXCEPTION E'#assert_equals\n%\nExpected: %\nActual: %', _message, _expected, _actual;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating test_assert_array_equals...'
-- install.sql -- assert_false.sp.sql
CREATE OR REPLACE FUNCTION pgunit.assert_false(
    IN _value boolean,
    IN _message varchar
) RETURNS void AS
$BODY$
BEGIN
    IF _value OR _value IS NULL THEN
        RAISE EXCEPTION E'#assert_false\n%\nValue: %', _message, _value;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating assert_not_equals...'
-- install.sql -- assert_not_equals.sp.sql
CREATE OR REPLACE FUNCTION pgunit.assert_not_equals(
    IN _expected anyelement,
    IN _actual anyelement,
    IN _message varchar
) RETURNS void AS
$BODY$
BEGIN
    IF _expected IS NULL THEN
        RAISE EXCEPTION '#incorrect_expected_value NULL';
    END IF;
    IF _expected IS NOT DISTINCT FROM _actual THEN
        RAISE EXCEPTION E'#assert_not_equals\n%\nExpected: %\nActual: %', _message, _expected, _actual;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating assert_not_null...'
-- install.sql -- assert_not_null.sp.sql
CREATE OR REPLACE FUNCTION pgunit.assert_not_null(
    IN _value anyelement,
    IN _message varchar
) RETURNS void AS
$BODY$
BEGIN
    IF _value IS NULL THEN
        RAISE EXCEPTION E'#assert_not_null\n%', _message;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating assert_null...'
-- install.sql -- assert_null.sp.sql
CREATE OR REPLACE FUNCTION pgunit.assert_null(
    IN _value anyelement,
    IN _message varchar
) RETURNS void AS
$BODY$
BEGIN
    IF _value IS NOT NULL THEN
        RAISE EXCEPTION E'#assert_null\n%\nValue: %', _message, _value;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating assert_true...'
-- install.sql -- assert_true.sp.sql
CREATE OR REPLACE FUNCTION pgunit.assert_true(
    IN _value boolean,
    IN _message varchar
) RETURNS void AS
$BODY$
BEGIN
    IF NOT _value OR _value IS NULL THEN
        RAISE EXCEPTION E'#assert_true\n%\nValue: %', _message, _value;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating fail...'
-- install.sql -- fail.sp.sql
CREATE OR REPLACE FUNCTION pgunit.fail(
    IN _message varchar
) RETURNS void AS
$BODY$
BEGIN
    RAISE EXCEPTION E'#fail\n%', _message;
END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating run_test...'
-- install.sql -- run_test.sp.sql
CREATE OR REPLACE FUNCTION pgunit.run_test(
    IN _sp varchar
) RETURNS character varying
AS
$BODY$
BEGIN
    EXECUTE 'SELECT ' || _sp;
    RAISE EXCEPTION '#OK';
EXCEPTION
    WHEN others THEN
        RETURN SQLERRM;
    END;
$BODY$
LANGUAGE plpgsql;

-- install.sql -- test -- install.sql
-- \echo
-- \echo 'Installation test'
-- \echo

-- \echo 'Creating test_assert_array_equals...'
-- install.sql -- test -- test_assert_array_equals.sp.sql
CREATE OR REPLACE FUNCTION pgunit.test_assert_array_equals() RETURNS void AS
$BODY$
DECLARE
    _message varchar;
BEGIN
    _message := 'qazwsxedc';

    -- EMPTY ARRAYS

    PERFORM pgunit.assert_array_equals('{}'::varchar[], '{}'::varchar[], _message);

    BEGIN
        PERFORM pgunit.assert_array_equals('{}'::varchar[], array['1']::varchar[], _message);
        RAISE EXCEPTION 'Epic fail. Line: 18';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
                RAISE;
            END IF;
    END;

    BEGIN
        PERFORM pgunit.assert_array_equals(array['1']::varchar[], '{}'::varchar[], _message);
        RAISE EXCEPTION 'Epic fail. Line: 28';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
                RAISE;
            END IF;
    END;

    BEGIN
        PERFORM pgunit.assert_array_equals(array['1']::varchar[], NULL::varchar[], _message);
        RAISE EXCEPTION 'Epic fail. Line: 38';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
                RAISE;
            END IF;
    END;

    BEGIN
        PERFORM pgunit.assert_array_equals('{}'::varchar[], NULL::varchar[], _message);
        RAISE EXCEPTION 'Epic fail. Line: 48';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
                RAISE;
            END IF;
    END;

    BEGIN
        PERFORM pgunit.assert_array_equals(NULL::varchar[], array['1']::varchar[], _message);
        RAISE EXCEPTION 'Epic fail. Line: 58';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#incorrect_expected_value %' THEN
                RAISE;
            END IF;
    END;

    -- UNARY ARRAY

    PERFORM pgunit.assert_array_equals(array['1']::varchar[], array['1']::varchar[], _message);

    BEGIN
        PERFORM pgunit.assert_array_equals(array['2']::varchar[], array['1']::varchar[], _message);
        RAISE EXCEPTION 'Epic fail. Line: 72';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
                RAISE;
            END IF;
    END;

    -- ARRAYS

    PERFORM pgunit.assert_array_equals(array['1', '2']::varchar[], array['1', '2']::varchar[], _message);
    PERFORM pgunit.assert_array_equals(array['2', '1']::varchar[], array['1', '2']::varchar[], _message);
    PERFORM pgunit.assert_array_equals(array['1', '2', '3']::varchar[], array['1', '3', '2']::varchar[], _message);


    BEGIN
        PERFORM pgunit.assert_array_equals(array['1', '2', '3']::varchar[], array['1', '3', '2', '2']::varchar[], _message);
        RAISE EXCEPTION 'Epic fail. Line: 77';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
                RAISE;
        END IF;
    END;


    BEGIN
        PERFORM pgunit.assert_array_equals(array['1', '2', '3']::varchar[], array['1', '2', '2']::varchar[], _message);
        RAISE EXCEPTION 'Epic fail. Line: 89';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
                RAISE;
            END IF;
    END;

    BEGIN
        PERFORM pgunit.assert_array_equals(array['1', '2', '3']::varchar[], array['4', '5', '6']::varchar[], _message);
        RAISE EXCEPTION 'Epic fail. Line: 99';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_array_equals\n%' THEN
                RAISE;
            END IF;
    END;
END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating test_assert_equals...'
-- install.sql -- test -- test_assert_equals.sp.sql
CREATE OR REPLACE FUNCTION pgunit.test_assert_equals() RETURNS void AS
$BODY$
DECLARE

 _message varchar;
BEGIN
    _message := 'qazwsxedc';

    -- INT

    PERFORM pgunit.assert_equals(1::int, 1::int, _message);

    BEGIN
        PERFORM pgunit.assert_equals(1::int, 2::int, _message);
        RAISE EXCEPTION 'Epic fail. Line: 18';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
                RAISE;
            END IF;
    END;

    BEGIN
        PERFORM pgunit.assert_equals(1::int, NULL::int, _message);
        RAISE EXCEPTION 'Epic fail. Line: 28';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
                RAISE;
            END IF;
    END;

    -- INT8

    PERFORM pgunit.assert_equals(1::int8, 1::int8, _message);

    BEGIN
        PERFORM pgunit.assert_equals(1::int8, 2::int8, _message);
        RAISE EXCEPTION 'Epic fail. Line: 42';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
                RAISE;
            END IF;
    END;

    -- NUMERIC

    PERFORM pgunit.assert_equals(1.1::numeric, 1.1::numeric, _message);

    BEGIN
        PERFORM pgunit.assert_equals(1.1::numeric, 1.2::numeric, _message);
        RAISE EXCEPTION 'Epic fail. Line: 56';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
                RAISE;
            END IF;
    END;

    -- VARCHAR

    PERFORM pgunit.assert_equals('1.1'::varchar, '1.1'::varchar, _message);

    BEGIN
        PERFORM pgunit.assert_equals('1.1'::varchar, '1.1 '::varchar, _message);
        RAISE EXCEPTION 'Epic fail. Line: 70';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
                RAISE;
            END IF;
    END;

    -- TEXT

    PERFORM pgunit.assert_equals('1.1'::text, '1.1'::text, _message);

    BEGIN
        PERFORM pgunit.assert_equals('1.1'::text, '1.1 '::text, _message);
        RAISE EXCEPTION 'Epic fail. Line: 84';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_equals\n%' THEN
                RAISE;
            END IF;
        END;
    END;
$BODY$
LANGUAGE plpgsql;

-- \echo 'Creating test_assert_false...'
-- install.sql -- test -- test_assert_false.sp.sql
CREATE OR REPLACE FUNCTION pgunit.test_assert_false() RETURNS void AS
$BODY$
DECLARE

    _message varchar;
BEGIN
    _message := 'qazwsxedc';

    PERFORM pgunit.assert_false(False, _message);

    BEGIN
        PERFORM pgunit.assert_false(True, _message);
        RAISE EXCEPTION 'Epic fail. Line: 16';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_false\n%' THEN
                RAISE;
            END IF;
    END;

    BEGIN
        PERFORM pgunit.assert_false(NULL::boolean, _message);
        RAISE EXCEPTION 'Epic fail. Line: 26';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_false\n%' THEN
                RAISE;
            END IF;
    END;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- \echo 'Creating test_assert_not_null...'
-- install.sql -- test -- test_assert_not_null.sp.sql
CREATE OR REPLACE FUNCTION pgunit.test_assert_not_null() RETURNS void AS
$BODY$
DECLARE

    _message varchar;
BEGIN
    _message := 'qazwsxedc';

    -- INT4

    PERFORM pgunit.assert_not_null(1::int4, _message);

    BEGIN
        PERFORM pgunit.assert_not_null(NULL::int4, _message);
        RAISE EXCEPTION 'Epic fail. Line: 18';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
                RAISE;
            END IF;
    END;

    -- INT8

    PERFORM pgunit.assert_not_null(1::int8, _message);

    BEGIN
        PERFORM pgunit.assert_not_null(NULL::int8, _message);
        RAISE EXCEPTION 'Epic fail. Line: 32';
    EXCEPTION
        WHEN others THEN
            IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
                RAISE;
            END IF;
    END;

    -- NUMERIC

    PERFORM pgunit.assert_not_null(1.1::numeric, _message);

    BEGIN
        PERFORM pgunit.assert_not_null(NULL::numeric, _message);
        RAISE EXCEPTION 'Epic fail. Line: 46';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
            RAISE;
        END IF;
    END;

    -- VARCHAR

    PERFORM pgunit.assert_not_null('1.1'::varchar, _message);

    BEGIN
        PERFORM pgunit.assert_not_null(NULL::varchar, _message);
        RAISE EXCEPTION 'Epic fail. Line: 60';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
            RAISE;
        END IF;
    END;

    -- TEXT

        PERFORM pgunit.assert_not_null('1.1'::text, _message);

    BEGIN
        PERFORM pgunit.assert_not_null(NULL::text, _message);
        RAISE EXCEPTION 'Epic fail. Line: 74';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_not_null\n%' THEN
            RAISE;
        END IF;
    END;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- \echo 'Creating test_assert_null...'
-- install.sql -- test -- test_assert_null.sp.sql
CREATE OR REPLACE FUNCTION pgunit.test_assert_null() RETURNS void AS
$BODY$
DECLARE

    _message varchar;
BEGIN
    _message := 'qazwsxedc';

    -- INT4

        PERFORM pgunit.assert_null(NULL::int4, _message);

    BEGIN
        PERFORM pgunit.assert_null(1::int4, _message);
        RAISE EXCEPTION 'Epic fail. Line: 18';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
            RAISE;
        END IF;
    END;

    -- INT8

    PERFORM pgunit.assert_null(NULL::int8, _message);


    BEGIN
        PERFORM pgunit.assert_null(1::int8, _message);
        RAISE EXCEPTION 'Epic fail. Line: 33';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
            RAISE;
        END IF;
    END;

    -- NUMERIC

    PERFORM pgunit.assert_null(NULL::numeric, _message);

    BEGIN
        PERFORM pgunit.assert_null(1.1::numeric, _message);
        RAISE EXCEPTION 'Epic fail. Line: 47';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
            RAISE;
        END IF;
    END;

    -- VARCHAR

    PERFORM pgunit.assert_null(NULL::varchar, _message);

    BEGIN
        PERFORM pgunit.assert_null('1.1'::varchar, _message);
        RAISE EXCEPTION 'Epic fail. Line: 61';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
            RAISE;
        END IF;
    END;

    -- TEXT

    PERFORM pgunit.assert_null(NULL::text, _message);

    BEGIN
        PERFORM pgunit.assert_null('1.1'::text, _message);
        RAISE EXCEPTION 'Epic fail. Line: 75';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_null\n%' THEN
            RAISE;
        END IF;
    END;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- \echo 'Creating test_assert_true...'
-- install.sql -- test -- test_assert_true.sp.sql
CREATE OR REPLACE FUNCTION pgunit.test_assert_true() RETURNS void AS
$BODY$
DECLARE
    _message varchar;
BEGIN
    _message := 'qazwsxedc';

    PERFORM pgunit.assert_true(True, _message);

    BEGIN
        PERFORM pgunit.assert_true(False, _message);
        RAISE EXCEPTION 'Epic fail. Line: 16';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_true\n%' THEN
            RAISE;
        END IF;
    END;

    BEGIN
        PERFORM pgunit.assert_true(NULL::boolean, _message);
        RAISE EXCEPTION 'Epic fail. Line: 26';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#assert_true\n%' THEN
            RAISE;
        END IF;
    END;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- \echo 'Creating test_fail...'
-- install.sql -- test -- test_fail.sp.sql
CREATE OR REPLACE FUNCTION pgunit.test_fail() RETURNS void AS
$BODY$
DECLARE
    _message text;
BEGIN
    _message := 'qazwxedc';
    BEGIN
        PERFORM pgunit.fail(_message);
        RAISE EXCEPTION 'Epic fail. Line: 14';
    EXCEPTION
    WHEN others THEN
        IF SQLERRM NOT ILIKE E'#fail\n%' THEN
            RAISE;
        END IF;
    END;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- install.sql -- test -- selftest.sql
-- \echo
-- \echo 'Run self tests'
-- \echo

-- \echo 'Run test_assert_array_equals'
SELECT pgunit.test_assert_array_equals();

-- \echo 'Run test_assert_equals'
SELECT pgunit.test_assert_equals();

-- \echo 'Run test_assert_false'
SELECT pgunit.test_assert_false();

-- \echo 'Run test_assert_not_null'
SELECT pgunit.test_assert_not_null();

-- \echo 'Run test_assert_null'
SELECT pgunit.test_assert_null();

-- \echo 'Run test_assert_true'
SELECT pgunit.test_assert_true();

-- \echo 'Run test_fail'
SELECT pgunit.test_fail();

COMMIT;

-- \echo
-- \echo 'Installation complete.'
-- \echo